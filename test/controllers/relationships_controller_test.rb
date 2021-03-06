require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test("create should require logged-in user") do
    assert_no_difference("Relationship.count") do
      post(relationships_path())
    end
    assert_redirected_to(auth_sign_in_url())
  end

  test("destroy should require logged-in user") do
    assert_no_difference("Relationship.count") do
      delete(relationship_path(relationships(:one)))
    end
    assert_redirected_to(auth_sign_in_url())
  end
end
