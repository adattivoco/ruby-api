require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest

 setup do
    create_company
    @auth_token = get_token('admin@example.com', 'youarewelcome')
    @user_token = get_token()
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "should get users" do
    get users_url, headers: { "Authorization" => @auth_token }
    jdata = JSON.parse response.body
    assert_response :success, "User Success Response Check Failure"
    assert_equal response.content_type, 'application/json'
    assert_equal User.all.length, jdata.length
    assert_equal jdata[0]["name"], "Company User"
  end

  test "should get users with email filter" do
    get users_url, params: { filter: 'user@example.com' }, headers: { "Authorization" => @auth_token }
    jdata = JSON.parse response.body
    assert_response :success, "User Success Response Check Failure"
    assert_equal response.content_type, 'application/json'
    assert_equal 1, jdata.length
    assert_equal jdata[0]["name"], "Company User"
  end

  test "should get users with name filter" do
    get users_url, params: { filter: 'company' }, headers: { "Authorization" => @auth_token }
    jdata = JSON.parse response.body
    assert_response :success, "User Success Response Check Failure"
    assert_equal response.content_type, 'application/json'
    assert_equal 1, jdata.length
    assert_equal jdata[0]["name"], "Company User"
  end

  test "should not get users with name filter" do
    get users_url, params: { filter: 'test' }, headers: { "Authorization" => @auth_token }
    jdata = JSON.parse response.body
    assert_response :success, "User Success Response Check Failure"
    assert_equal response.content_type, 'application/json'
    assert_equal 0, jdata.length
  end

  test "get users auth failure" do
    get users_url
    assert_response :unauthorized
  end

  test "should find user" do
    get user_url(User.first), headers: { "Authorization" => @auth_token }
    jdata = JSON.parse response.body
    assert_response :success, "User Success Response Check Failure"
    assert_equal response.content_type, 'application/json'
    assert_equal jdata["name"], "Company User"
  end

  test "find user auth failure" do
    get user_url(User.first), headers: { "Authorization" => @user_token }
    assert_response :unauthorized
  end

  test "update user" do
    user = User.find_by(email: 'user@example.com')
    patch user_url(user),
            params: { :user => {name: 'New Name', email: "user2@example.com"} },
            headers: { "Authorization" => @user_token }
    assert_response :success
    assert_equal response.content_type, 'application/json'
    jdata = JSON.parse response.body
    newUser = jdata["user"]
    assert_equal newUser['name'], "New Name"
    assert_equal newUser['email'], "user2@example.com"
  end

  test "update not user" do
    user = User.find_by(email: 'user@example.com')
    patch user_url(user),
            params: { :user => {name: 'New Name', email: "user2@example.com"} },
            headers: { "Authorization" => @auth_token }
    assert_response :unauthorized
  end

  test "update password" do
    user = User.find_by(email: 'user@example.com')
    patch user_url(user),
            params: { :user => {current_password: 'thankyou', password: "newpassword", password_confirmation: "newpassword"} },
            headers: { "Authorization" => @user_token }
    assert_response :success
    assert_equal response.content_type, 'application/json'
    jdata = JSON.parse response.body
    newUser = jdata["user"]
    assert_equal newUser['name'], "Company User"

    newUser = User.authenticate("user@example.com", "newpassword")
    assert_not_nil newUser, 'User not authenticated'
  end

  test "update password invalid pw" do
    user = User.find_by(email: 'user@example.com')
    patch user_url(user),
            params: { :user => {current_password: 'thankyoze', password: "newpassword", password_confirmation: "newpassword"} },
            headers: { "Authorization" => @user_token }
    assert_response :bad_request
  end

  test "update password no match" do
    user = User.find_by(email: 'user@example.com')
    patch user_url(user),
            params: { :user => {current_password: 'thankyou', password: "newpassword", password_confirmation: "newpasswords"} },
            headers: { "Authorization" => @user_token }
    assert_response :bad_request
  end
end
