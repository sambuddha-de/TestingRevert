class ApplicationController < ActionController::Base

  rescue_from Exception, :with => :error_render_method

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  Rails.cache.clear

  def error_render_method
    render :file => File.join(Rails.root, 'public', '500.html'), :layout => false
    true
  end

end
