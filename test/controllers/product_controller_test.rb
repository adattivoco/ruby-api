require 'test_helper'
require 'database_cleaner'

class ProductControllerTest < ActionDispatch::IntegrationTest
  # Add more helper methods to be used by all tests here...
  setup do
    create_products_only
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "should get products" do
    get products_url
    assert_response :success, "Products Success Response Check Failure"
    assert_equal response.content_type, 'application/json'
    jdata = JSON.parse response.body
    assert_equal 6, jdata.length
  end

  test "should get all products with filter" do
    get products_url, params: { filter: '' }
    assert_response :success, "Products Success Response Check Failure"
    assert_equal response.content_type, 'application/json'
    jdata = JSON.parse response.body
    assert_equal 6, jdata.length
  end

  test "should get product" do
    get product_url(id: 'ms-office')
    jdata = JSON.parse response.body
    assert_response :success, "Product Success Response Check Failure"
  end

  test "should not get product" do
    get product_url(id: 'notfound')
    assert_response :not_found, "Product Not Found Failure"
  end

  test "should get products by key" do
    get products_url, params: { keys: ['ms-office', 'webroot'] }
    jdata = JSON.parse response.body
    assert_equal 2, jdata.length
  end

  test "should get products summary" do
    get products_url, params: { type: 'summary' }
    jdata = JSON.parse response.body
    assert_equal 6, jdata.length
    assert_not_nil jdata[0]['name']
    assert_nil jdata[0]['short_description']
  end
end
