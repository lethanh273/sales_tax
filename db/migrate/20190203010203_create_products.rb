class CreateProducts < ActiveRecord::Migration
  def change
    create_table "products" do |t|
      t.string  "code",                        :null => false
      t.string  "name",                        :null => false
      t.float    "price",                 :limit => 10,  :default => 0.0
    end
  end
end
