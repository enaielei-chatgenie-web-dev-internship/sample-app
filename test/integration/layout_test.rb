require "test_helper"

class LayoutTest < ActionDispatch::IntegrationTest
  test("layout links") do
    get(root_path())
    assert_template("sessions/new")
    assert_select("a[href=?]", root_path(), count: 1)
    assert_select("a[href=?]", about_path())
  end
end
