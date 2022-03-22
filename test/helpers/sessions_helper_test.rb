require "test_helper"

class SessionsHelperTest < ActionView::TestCase
    def setup()
        @user = users[0]
        remember(@user)
    end

    test("user returns right user when session is nil") do
        assert_equal(@user, get_user())
        assert(is_signed_in())
    end

    test("user returns nil when remember digest is wrong") do
        @user.update_attribute(:remember_digest, User.digest(User.new_token()))
        assert_nil(get_user())
    end
end