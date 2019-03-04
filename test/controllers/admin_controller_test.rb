require 'test_helper'

class AdminControllerTest  < ActionDispatch::IntegrationTest
  test "should get index" do
    get health_url
    assert_response :success, "Health Success Response Check Failure"
    assert response.body == "ok", "Health Body Check Failure"
  end
end
