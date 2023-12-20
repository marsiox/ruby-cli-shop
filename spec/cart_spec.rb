require 'spec_helper'
require_relative '../app/product'
require_relative '../app/cart'
require_relative '../app/cart_item'

RSpec.describe Cart do
  let(:product1) { Product.new('abc123', 'Banana', 33.22) }
  let(:product2) { Product.new('def456', 'Apple', 10.50) }

  describe '#add_item' do
    let(:cart) { Cart.new }

    before do
      subject.add_item(product1)
    end

    it 'adds item to cart' do
      expect(subject.items.size).to eq(1)
      expect(subject.items.first.product).to eq(product1)
    end
  end

  describe '#total_price' do
    let(:cart) { Cart.new }

    before do
      subject.add_item(product1)
      subject.add_item(product1)
      subject.add_item(product2)
    end

    it 'calculates total price' do
      expect(subject.total_price).to eq(76.94)
    end
  end
end
