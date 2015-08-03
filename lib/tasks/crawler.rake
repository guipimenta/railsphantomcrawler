require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'capybara'
require 'capybara/poltergeist'


module Crawlers
	require "capybara/dsl"
	class UolCrawler
		include Capybara::DSL

		def initialize(stock_name)
			#basics strings
			time = Time.new
			day = time.day
			month = time.month
			year = time.year
			@base_url = "http://cotacoes.economia.uol.com.br/acao/cotacoes-historicas.html?codigo="
			@end_url = "&beginDay=17&beginMonth=7&beginYear=2000&endDay=#{day}&endMonth=#{month}&endYear=#{year}&page=1&size=200"
			@url = @base_url + stock_name + @end_url
			@stock_name = stock_name

			#Basic capybara setup
			Capybara.default_driver = :poltergeist
			Capybara.javascript_driver = :poltergeist
			Capybara.register_driver :poltergeist do |app|
				Capybara::Poltergeist::Driver.new(app, {
					:js_errors => false,
					:inspector => false,
					:timeout => 90,
					phantomjs_logger: open('/dev/null') # if you don't care about JS errors/console.logs
				})
			end
			Capybara.run_server = false
			Capybara.app_host = @base_url

			#Finds model
			if !Stock.where(:name == stock_name).empty?
				puts "Not Empty"
				puts"Stock name: #{stock_name}"
				@stock_model = Stock.where(:name => stock_name).first
				last_result = @stock_model.stock_value.order("us_date")
				if !last_result.empty?
					@last_date = last_result.last.br_date
				else
					@last_date = nil
				end
			else
				puts "Not empty"
				@stock_model = Stock.new
				@stock_model.name = stock_name
				@stock_model.save
				@last_date = nil
			end
			puts "Last date: #{@last_date}"
			puts "Crawling url: #{@url}"
		end

		# crawl given stock
		def crawl
			visit @url
			html_doc = Nokogiri::HTML(page.body)
			values = Array.new

			html_doc.css('table#tblInterday tbody tr').each do |line|
				quote = line.css("td")

				value = StockValue.new
				value.br_date = quote[0].text
				value.us_date = convert_br_us value.br_date

				if !@last_date.nil?
					if value.br_date == @last_date
						save_results(values)
						return
					end
				end

				value.value = quote[1].text.sub ",", "."
				value.variance = quote[4].text.sub ",", "."
				value.variancepercent = quote[5].text.sub ",", "."
				value.low = quote[2].text.sub ",", "."
				value.high = quote[3].text.sub ",", "."
				# "Typecast" to integer value on database
				value.volume = quote[6].text.sub ".", ""

				values.push value
			end

			puts "crawled: #{values.size} \n"
			save_results(values)
			get_next html_doc
		end

		def convert_br_us date
			splited = date.split('/')
			return "#{splited[2]}-#{splited[1]}-#{splited[0]}"
		end


		def get_next html_doc
			nextref = html_doc.css('li#lnk-proxima a')
			if !nextref.empty?
				href = nextref[0]['href']
				#@url = @middleUrl + @stock_name + href
				@url = href
				crawl
			end
		end


		def save_results values
			puts "Saving: #{values.size}\n"
			values.each do |value|
				@stock_model.stock_value.push value
			end
			@stock_model.save
		end


	end
end


namespace :stock do

  desc "Imports users' data from a given CSV file"

  # Task used to crawl all files
  task :crawl => :environment do |task|
  	Stock.all.each do |stock|
  		crawler = Crawlers::UolCrawler.new stock.name
  		crawler.crawl
  	end
  end

end
