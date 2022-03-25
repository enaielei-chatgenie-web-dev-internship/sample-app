class PasswordResetsController < ApplicationController
  before_action(:get_user, only: [:edit, :update])
  before_action(:valid_user, only: [:edit, :update])
  before_action(:check_expiration, only: [:edit, :update])

  def new()
  end

  def create()
    form = params[:password_reset]
    @user = User.find_by(email: form[:email].downcase())

    if @user
      @user.create_reset_digest()
      @user.send_password_reset_email()
      flash[:messages] = [
        {
          "title": "Reset instructions sent!",
          "subtitles": ["Please check you email and follow the instructions"],
          "type": "positive"
        }
      ]
      redirect_to(root_url())
    else
      flash.now[:messages] = [
        {
          "title": "Failed sending reset instructions!",
          "subtitles": ["A user with such an email does not exist"],
          "type": "negative"
        }
      ]
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit()
  end

  def update()
    user = params[:user]
    if user[:password].empty?()
      flash.now[:messages] = [
        {
          "title": "Invalid password!",
          "subtitles": ["Password must not be empty"],
          "type": "negative"
        }
      ]
      render(:edit, status: :unprocessable_entity)
    elsif @user.update(filter_params())
      flash[:messages] = [
        {
          "title": "Password changed!",
          "subtitles": ["You can now try signing in using your new password"],
          "type": "positive"
        }
      ]
      redirect_to(root_url())
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private()

  def filter_params()
    return params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user()
    @user = User.find_by(email: params[:email])
  end

  def valid_user()
    # debugger()
    if !@user || !@user.activated?() || !@user.authenticated(:reset, params[:id])
      redirect_to(root_url())
    end
  end

  def check_expiration()
    if @user.reset_expired()
      flash[:messages] = [
        {
          "title": "Invalid password reset link!",
          "subtitles": ["The password reset link has expired"],
          "type": "negative"
        }
      ]
      redirect_to(new_password_reset_url())
    end
  end
end
