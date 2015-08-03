require 'stock_watch_helper'
class StockWatchController < ApplicationController


	def index
	end

	def getStockNames
		name = params[:sname]
		if name.nil?
			render :json => {stocks: Stock.all}
		else
			stock = Stock.where(:name => name).first
			if stock.nil?
				render :json => {status: 500}
			else
				render :json => {name: stock.name, quotes: stock.stock_value.all}
			end
		end
	end

	def getStatus
		last_value = StockValue.order("us_date").all
		database_size = 0
		stock_count = 0
		if !last_value.empty?
			last_value = last_value.last
			if !last_value.nil?
				last_update = last_value.created_at
				last_update = last_update.strftime("%d/%m/%Y")

				database_size = StockValue.count
				stock_count = Stock.count

			end
		end

		render :json => {last_update: last_update, database_size: database_size, stock_count: stock_count}

	end

	def delete_stock
		id = params["id"]
		if Stock.find(id).stock_value.all.delete_all
			if Stock.delete(id)
				render :json => {status: 200}
			end
		end
	end

	def create
		name = params["name"]
		byebug
		if name.strip.size > 0
			if Stock.where(:name => name).size == 0
				stock = Stock.new
				stock.name = name
				if stock.save
					render :json => {status: 200}
					return
				end
			end
		end
		render :json => {status: 500}
	end

	def get_info
		id = params["id"]
		if Stock.find(id)
			stock = Stock.find(id)
			stock_values = Stock.find(id).stock_value.all
			render :json => {status: 200, stock: stock, stock_values: stock_values}
		end
	end

end
