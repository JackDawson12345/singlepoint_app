class Domain < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :name, format: {
    with: /\A[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*\z/,
    message: "must be a valid domain name"
  }

  before_save :normalize_domain_name

  private

  def normalize_domain_name
    self.name = name.downcase.strip
  end
end
