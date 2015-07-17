class CreateStockValues < ActiveRecord::Migration
  def change
    create_table :stock_values do |t|
      t.string :date
      t.float :value
      t.float :variance
      t.float :variancepercent
      t.float :low
      t.float :high
      t.integer :volume
      t.belongs_to :stock, index:true
      t.timestamps null: false
    end
  end
end
