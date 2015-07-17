require 'stock_watch_helper'
class StockWatchController < ApplicationController


	def index
	end

	def getQuotes
		name = params[:sname]
		crawler = StockWatchHelper::Crawlers::UolCrawler.new  name
		quotes =  crawler.crawl
		render json: {name: name, quotes: quotes}
	end



end
