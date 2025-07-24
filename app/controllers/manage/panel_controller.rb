class Manage::PanelController < ApplicationController
  layout 'manage'
  before_action :authenticate_user!
  before_action :not_admin
  def index
  end


  private

  def not_admin
    if current_user&.admin?
      redirect_to root_url(subdomain: 'admin'), alert: 'Access denied.', allow_other_host: true
    end
  end

end
