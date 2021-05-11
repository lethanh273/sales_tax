class CreateCartItems < ActiveRecord::Migration
  def change
    create_table "cart_items" do |t|
      t.integer  "checkout_id",                        :null => false
      t.integer  "product_id",                        :null => false
      t.integer  "quantity"
    end
  end
end
