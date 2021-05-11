require 'csv'

csv_text = File.read('input.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  p row[0]
  p = Product.new
  p.name = row[1]

  p row[2]
  #CartItem.create!(row.to_hash)
end
ar = [product, product1, product2, product3]
