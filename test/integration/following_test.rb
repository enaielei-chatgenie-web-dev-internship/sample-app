require "test_helper"

class FollowingTest < ActionDispatch::IntegrationTest
  def setup()
    @user = users(:michael)
    @ouser = users(:archer)
    sign_in_as(@user)
  end

  test("following page") do
    page, count = 1, 10
    get(following_user_path(@user), params: {
      page: page, count: count
    })
    assert_not(@user.following.empty?())
    assert_match(@user.following.count.to_s(), response.body)
    for user in @user.following.page(page).per(count)
      assert_select("a[href=?]", user_path(user))
    end
  end

  test("followers page") do
    page, count = 1, 10
    get(followers_user_path(@user), params: {
      page: page, count: count
    })
    assert_not(@user.followers.empty?())
    assert_match(@user.followers.count.to_s(), response.body)
    for user in @user.followers.page(page).per(count)
      assert_select("a[href=?]", user_path(user))
    end
  end

  test("should follow a user the standard way") do
    assert_difference("@user.following.count", 1) do
      post(relationships_path(), params: {
        followed_id: @ouser.id
      })
    end
  end

  test("should follow a user with Ajax") do
    assert_difference("@user.following.count", 1) do
      post(relationships_path(), xhr: true, params: {
        followed_id: @ouser.id
      })
    end
  end

  test("should unfollow a user the standard way") do
    @user.follow(@ouser)
    relationship = @user.active_relationships.find_by(followed_id: @ouser.id)
    assert_difference("@user.following.count", -1) do
      delete(relationship_path(relationship))
    end
  end

  test("should unfollow a user with Ajax") do
    @user.follow(@ouser)
    relationship = @user.active_relationships.find_by(followed_id: @ouser.id)
    assert_difference("@user.following.count", -1) do
      delete(relationship_path(relationship), xhr: true)
    end
  end
end
