require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup()
    @app_name = "Sample App"
  end

  test "should get home" do
    get(static_pages_home_url)
    assert_response(:success)
    assert_select("title", "#{@app_name} | Home")
  end

  test "should get help" do
    get(static_pages_help_url)
    assert_response(:success)
    assert_select("title", "#{@app_name} | Help")
  end

  test "should get about" do
    get(static_pages_about_url)
    assert_response(:success)
    assert_select("title", "#{@app_name} | About")
  end
end
