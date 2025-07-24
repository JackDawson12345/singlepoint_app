# app/controllers/admin/templates_controller.rb
class Admin::TemplatesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :admin_only
  before_action :set_template, only: [:show, :edit, :update, :destroy, :toggle_active]

  def index
    @templates = Template.all.order(:name)
    @categories = Template::CATEGORIES

    if params[:category].present?
      @templates = @templates.where(category: params[:category])
    end

    if params[:search].present?
      @templates = @templates.where("name ILIKE ? OR description ILIKE ?",
                                    "%#{params[:search]}%", "%#{params[:search]}%")
    end
  end

  def show
  end

  def new
    @template = Template.new
  end

  def create
    @template = Template.new(template_params)

    if @template.save
      redirect_to admin_template_path(@template), notice: 'Template created successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @template.update(template_params)
      redirect_to admin_template_path(@template), notice: 'Template updated successfully!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @template.websites.exists?
      redirect_to admin_templates_path,
                  alert: 'Cannot delete template that is being used by websites.'
    else
      @template.destroy
      redirect_to admin_templates_path, notice: 'Template deleted successfully!'
    end
  end

  def toggle_active
    @template.update(active: !@template.active)
    redirect_to admin_templates_path,
                notice: "Template #{@template.active? ? 'activated' : 'deactivated'} successfully!"
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:name, :category, :description, :html_content,
                                     :css_content, :js_content, :preview_image_url,
                                     :active, :price_cents, customizable_fields: [])
  end

  def admin_only
    unless current_user&.admin?
      redirect_to root_url(subdomain: nil), alert: 'Access denied.', allow_other_host: true
    end
  end
end