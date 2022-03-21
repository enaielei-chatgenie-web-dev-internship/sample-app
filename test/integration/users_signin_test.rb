require "test_helper"

class UsersSigninTest < ActionDispatch::IntegrationTest
  def setup()
    @user = users[0]
  end

  test "login with invalid information" do
    get auth_sign_in_path
    post auth_sign_in_path, params: { user: { email: @user.email,
      password: 'password' } }

    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", auth_sign_in_path, count: 0
    # assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "valid signup information" do
    get auth_sign_up_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_signed_in()
  end

  test "login with valid email/invalid password" do
    get auth_sign_in_path()
    assert_template 'sessions/new'
    post auth_sign_in_path(), params: { user: { email: @user.email,
    password: "invalid" } }
    assert_not is_signed_in()
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get auth_sign_in_path()
    post auth_sign_in_path(), params: { user: { email: @user.email,
    password: 'password' } }
    assert is_signed_in()
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", auth_sign_in_path(), count: 0
    assert_select "a[href=?]", auth_sign_out_path()
    assert_select "a[href=?]", user_path(@user)
    delete auth_sign_out_path()
    assert_not is_signed_in()
    assert_redirected_to root_url()
    follow_redirect!
    assert_select "a[href=?]", auth_sign_in_path()
    assert_select "a[href=?]", auth_sign_out_path(), count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
