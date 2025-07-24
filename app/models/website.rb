# app/models/website.rb
class Website < ApplicationRecord
  belongs_to :user
  belongs_to :template
  belongs_to :domain
  has_many :website_pages, dependent: :destroy

  validates :title, presence: true
  validates :status, inclusion: { in: ['draft', 'published', 'archived'] }

  scope :published, -> { where(status: 'published') }
  scope :drafts, -> { where(status: 'draft') }

  before_save :compile_website, if: :customizations_changed?

  def published?
    status == 'published'
  end

  def publish!
    update!(status: 'published', published_at: Time.current)
  end

  def unpublish!
    update!(status: 'draft', published_at: nil)
  end

  # Compile the final HTML with user customizations
  def compile_website
    self.compiled_html = compile_html_with_customizations
    self.compiled_css = compile_css_with_customizations
    self.compiled_js = template.js_content || ''
  end

  private

  def compile_html_with_customizations
    html = template.html_content.dup

    # Replace placeholders with user customizations
    customizations.each do |key, value|
      html.gsub!("{{#{key}}}", value.to_s)
    end

    html
  end

  def compile_css_with_customizations
    css = template.css_content&.dup || ''

    # Apply color customizations, fonts, etc.
    if customizations['primary_color']
      css.gsub!(':root { --primary-color: #3498db; }', ":root { --primary-color: #{customizations['primary_color']}; }")
    end

    if customizations['font_family']
      css.gsub!('font-family: "Arial", sans-serif', "font-family: \"#{customizations['font_family']}\", sans-serif")
    end

    css
  end
end