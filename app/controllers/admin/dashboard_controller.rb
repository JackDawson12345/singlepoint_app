class Admin::DashboardController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :admin_only
  def index

  end

  private

  def admin_only
    unless current_user&.admin?
      redirect_to root_url(subdomain: nil), alert: 'Access denied.', allow_other_host: true
    end
  end
end
