require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get(auth_sign_in_path)
    assert_response(:success)
  end
end
