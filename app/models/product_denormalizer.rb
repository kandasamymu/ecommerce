class ProductDenormalizer
  attr_reader :product

  def initialize(product)
    @product = product
  end

  def to_hash
    %w[id
       name
       price
       description]
      .map { |method_name| [method_name, send(method_name)] }.to_h
  end

  delegate :id, to: :product

  delegate :name, to: :product

  delegate :price, to: :product

  delegate :description, to: :product

  delegate :product_category_id, to: :product

  def product_category
    { id: product.product_category.id, name: product.product_category.name }
  end
end
