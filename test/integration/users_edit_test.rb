require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup()
    @user = users(:tester)
  end

  test("unsuccessful edit") do
    sign_in_as(@user)
    get(edit_user_path(@user))
    assert_template("users/edit")
    patch(
      edit_user_path(@user), params: {
        user: {
          name: "",
          email: "foo@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    )
    assert_template("users/edit")
  end

  test("successful edit") do
    sign_in_as(@user)
    get(edit_user_path(@user))
    assert_template("users/edit")
    name = "Foo Bar"
    email = "foo@bar.com"
    patch(
      edit_user_path(@user), params: {
        user: {
          name: name,
          email: email,
          password: "123456",
          password_confirmation: "123456"
        }
      }
    )

    assert_not(flash.empty?())
    follow_redirect!()
    assert_template("users/edit")
    @user.reload()
    assert_equal(name, @user.name)
    assert_equal(email, @user.email)
  end

  test("successful edit with friendly forwarding") do
    get(edit_user_path(@user))
    sign_in_as(@user)
    assert_redirected_to(edit_user_url(@user))
    name = "Foo Bar"
    email = "foo@bar.com"
    patch(
      edit_user_path(@user), params: {
        user: {
          name: name,
          email: email,
          password: "123456",
          password_confirmation: "123456"
        }
      }
    )

    assert_not(flash.empty?())
    follow_redirect!()
    assert_template("users/edit")
    @user.reload()
    assert_equal(name, @user.name)
    assert_equal(email, @user.email)
  end
end
