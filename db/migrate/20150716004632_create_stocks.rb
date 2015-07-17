class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.text :name
      

      t.timestamps null: false
    end
    #add_foreign_key :stocks, :stock_values
  end
end
