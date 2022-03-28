require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup()
    @user = users(:michael)
  end

  test("profile display") do
    sign_in_as(@user)
    get(user_path(@user))
    assert_template("users/show")
    assert_select("title", get_title(@user.name))
    assert_match(@user.name, response.body)
    assert_select(".profile-image")
    assert_match(@user.microposts.count.to_s(), response.body())

    page = @user.microposts.page(1).per(5)

    assert_select(".pagination") if page.total_pages() > 1
    
    for post in page
      assert_match(post.content.truncate(40, omission: "..."), response.body)
    end
  end
end
