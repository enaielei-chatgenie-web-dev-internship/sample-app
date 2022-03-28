require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup()
    @user = users(:michael)
  end

  test("micropost interface") do
    sign_in_as(@user)
    get(user_path(@user))
    assert_select('.pagination')

    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select '.form-error-message'
    # assert_select 'a[href=?]', '/?active=posts&page=2' # Correct pagination link

    # Valid submission
    content = "This micropost"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to(new_micropost_url())
    follow_redirect!()
    assert_match(content, response.body)

    # Delete post
    assert_select 'a', text: 'Delete'
      first_micropost = @user.microposts.page(1).first
      assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # Visit different user (no delete links)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end
