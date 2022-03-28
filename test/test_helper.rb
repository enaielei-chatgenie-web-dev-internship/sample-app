ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors, with: :threads)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def is_signed_in()
    return !!session[:user_id]
  end

  def sign_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  def sign_in_as(user, password: "password", remembered: "1")
    post(auth_sign_in_path(), params: {
      session: {
        email: user.email,
        password: password,
        remembered: remembered
      }
    })
  end
end
