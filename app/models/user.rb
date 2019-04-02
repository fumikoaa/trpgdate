class User < ApplicationRecord

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  has_secure_password validations: true

  has_many :pldates 
  def self.new_remember_token
  SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

end
