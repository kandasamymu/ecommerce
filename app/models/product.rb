# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :product_category, class_name: 'ProductCategory'
  has_many :order_products, class_name: 'OrderProduct', dependent: :destroy
  validates :product_category, presence: true

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def as_indexed_json(_options = {})
    ProductDenormalizer.new(self).to_hash
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            type: 'phrase_prefix',
            fields: %w[name description]
          }
        }
      }
    )
  end

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :id, type: :integer
      indexes :name, type: :text, analyzer: 'english'
      indexes :price, type: :float
      indexes :description, type: :text, analyzer: 'english'
    end
  end
end
