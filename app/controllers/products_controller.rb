class ProductsController < ApplicationController
  before_action :authorize_admin_request, only: [:create, :update]

  # get /products
  def index
    if params[:keys]
      if params[:load_all] == "true"
        render json: Product.in(key: params[:keys]).order_by(name: 'asc'), methods: :logo
      else
        render json: Product.where(active: true).in(key: params[:keys]).order_by(sale_type: 'desc', name: 'asc'), methods: :logo
      end
    elsif params[:type] == 'summary'
      render json: get_summary_list
    else
      render json: get_products_list, methods: :logo
    end
  end

  # get /products/:id
  def show
    product = Product.find_by(key: params[:id])
    product = Product.find(params[:id]) if product.blank?
    if product
      render json: product, methods: [:logo, :original_logo]
    else
      render json: { error: 'Product not found. Please try again.' }, status: :not_found
    end
  end

  # post /products
  def create
    product = Product.find_by(key: params[:key])
    if !product
      Product.create! product_params
    end
    render json: Product.order(name: :asc), methods: :logo
  end

  # put /products/:id
  def update
    product = Product.find(params[:id])
    product = Product.find_by(key: params[:id]) if product.blank?
    if product
      product.update! product_params
    end

    render json: Product.order(name: :asc), methods: :logo
  end

  # get /products/:id/categories/products
  def categories_products
    categories = Category.only(:key, :products).where("products.key" => params[:id])

    if !categories.empty?
      product_keys = []
      categories.each do |category|
        category.products.each {|prod| product_keys.push prod["key"]}
      end
      product_keys.uniq!
      product_keys.delete(params[:id])
      if !product_keys.empty?
        render json: Product.in(key: product_keys).where(active: true).not_in(sale_type: 'INFORMATIONAL').order(sale_type: :desc, name: :asc).limit(3)
      else
        render json: []
      end
    else
      render json: []
    end
  end

  private

  def get_summary_list
    products = Product.admin_summary
    if params[:sort] == 'type'
      products = products.order(sale_type: (params[:sort_order]=='asc' && :asc || :desc), name: :asc)
    else
      products = products.order(name: (params[:sort_order]=='asc' && :asc || :desc))
    end
    products
  end

  def get_products_list
    Product.where(active: true).order(sale_type: :desc, name: :asc)
  end

  def product_params
    params.permit(:name,
                  :key,
                  :sale_type,
                  :price_type,
                  :summary,
                  :active,
                  :price_info,
                  :click_thru,
                  :logo_url,
                  :brand_color,
                  { image: [:attachment] },
                  { expert: [:name, :quote, :image_url] },
                  { key_features: [:free_trial, :free_plan, :demos, :multiple_price_plans, platforms: [], support: [], business_size: [], locations: [], business_types: []] },
                  { price_options: [:name, :key, :description, :price, :recommended, features: [:feature_key, :feature_text]] })
  end

end
