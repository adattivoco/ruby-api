class Category
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :name,        type: String
  field :active,      type: Boolean, default: true
  field :type,        type: String, default: 'CATEGORY'
  field :key,         type: String
  field :summary,     type: String
  field :preferred,   type: Boolean, default: false
  field :icon,        type: String
  field :sort_order,  type: Integer, default: 1
  field :products,    type: Array, default: []

  validates_presence_of :name, :key, :type, :active
  validates_uniqueness_of :key
  validates :type, inclusion: { in: %w[CATEGORY VERTICAL BUNDLE],
                                message: '%{value} is not a valid type' }
  index(type: -1, sort_order: 1, name: 1)
  index(active: 1, preferred: 1, sort_order: 1, name: 1)
  index(type: 1, preferred: 1, sort_order: 1, name: 1)
  index({ key: 1 }, unique: true)
  index(products: 1)
end
