require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup()
    @app_name = "Sample App"
  end

  test "should get home" do
    get(root_path)
    assert_response(:success)
    # assert_select("title", "#{@app_name}")
  end

  test "should get about" do
    get(about_path)
    assert_response(:success)
    assert_select("title", "#{@app_name} | About")
  end
end
