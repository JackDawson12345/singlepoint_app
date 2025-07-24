class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  # Add these lines - one-to-one relationships
  has_one :order, dependent: :destroy
  has_one :domain, dependent: :destroy  # if you have domains
  has_many :websites, dependent: :destroy

  def has_order?
    order.present?
  end

  def order_completed?
    order&.status == 'completed'
  end
end
