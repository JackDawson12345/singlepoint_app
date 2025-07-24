class Manage::PanelController < ApplicationController
  layout 'manage'
  before_action :authenticate_user!
  before_action :not_admin
  before_action :account_setup
  def index
  end


  private

  def not_admin
    if current_user&.admin?
      redirect_to root_url(subdomain: 'admin'), alert: 'Access denied.', allow_other_host: true
    end
  end

  def account_setup
    puts "Current subdomain: #{request.subdomain}"
    unless current_user&.order_completed?
      redirect_to account_setup_path, notice: "Please set up your account to continue."
    end
  end

end
