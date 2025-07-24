# app/models/website_page.rb
class WebsitePage < ApplicationRecord
  belongs_to :website

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: { scope: :website_id }

  before_validation :generate_slug, if: :name_changed?

  scope :ordered, -> { order(:sort_order) }
  scope :homepage, -> { where(is_homepage: true) }

  private

  def generate_slug
    self.slug = name.parameterize if name.present?
  end
end
