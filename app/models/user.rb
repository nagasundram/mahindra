class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :transactions, inverse_of: :user

  def is_admin?
    self.email == Rails.application.secrets.admin_email && self.id == 1
  end

end
