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

class User < ApplicationRecord
  before_save {self.email = email.downcase}
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, 
                    length: {maximum: 255}, 
                    format: {with: EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, length: { minimum: 6 }, 
                       presence: true

  has_secure_password
end
