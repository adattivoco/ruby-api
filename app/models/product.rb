class Product
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  attr_accessor :score
  field :name,             type: String
  field :key,              type: String
  field :active,           type: Boolean, default: true
  field :logo_url,         type: String
  field :summary,          type: String
  field :sale_type,        type: String, default: 'INFORMATIONAL'
  field :price_type,       type: String, default: 'COMPANY'
  field :price_options,    type: Array, default: [] # only used for resellers
  field :price_info,       type: String # used for affiliates
  field :click_thru,       type: String # used for affiliates
  field :brand_color,      type: String, default: '326295'
  field :expert,           type: Expert
  field :key_features,     type: KeyFeatures
  field :categories,       type: Array, default: []

  embeds_one :image, cascade_callbacks: true

  validates_presence_of :name, :sale_type, :key
  validates_uniqueness_of :key
  validates :sale_type, inclusion: { in: %w[RESELLER AFFILIATE INFORMATIONAL],
                                     message: '%{value} is not a valid sale type' }
  validates :price_type, inclusion: { in: %w[COMPANY USER ONE_TIME],
                                      message: '%{value} is not a valid price type' }

  scope :just_added, ->(tz = 'UTC') { by_date(Time.now.in_time_zone(tz) - Rails.configuration.just_added_time) }
  scope :last_ten, -> { order(c_at: :desc).limit(10) }
  scope :admin_summary, -> { only(:key, :name, :active, :sale_type, :cue_score, :categories) }

  before_save {
    self.categories = self.update_categories
  }

  index(active: 1, key: 1)
  index(name: 1)
  index(sale_type: -1, name: 1)
  index({ key: 1 }, unique: true)
  index(key: 1, active: 1, name: 1, sale_type: -1)
  index(active: 1, c_at: 1, name: 1, sale_type: -1)

  def self.by_date(start_date, end_date = Time.now)
    where(c_at: (start_date..end_date))
  end

  def new?
    c_at >= Rails.configuration.just_added_time.ago
  end

  def partner?
    sale_type == 'AFFILIATE'
  end

  def reseller?
    sale_type == 'RESELLER'
  end

  def informational?
    sale_type == 'INFORMATIONAL'
  end

  def one_time_price?
    price_type == 'ONE_TIME'
  end

  def user_price?
    price_type == 'USER'
  end

  def company_price?
    price_type == 'COMPANY'
  end

  def active?
    active == true
  end

  def logo(version = :medium)
    image && image.attachment.url(version) || "#{Rails.configuration.action_mailer.asset_host}products/logos/#{logo_url}"
  end

  def small_logo()
    image && image.attachment.url(:small) || nil
  end

  def medium_logo()
    image && image.attachment.url(:medium) || nil
  end

  def original_logo()
    image && image.attachment.url(:original) || nil
  end

  def update_categories
    categories = Category.only(:key).where("products.key" => self.key)
    categories = categories.map { |elem| elem.key }
  end
end
