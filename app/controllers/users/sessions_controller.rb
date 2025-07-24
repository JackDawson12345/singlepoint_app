class Users::SessionsController < Devise::SessionsController
  def destroy
    sign_out(current_user)
    flash[:notice] = 'You have been logged out.'
    redirect_to root_url(host: 'lvh.me', port: 3000, protocol: request.protocol), allow_other_host: true
  end

end
