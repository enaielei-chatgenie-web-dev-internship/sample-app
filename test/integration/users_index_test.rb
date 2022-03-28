require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup()
    @user = users(:michael)
    @ouser = users(:tester1)
  end

  test("index including pagination") do
      sign_in_as(@user)
      get(users_path(), params: {
        page: 1, count: 10
      })
      assert_template("users/index")

      page1 = User.page(1).per(10)
      assert_select(".pagination") if page1.total_pages() > 1
      User.page(1).per(10).each() do |user|
        assert_select("a[href=?]", user_path(user))
      end
  end

  test("index as admin including pagination and delete links") do
    sign_in_as(@user)
    get(users_path())
    assert_template("users/index")
    page1 = User.page(1).per(10)
    if page1.total_pages() > 1
      assert_select(".pagination")
    end
    page1.each() do |user|
      assert_select("a[href=?]", user_path(user))
      if user != @user
        assert_select("a[href=?]", delete_user_path(user), text: "Delete")
      end
    end

    assert_difference("User.count", -1) do
      delete(delete_user_path(@ouser))
    end
  end

  test("index as non-admin") do
    sign_in_as(@ouser)
    get(users_path())
    assert_select("a", text: "Delete", count: 0)
  end
end
