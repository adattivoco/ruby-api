require 'test_helper'
require 'database_cleaner'

class CategoryControllerTest < ActionDispatch::IntegrationTest

  setup do
    create_categories
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "should get categories" do
    get categories_url
    assert_response :success, "Coupons Success Response Check Failure"
    assert_equal response.content_type, 'application/json'
    jdata = JSON.parse response.body
    assert_equal 3, jdata.length
  end

  test "should get category with code" do
    get category_url(id: 'it')
    jdata = JSON.parse response.body
    assert_equal jdata["key"].downcase, "it"
  end

  test "should get category with id" do
    cat = Category.first
    get category_url(id: cat["_id"])
    jdata = JSON.parse response.body
    assert_equal jdata["name"], cat.name
  end

  test "should not get category" do
    get category_url(id: "notfound")
    assert_response :not_found, "Category Not Found Failure"
  end

  test "should add category" do
    auth_token = get_token('admin@example.com', 'youarewelcome')
    post categories_url,
        params: { name: 'New Category', key: "new", summary: "test" },
        headers: { "Authorization" => auth_token }
    assert_response :success, "Category Success Response Check"
    assert_equal response.content_type, 'application/json'
    jdata = JSON.parse response.body
    assert_equal 4, jdata.length
  end

  test "should add category authorization failure" do
    post categories_url, params: { name: 'New Category', key: "new", summary: "test" }
    assert_response :unauthorized
  end

  test "should update category" do
    auth_token = get_token('admin@example.com', 'youarewelcome')
    cat = Category.first
    patch category_url(id: cat[:_id]),
          params: { name: 'New Category' },
          headers: { "Authorization" => auth_token }
    assert_response :success, "Category Success Response Check"
    assert_equal response.content_type, 'application/json'

    get category_url(id: cat[:_id])
    jdata = JSON.parse response.body
    assert_equal jdata["name"], "New Category"
  end

  test "should update category authorization failure" do
    auth_token = get_token()
    patch category_url(Category.first),
          params: { name: 'New Category' },
          headers: { "Authorization" => auth_token }
    assert_response :unauthorized
  end
end
