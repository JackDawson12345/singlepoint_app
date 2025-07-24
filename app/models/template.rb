# app/models/template.rb
class Template < ApplicationRecord
  has_many :websites, dependent: :restrict_with_error

  validates :name, presence: true
  validates :html_content, presence: true
  validates :category, presence: true

  scope :active, -> { where(active: true) }
  scope :by_category, ->(category) { where(category: category) }

  CATEGORIES = ['business', 'portfolio', 'blog', 'e-commerce', 'restaurant', 'photography'].freeze

  validates :category, inclusion: { in: CATEGORIES }

  def price_in_pounds
    price_cents / 100.0
  end

  # Parse customizable fields from JSON
  def parsed_customizable_fields
    return [] if customizable_fields.blank?
    customizable_fields.is_a?(Array) ? customizable_fields : []
  end

  # Get all placeholder variables from HTML content
  def extract_placeholders
    html_content.scan(/\{\{([^}]+)\}\}/).flatten.uniq
  end
end
