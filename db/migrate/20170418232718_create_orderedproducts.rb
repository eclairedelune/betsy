class CreateOrderedproducts < ActiveRecord::Migration[5.0]
  def change
    create_table :orderedproducts do |t|
      t.integer :quantity
      t.belongs_to :product
      t.belongs_to :order

      t.timestamps
    end
  end
end
