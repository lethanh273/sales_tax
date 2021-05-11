require 'rails_helper.rb'
require 'csv'
require 'factory_girl_rails'

module TestHelper
  def self.create_product(price)
    product = FactoryGirl.build :product, price: price
    yield product if block_given?
    product.save!
    product
  end

  def self.create_cart(products)
    checkout = Checkout.create
    add_cart = checkout.method :scan
    products.map(&:id).each(&add_cart)
    yield checkout if block_given?
    checkout
  end
end

describe "add to cart" do
  before do
    product = TestHelper.create_product 27.99
    product.name = "imported bottle of perfume"
    product.save!

    product1 = TestHelper.create_product 18.99
    product1.name = "bottle of perfume"
    product1.save!

    product2 = TestHelper.create_product 9.75
    product2.name = "packet of headache pills"
    product2.save!

    product3 = TestHelper.create_product 11.25
    product3.name = "box of imported chocolates"
    product3.save!

    ar = [product, product1, product2, product3]
    @checkout= TestHelper.create_cart ar
    @checkout.save!
  end
  it 'return correct sales tax' do
    expect(@checkout.subtotal).to eq(74.64)
    expect(@checkout.sales_tax).to eq(6.66)
  end
end

describe "print csv" do
  before do
    csv_text = File.read('/Users/thanhle/Downloads/sales_tax/sales_tax/input.csv')
    csv = CSV.parse(csv_text, :headers => true)
    ar = []
    csv.each do |row|
      product = TestHelper.create_product row[2]
      product.name = row[1]
      product.save!
      ar << product
    end
    @checkout1= TestHelper.create_cart ar
    @checkout1.save!
    rows = []
    @checkout1.cart_items.each do |t|
      line = [t.quantity.to_s,t.product.name.to_s, t.subtotal.to_s]
      rows << line
    end
    File.write("output.csv", rows.map(&:to_csv).join)
  end
  it 'print correct csv' do
    res ="1, imported bottle of perfume,32.19\n1, bottle of perfume,20.89\n1, packet of headache pills,9.75\n1, box of imported chocolates,11.81\nSales Taxes: 6.66 + '\n'Total: 74.64 + '\n'"
    expect(@checkout1.print_csv).to eq(res)
  end
end
