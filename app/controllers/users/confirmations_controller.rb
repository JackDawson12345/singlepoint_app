class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      flash[:notice] = "Your account has been confirmed."
      sign_in(resource)

      # FULL hardcoded URL (no route helper issues)
      redirect_to "http://manage.lvh.me:3000/", allow_other_host: true

      Rails.logger.info("Signed in user: #{resource.email}")
    else
      flash[:alert] = resource.errors.full_messages.join(', ')
      redirect_to new_user_session_path
    end
  end
end
