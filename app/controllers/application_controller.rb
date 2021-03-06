class ApplicationController < ActionController::Base
  # helper_method :current_user

  def authenticate
    if !signed_in?
      redirect_to new_session_path
    end
  end

  def current_email
    session[:current_email]
  end

  def signed_in?
    current_email.present?
  end

  def signed_in_as(email)
    session[:current_email] = email
  end

  def current_user
    @current_user = User.new(current_email)
    # p "displaying email of current user"
    # p @current_user.email
  end
end
