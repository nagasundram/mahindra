class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :store_code, presence: {message: " required"}
  # validates :store_code, length: {in: 4..5, :message => " should be between 4 to 5 characters"}
  # validates :name, presence: {message: " required"}
  # validates :name, length: {in: 1..30, :message => " should be between 1 to 30 characters"}


  has_many :transactions, inverse_of: :user

  def is_admin?
    self.email == Rails.application.secrets.admin_email && self.id == 1
  end

end
