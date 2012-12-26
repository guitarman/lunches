require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  attr_accessor :password

  has_and_belongs_to_many :foods, :join_table => "users_foods", :uniq => true
  has_and_belongs_to_many :soups, :join_table => "users_soups", :uniq => true

  validates :email, :uniqueness => true,
            :length => { :within => 5..50 },
            :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
  validates :password, :confirmation => true,
            :length => { :within => 4..20 },
            :presence => true,
            :if => :password_required?

  before_save :encrypt_new_password

  def self.authenticate(email, password)
    user = find_by_email(email)
    return user if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
  end

  def authenticated?(password)
    self.password_hash == encrypt(password)
  end

  def likes_food?(food)
    false unless food.is_a? Food
    food == foods.find_by_id(food.id)
  end

  def likes_soup?(soup)
    false unless soup.is_a? Soup
    soup == soups.find_by_id(soup.id)
  end

  protected
  def encrypt_new_password
    return if password.blank?
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end

  def password_required?
    password_hash.blank? || password.present?
  end
end