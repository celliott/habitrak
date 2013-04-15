class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def confirm_logged_in
    if cookies[:user_id]
      session[:user_id] = cookies.signed[:user_id]
    end
    unless session[:user_id] || cookies[:user_id]
      flash[:error] = "Please log in."
      redirect_to(:controller => 'access', :action => 'login')
      return false # halts the before_filter
    else
      return true
    end
  end
  

end
