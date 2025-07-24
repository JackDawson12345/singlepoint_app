# app/controllers/manage/website_builder_controller.rb
class Manage::WebsiteBuilderController < ApplicationController
  layout 'manage'
  before_action :authenticate_user!
  before_action :ensure_order_completed
  before_action :set_website, except: [:index, :new, :create, :choose_template]

  def index
    @websites = current_user.websites.includes(:template, :domain)
  end

  def new
    redirect_to choose_template_manage_website_builder_index_path
  end

  def choose_template
    @templates = Template.active.includes(:websites)
    @categories = Template::CATEGORIES
    @selected_category = params[:category]

    @templates = @templates.by_category(@selected_category) if @selected_category.present?
  end

  def create
    @template = Template.find(params[:template_id])

    @website = current_user.websites.build(
      template: @template,
      domain: current_user.domain,
      title: params[:title] || "My Website",
      customizations: default_customizations
    )

    if @website.save
      # Create default homepage
      @website.website_pages.create!(
        name: 'Home',
        slug: 'home',
        is_homepage: true,
        html_content: @template.html_content,
        css_content: @template.css_content,
        js_content: @template.js_content
      )

      redirect_to edit_manage_website_builder_path(@website),
                  notice: 'Website created successfully! Start customizing your template.'
    else
      redirect_to choose_template_manage_website_builder_index_path,
                  alert: 'Error creating website. Please try again.'
    end
  end

  def show
    @compiled_html = @website.compiled_html
  end

  def edit
    @customizable_fields = @website.template.parsed_customizable_fields
    @website_pages = @website.website_pages.ordered
  end

  def update
    if @website.update(website_params)
      @website.compile_website
      @website.save

      respond_to do |format|
        format.html { redirect_to edit_manage_website_builder_path(@website), notice: 'Website updated successfully!' }
        format.json { render json: { status: 'success', message: 'Updated successfully' } }
      end
    else
      respond_to do |format|
        format.html { render :edit, alert: 'Error updating website.' }
        format.json { render json: { status: 'error', errors: @website.errors.full_messages } }
      end
    end
  end

  def preview
    @website.compile_website
    render layout: false
  end

  def publish
    if @website.publish!
      redirect_to manage_website_builder_path(@website),
                  notice: 'Website published successfully!'
    else
      redirect_back(fallback_location: edit_manage_website_builder_path(@website),
                    alert: 'Error publishing website.')
    end
  end

  def unpublish
    if @website.unpublish!
      redirect_to manage_website_builder_path(@website),
                  notice: 'Website unpublished successfully!'
    else
      redirect_back(fallback_location: edit_manage_website_builder_path(@website),
                    alert: 'Error unpublishing website.')
    end
  end

  def destroy
    @website.destroy
    redirect_to manage_website_builder_index_path,
                notice: 'Website deleted successfully!'
  end

  # AJAX endpoint for live preview updates
  def update_preview
    customizations = params[:customizations] || {}

    # Temporarily compile with new customizations
    temp_website = @website.dup
    temp_website.customizations = @website.customizations.merge(customizations)
    temp_website.compile_website

    render json: {
      html: temp_website.compiled_html,
      css: temp_website.compiled_css
    }
  end

  private

  def set_website
    @website = current_user.websites.find(params[:id])
  end

  def website_params
    params.require(:website).permit(:title, :description, :status, customizations: {})
  end

  def ensure_order_completed
    unless current_user.order_completed?
      redirect_to account_setup_path, alert: 'Please complete your order first.'
    end
  end

  def default_customizations
    {
      'company_name' => current_user.domain&.name&.split('.')&.first&.humanize || 'My Company',
      'contact_email' => current_user.email,
      'primary_color' => '#3498db',
      'secondary_color' => '#2c3e50',
      'font_family' => 'Arial'
    }
  end
end