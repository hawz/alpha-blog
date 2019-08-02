require "test_helper"

class SignupUsersTest < ActionDispatch::IntegrationTest
  test "get signup form and create user" do
    get signup_path
    assert_template "users/new"
    assert_difference "User.count", 1 do
      post users_path, params: { user: { username: "boba", email: "boba@fett.com", password: "bobafett" } }
    end
    follow_redirect!
    assert_template "users/show"
    assert_match "boba", response.body
  end

  test "invalid signup parameters result in failure" do
    get signup_path
    assert_template "users/new"
    assert_no_difference "User.count" do
      post users_path, params: { user: { username: "boba", password: "boba", email: "boba.net" } }
    end
    assert_template "users/new"
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
