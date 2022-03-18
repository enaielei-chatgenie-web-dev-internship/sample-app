require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get auth_sign_up_path
    assert_response :success
  end
end
