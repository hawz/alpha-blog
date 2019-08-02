require "test_helper"

class CreateArticlesTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: "boba", email: "boba@fett.com", password: "bobafett", admin: true)
  end

  test "get new article form and create article" do
    # the route is protected to unauthenticated users
    sign_in_as(@user, "bobafett")
    get new_article_path
    assert_template "articles/new"
    assert_difference "Article.count", 1 do
      post articles_path, params: { article: { title: "New Article", description: "New description" } }
    end
    follow_redirect!
    assert_template "articles/show"
    assert_match "New Article", response.body
  end

  test "invlid article submission results in failure" do
    sign_in_as(@user, "bobafett")
    get new_article_path
    assert_template "articles/new"
    assert_no_difference "Article.count" do
      post articles_path, params: { article: { title: "", description: "New description" } }
    end
    assert_template "articles/new"
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
