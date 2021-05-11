class CartItem < ActiveRecord::Base
  belongs_to :checkout
  belongs_to :product

  def deal_amount
    self.product.price * self.quantity
  end

  def subtotal
    (self.deal_amount + self.tax).round(2)
  end

  def tax
    basic = deal_amount*0.1
    if self.product.name.match(/pill/).present? || self.product.name.match(/book/).present? || self.product.name.match(/chocolate/).present?
      basic = 0
    end
    add_ons = self.product.name.match(/import/).present? ? deal_amount*0.05 : 0
    basic + add_ons
  end
end