class AccountController < ApplicationController
  skip_before_filter :authenticate
  before_filter :logged?, :only => [:logout, :expired_password]

  # All the following action are accessible without login
  
  def index
    render :action => "login"
  end

  def login
    return unless request.post?
    if @user = User.find_by_username(params[:username], :include => :employee)
      if @user.compare_password(params[:password])
        if @user.enabled == true
          @user.update_connection
          session[:user] = @user
          session[:initial_uri] ||= permissions_path # TODO Put here the default home page after logging
          redirect_to session[:initial_uri]
          flash[:notice] = "Authentification r&eacute;ussie"
        else
          flash[:error] = "Votre compte est d&eacute;sactiv&eacute;"
        end
        return
      end
    end
    redirect_to login_path
    flash[:error] = "Les identifiants que vous avez rentrer"
  end

  def lost_password
    if !params[:username].nil?
      if User.find_by_username(params[:username])
        AdminMailer.deliver_notice_admin_lost_password(params[:username])
        AdminMailer.deliver_notice_user_lost_password(params[:username])
        flash[:notice] = "L'administrateur a été prévenu"
        redirect_to login_path
      end
    end
  end
  
  # All the following actions are not accessible without login
  
  def logout
    reset_session
    redirect_to login_path
    flash[:notice] = "Vous êtes maintenant déconnecté"
  end
  
  def expired_password
    return unless request.post?
    current_user.updating_password = true
    if current_user.update_attributes(params[:user])
      current_user.update_attributes(:password_updated_at => Time.now)
      redirect_to session[:initial_uri]
      flash[:notice] = "Mot de passe mis à jour avec succès"
    end
    current_user.updating_password = false
  end
  
  private
  
  def logged?
    if current_user.nil?
      redirect_to login_path
    end
  end
end
