# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Test User', email: 'test@example.io', 
                     password: '123qwe', password_confirmation: '123qwe')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ''
    refute @user.valid?
  end

  test 'email should be present' do
    @user.email = ''
    refute @user.valid?
  end
  
  test 'name should not overrun 50 characters' do
    @user.name = 'a' * 51
    refute @user.valid?
  end

  test 'email should not overrun 255 characters' do
    @user.email = 'a' * 256
    refute @user.valid?
  end

  test 'email should accept correct email addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email should reject incorrect email addresses' do 
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com foo@baraz..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      refute @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    refute duplicate_user.valid?
  end

  test 'email should be saved as downcase' do
    @user.email = 'TEST@exAMPle.com'
    @user.save
    assert_equal 'test@example.com', @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
