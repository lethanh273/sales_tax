class Checkout < ActiveRecord::Base

  has_many :cart_items, :dependent => :destroy

  def scan(product_id, quantity = 1)
    product_id = product_id.to_i
    cart_item = CartItem.new(
      :quantity  => quantity.to_i,
      :product_id   => product_id.to_i,
      :checkout_id   => self.id
    )
    self.cart_items << cart_item
  end

  def subtotal
    sum = 0
    self.cart_items.each do |t|
      sum+=t.subtotal
    end
    sum.round(2)
  end

  def sales_tax
    sum = 0
    self.cart_items.each do |t|
      sum+=t.tax
    end
    sum.round(2)
  end

  def print_csv
    result = ""
    self.cart_items.each do |t|
      line = t.quantity.to_s + "," + t.product.name.to_s + "," + t.subtotal.to_s
      result += line + "\n"
    end
    sale = "Sales Taxes: #{self.sales_tax} + '\n'"
    total = "Total: #{self.subtotal} + '\n'"
    result += sale + total
  end
end
