require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup()
    @user = User.new(name: "Test User", email: "test.user@email.com",
      password: "123456", password_confirmation: "123456"
    )
  end

  test("user validity") do
    assert(@user.valid?())
  end

  test("name presence") do
    @user.name = ""
    assert_not(@user.valid?())
  end

  test("email presence") do
    @user.email = "   "
    assert_not(@user.valid?())
  end

  test("name should not be too long") do
    @user.name = "a" * 151
    assert_not(@user.valid?())
  end
  
  test("email should not be too long") do
    @user.email = "a" * 310 + "@example.com"
    assert_not(@user.valid?())
  end

  test("email validation should reject invalid addresses") do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not(@user.valid?(), "#{invalid_address.inspect} should be invalid")
    end
  end

  test("email addresses should be unique") do
    duplicate_user = @user.dup()
    @user.save()
    assert_not(duplicate_user.valid?())
  end

  test("email addresses should be saved as lower-case") do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save()
    assert_equal(mixed_case_email.downcase(), @user.reload.email)
  end

  test("password should be present (nonblank)") do
    @user.password = @user.password_confirmation = " " * 6
    assert_not(@user.valid?)
  end

  test("password should have a minimum length") do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not(@user.valid?)
  end

  test("authenticated should return false for a user with nil digest") do
    assert_not(@user.authenticated(:remember, ""))
  end

  test("associdated microposts should be destroyed") do
    @user.save()
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference("Micropost.count", -1) do
      @user.destroy()
    end
  end

  test("should follow and unfollow a user") do
    michael = users(:michael)
    archer = users(:archer)
    assert_not(michael.is_following(archer))
    michael.follow(archer)
    assert(michael.is_following(archer))
    assert(archer.followers.include?(michael))
    michael.unfollow(archer)
    assert_not(michael.is_following(archer))
  end

  test("feed should have the right posts") do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)

    # Posts from followed user
    for post in lana.microposts
      assert(michael.feed.include?(post))
    end

    # Posts from self
    for post in michael.microposts
      assert(michael.feed.include?(post))
    end

    # Posts from unfollowed user
    for post in archer.microposts
      assert_not(michael.feed.include?(post))
    end
  end
end
