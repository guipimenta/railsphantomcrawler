module StockWatchHelper

	module Crawlers
		require 'rubygems'
		require 'nokogiri'
		require 'open-uri'
		require 'capybara'
		require 'capybara/poltergeist'
		require "capybara/dsl" 

		class UolCrawler
			include Capybara::DSL

			def initialize(stock_name)
			#basics strings
			@stock_name = stock_name
			@base_url = "http://economia.uol.com.br/"
			@middleUrl = "cotacoes/bolsas/acoes/bvsp-bovespa/"
			@endUrl = "/?historico"	
			@url = @middleUrl + stock_name + @endUrl

			puts "Crawling url: " + @url
			
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

			@stockmodel = Stock.new
			@stockmodel.name = stock_name
		end
		
		# crawl given stock
		def crawl
			visit @url

			html_doc = Nokogiri::HTML(page.body)

			quotes = Array.new

			html_doc.css('div#result table tbody tr').each do |line| 


				quote = line.css("td")

				value = StockValue.new
				value.date = quote[0].text
				value.close = quote[1].text.sub ",", "."
				value.low = quote[4].text.sub ",", "."
				value.high = quote[5].text.sub ",", "."
				value.volume = quote[6].text.sub ".", ","


				quotes.push value
			end

			return quotes
		end
	end
end
end
