require 'test_helper'

class TokenControllerTest < ActionDispatch::IntegrationTest
  setup do
     create_company
   end

  teardown do
    DatabaseCleaner.clean
  end

  # company user tests

  test "login_user" do
    post "/authenticate", params: { email: "user@example.com", password: "thankyou" }
    assert_response :success
    assert_equal response.content_type, 'application/json'
    jdata = JSON.parse response.body
    assert_nil jdata["user"]["admin"]
  end

  test "invalid_pw_uppercase" do
    post "/authenticate", params: { email: "user@example.com", password: "THANKYOU" }
    assert_response :unauthorized
  end

  test "invalid_pw" do
    post "/authenticate", params: { email: "user@example.com", password: "thank" }
    assert_response :unauthorized
  end

  test "valid_upper_email" do
    post "/authenticate", params: { email: "USER@EXAMPLE.COM", password: "thankyou" }
    assert_response :success
    assert_equal response.content_type, 'application/json'
    jdata = JSON.parse response.body
    assert_nil jdata["user"]["admin"]
  end

  test "invalid_email" do
    post "/authenticate", params: { email: "er@example.com", password: "thankyou" }
    assert_response :unauthorized
  end


  # admin user tests

  test "login_admin_user" do
    post "/authenticate", params: { email: "admin@example.com", password: "youarewelcome" }
    assert_response :success
    assert_equal response.content_type, 'application/json'
    jdata = JSON.parse response.body
    assert_equal jdata["user"]["admin"], true
  end

  test "admin_invalid_pw_uppercase" do
    post "/authenticate", params: { email: "admin@example.com", password: "YOUAREWELCOME" }
    assert_response :unauthorized
  end

  test "admin_invalid_pw" do
    post "/authenticate", params: { email: "admin@example.com", password: "youare" }
    assert_response :unauthorized
  end

  test "admin_valid_upper_email" do
    post "/authenticate", params: { email: "ADMIN@EXAMPLE.COM", password: "youarewelcome" }
    assert_response :success
    assert_equal response.content_type, 'application/json'
    jdata = JSON.parse response.body
    assert_equal jdata["user"]["admin"], true
  end

  test "admin_invalid_email" do
    post "/authenticate", params: { email: "ad@example.com", password: "youarewelcome" }
    assert_response :unauthorized
  end

end
