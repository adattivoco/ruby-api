ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'ostruct'
require 'simplecov'
SimpleCov.start  do
  add_filter '/test/'
  add_filter '/config/'
  add_group 'Controllers', 'app/controllers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Mailers', 'app/mailers'
  add_group 'Models', 'app/models'
  add_group 'Libraries', 'app/lib'
  add_group 'Views', 'app/views'
end

class ActiveSupport::TestCase
  Product.create_indexes
  User.create_indexes
  Category.create_indexes

  def create_admin_user
    Admin.create name: 'Admin User', email: 'ADMIN@EXAMPLE.COM', password: 'youarewelcome', password_confirmation: 'youarewelcome'
  end

  def create_company
    Product.create(key: 'web-domain', active: true, name: 'GoDaddy Domains', sale_type: 'RESELLER', price_type: 'COMPANY', price_info: '', summary: 'Buy a domain name and make your own website without any technical expertise.')
    Product.create(key: 'ms_office', active: true, name: 'Office 365 Premium', sale_type: 'RESELLER', price_type: 'USER', price_info: '', summary: 'Get the complete Microsoft Office suite of apps (Outlook, Word, Excel, PowerPoint, etc.), cloud storage, and services.')
    Product.create(key: 'duda_website', active: true, name: 'Duda', sale_type: 'RESELLER', price_type: 'COMPANY', price_info: '', summary: 'Register a domain name and make your own website without any technical expertise.')
    Product.create(key: 'webroot', active: true, name: 'Webroot Secure Anywhere', sale_type: 'RESELLER', price_type: 'COMPANY', price_info: '', summary: 'Avoid infections and data theft.')
    Product.create(key: 'cue-concierge', active: true, name: 'CUE Concierge', sale_type: 'RESELLER', price_type: 'ONE_TIME',price_info: '', summary: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi mattis id turpis et laoreet.')
    CompanyUser.create(name: 'Company User', companies: ['123abc'], email: 'uSeR@example.com', password: 'thankyou', password_confirmation: 'thankyou')
    CompanyUser.create(name: 'User2', companies: ['456zxc'], email: 'uSeR2@example.com', password: 'thankyou', password_confirmation: 'thankyou')
    create_admin_user
  end

  def create_products_only
    Product.create(key: 'web-domain', active: true, name: 'GoDaddy Domains', sale_type: 'RESELLER', price_type: 'COMPANY', price_info: '', summary: 'Buy a domain name and make your own website without any technical expertise.')
    Product.create(key: 'ms-office', active: true, name: 'Office 365 Premium', sale_type: 'RESELLER', price_type: 'USER', price_info: '', summary: 'Get the complete Microsoft Office suite of apps (Outlook, Word, Excel, PowerPoint, etc.), cloud storage, and services.')
    Product.create(key: 'duda-website', active: true, name: 'Duda', sale_type: 'RESELLER', price_type: 'COMPANY', price_info: '', summary: 'Register a domain name and make your own website without any technical expertise.')
    Product.create(key: 'webroot', active: true, name: 'Webroot Secure Anywhere', sale_type: 'RESELLER', price_type: 'COMPANY', price_info: '', summary: 'Avoid infections and data theft. ')
    Product.create(key: 'carbonite_core', active: true, name: 'Carbonite Business Core Backup', sale_type: 'RESELLER', price_type: 'COMPANY', price_info: '', summary: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.')
    Product.create(key: 'cue-concierge', active: true, name: 'CUE Concierge', sale_type: 'RESELLER', price_type: 'COMPANY', price_info: '', summary: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi mattis id turpis et laoreet.')
  end

  def get_token(email='user@example.com', password='thankyou')
    user = User.authenticate(email, password)
    return user && user.auth_token || nil
  end

  def create_categories
    create_products_only
    Category.create name: 'IT', key: 'it', summary: 'IT'
    Category.create name: 'CAT2', key: 'cat2', summary: 'Category 2'
    Category.create name: 'CAT3', key: 'cat3', summary: 'Category 3'
    CompanyUser.create(name: 'Company User', companies: ['abc123'], email: 'uSeR@example.com', password: 'thankyou', password_confirmation: 'thankyou')
    create_admin_user
  end

  # def create_dummy_result(amount = 99.99)
  #   credit_card_details = OpenStruct.new(card_type: 'VISA', last_4: '1111')
  #   transaction = OpenStruct.new(credit_card_details: credit_card_details,
  #                                amount: amount,
  #                                id: 'abc123',
  #                                status: 'SUCCESSFUL',
  #                                processor_authorization_code: 'xyz890')
  #   OpenStruct.new(success?: true, transaction: transaction)
  # end

end
