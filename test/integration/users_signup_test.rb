require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid submission" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'form[action="/signup"]'
  end

  test "error messages" do
    get signup_path
    assert_template 'users/new'
    post signup_path, params: { user: { name:  "",
                                       email: "user@invalid",
                                       password:              "foo",
                                       password_confirmation: "bar" } }
    assert_select 'div.alert.alert-danger', 'The form contains 4 errors.'
    assert_select 'li', "Name can't be blank"
    assert_select 'li', 'Email is invalid'
    assert_select 'li', 'Password is too short (minimum is 6 characters)'
    assert_select 'li', "Password confirmation doesn't match Password"
    assert_template 'shared/_error_message'
    assert_template 'users/new'

    post signup_path, params: { user: { name:  "",
    email: "user@invalid",
    password:              "foobar",
    password_confirmation: "foobar" } }
    assert_select 'div.alert.alert-danger', 'The form contains 2 errors.'
    assert_select 'li', "Name can't be blank"
    assert_select 'li', 'Email is invalid'
    assert_template 'shared/_error_message'
    assert_template 'users/new'

    post signup_path, params: { user: { name:  "",
    email: "user@invalid.com",
    password:              "foobar",
    password_confirmation: "foobar" } }
    assert_select 'div.alert.alert-danger', 'The form contains 1 error.'
    assert_select 'li', "Name can't be blank"
    assert_template 'shared/_error_message'
    assert_template 'users/new'
  end

  test "valid submission" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count' do
      post signup_path, params: { user: { name:  "Myrka",
                                         email: "user1@valid.com",
                                         password:              "foobar1",
                                         password_confirmation: "foobar1" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select 'img.gravatar'
    assert_select 'section.user_info'
    assert_select 'div.alert', "Welcome to the Sample App!"
  end
end
