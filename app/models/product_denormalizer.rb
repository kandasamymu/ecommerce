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

  def id
    product.id
  end

  def name
    product.name
  end

  def price
    product.price
  end

  def description
    product.description
  end

  def product_category_id
    product.product_category_id
  end

  def product_category
    { id: product.product_category.id, name: product.product_category.name }
  end
end
