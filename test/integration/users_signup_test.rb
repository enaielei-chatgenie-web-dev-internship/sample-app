require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup()
    ActionMailer::Base.deliveries.clear()
  end

  test("invalid signup information") do
      get(auth_sign_up_path())
      assert_no_difference('User.count') do
        post(auth_sign_up_path(), params: {
          user: {
            name: "",
            email: "user@invalid",
            password: "foo",
            password_confirmation: "bar"
          }
        })
      end
      assert_template('users/new')
  end

  test("valid signup information with account activation") do
    get(auth_sign_up_path())
    assert_difference('User.count', 1) do
      post(auth_sign_up_path(), params: {
        user: { name: "Example User",
          email: "user@example.com",
          password: "password",
          password_confirmation: "password"
        }
      })
    end
    assert_equal(1, ActionMailer::Base.deliveries.size())
    user = assigns(:user)
    assert_not(user.activated?())
    
    # Log in before activation
    sign_in_as(user)
    assert_not(is_signed_in())

    # Invalid activation token
    get(edit_account_activation_path("token", email: user.email))
    assert_not(is_signed_in())
    
    # Valid token, wrong email
    get(edit_account_activation_path(user.activation_token, email: "email"))
    assert_not(is_signed_in())

    # Valid activation token
    get(edit_account_activation_path(user.activation_token, email: user.email))
    assert(is_signed_in())

    follow_redirect!()
    assert_template('users/show')
    assert(is_signed_in())
  end
end
