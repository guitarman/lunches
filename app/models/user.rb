require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  attr_accessor :password

  validates :email, :uniqueness => true,
            :length => { :within => 5..50 },
            :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
  validates :password, :confirmation => true,
            :length => { :within => 4..20 },
            :presence => true,
            :if => :password_required?

  has_one :profile
  has_many :articles, :order => 'published_at DESC, title ASC',
           :dependent => :nullify
  has_many :replies, :through => :articles, :source => :comments

  before_save :encrypt_new_password

  def self.authenticate(email, password)
    user = find_by_email(email)
    return user if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
  end

  def authenticated?(password)
    self.password_hash == encrypt(password)
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