class CategoriesController < ApplicationController
  before_action :authorize_admin_request, only: [:create, :update]

  # get /categories
  def index
    if params[:filter] == 'categories'
      cats = Category.where(type: 'CATEGORY')
    elsif params[:filter] == 'verticals'
      cats = Category.where(type: 'VERTICAL')
    elsif params[:filter] == 'bundles'
      cats = Category.where(type: 'BUNDLE')
    elsif params[:filter] == 'preferred'
      cats = Category.where(type: 'CATEGORY', preferred: true)
    else
      cats = Category.all
    end

    if params[:active] == 'true'
      cats = cats.where(active: true)
    end

    if params[:sort] == 'name'
      render json: cats.order(name: :asc)
    elsif params[:sort] == 'type'
      render json: cats.order(type: :desc, name: :asc)
    else
      render json: cats.order(preferred: :desc, sort_order: :asc, name: :asc)
    end
  end

  # get /categories/:id
  def show
    category = Category.find_by(key: params[:id].downcase)
    category ||= Category.find(params[:id])
    if category
      render json: category
    else
      render json: { error: 'Category not found. Please try again.' }, status: :not_found
    end
  end

  # post /categories
  def create
    new_category = category_params
    if new_category
      params[:products] ||= []
      new_category[:products] = params[:products].map do |prod|
        full_product = Product.only(:key, :name, :sale_type, :brand_color, :logo_url, :image).find_by(key: prod)
        prod = {
          key: prod,
          logo_url: full_product.logo,
          brand_color: full_product.brand_color,
          name: full_product.name,
          sale_type: full_product.sale_type
        }
      end
    end
    Category.create! new_category
    render json: Category.all.order(sort_order: :asc, name: :asc)
  end

  # put /categories/:id
  def update
    category = Category.find(params[:id])
    updated_category = category_params
    if category
      params[:products] ||= []
      updated_category[:products] = params[:products].map { |prod|
        full_product = Product.only(:key, :name, :sale_type, :brand_color, :logo_url, :image).find_by(key: prod)
        prod = {
          key: prod,
          logo_url: full_product.logo,
          brand_color: full_product.brand_color,
          name: full_product.name,
          sale_type: full_product.sale_type
        }
      }
      category.update! updated_category
    end
    render json: Category.all.order(sort_order: :asc, name: :asc)
  end

  # get /categories/:id/products
  def products
    category = Category.find_by(key: params[:id].downcase)
    category ||= Category.find(params[:id])
    if category
      cats = []
      prods = Product.where(active: true)
      if category.key == 'just-added'
        prods = prods.just_added
        if prods.length < 10
          prods = Product.where(active: true).last_ten
        end
      elsif category.key == 'cue-managed'
        prods = prods.where(sale_type: 'RESELLER')
        cats = Category.only(:key, :active, :name, :summary, :icon, :type, :preferred).where({active: true, "products.sale_type" => 'RESELLER', type: 'CATEGORY'}).order(preferred: :desc, sort_order: :asc, name: :asc)
      else
        prods = prods.in(key: params[:keys].nil? ? category.products.map {|prod| prod[:key]} : params[:keys])
      end
      render(json: { category: category, products: prods, categories: cats }, methods: :logo)
    else
      render json: { error: 'Category not found. Please try again.' }, status: :not_found
    end
  end
end

private

def category_params
  params.permit(:active,
                :id,
                :key,
                :name,
                :icon,
                :summary,
                :preferred,
                :sort_order,
                :type,
                {products: [:key, :logo_url, :sale_type, :brand_color, :name]})
end
