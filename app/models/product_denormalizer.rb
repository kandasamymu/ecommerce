# frozen_string_literal: true

class ProductDenormalizer
  attr_reader :product

  def initialize(product)
    @product = product
  end

  def to_hash
    {
      id: @product.id,
      name: @product.name,
      price: @product.price,
      description: @product.description
    }
  end
end
