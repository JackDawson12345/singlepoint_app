class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :set_session_domain

  private

  def set_session_domain
    if Rails.env.development?
      request.session_options[:domain] = '.lvh.me'
    else
      request.session_options[:domain] = '.yourdomain.com'
    end
  end
end
