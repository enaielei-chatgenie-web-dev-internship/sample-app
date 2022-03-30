class UsersController < ApplicationController
  before_action(
    :authenticated, only: [:followers, :following, :show, :index, :edit, :update, :destroy]
  )
  before_action(
    :verify_user, only: [:edit, :update]
  )
  before_action(
    :verify_user_privileges, only: [:destroy]
  )

  def following()
    @user = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(params[:count] || 15)
  end

  def followers()
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(params[:count] || 15)
  end

  def index()
    @users = User.page(params[:page]).per(params[:count] || 15)
  end

  def show()
    @user = User.find(params[:id])
    @microposts = @user.microposts.page(params[:page]).per(params[:count] || 5)
  end

  def new()
    if signed_in()
        redirect_to(user_url(get_user()), status: :see_other)
    end
    @user = User.new()
  end

  def create()
    @user = User.new(filter_params())

    if @user.save()
      @user.send_activation_email()
      flash[:messages] = [
        {
          "title": "Account has been registered!",
          "subtitles": ["Please check your email for verification"],
          "type": "info"
        }
      ]
      redirect_to(root_url())
    else
      # flash.now[:messages] = [
      #   {
      #     "title": "Sign up failure",
      #     "subtitles": ["An account with such an email already exists!"],
      #     "type": "negative"
      #   }
      # ]
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit()
    @user = User.find(params[:id])
  end

  def update()
    @user = User.find(params[:id])

    if @user.update(filter_params())
      flash[:messages] = [
        {
          "title": "Changes saved!",
          "subtitles": ["Your account information has been successfully updated!"],
          "type": "positive"
        }
      ]
      redirect_to(edit_user_url(@user))
    else
      flash[:messages] = [
        {
          "title": "Request rejected!",
          "subtitles": ["There was something wrong with your request, no changes were saved"],
          "type": "negative"
        }
      ]
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy()
    user = User.find(params[:id])
    user.destroy()
    flash[:messages] = [
      {
        "title": "User deleted!",
        "subtitles": ["You have successfully removed '#{user.name}' from the database"],
        "type": "positive"
      }
    ]
    redirect_to(users_url())
  end

  def verify_user_privileges()
    if !get_user().admin?()
      flash[:messages] = [
        {
          "title": "Unauthorized Access!",
          "subtitles": ["Please sign in first into your account"],
          "type": "negative"
        }
      ]
      redirect_to(root_url(), status: :see_other)
    end
  end

  def verify_user()
    @user = User.find(params[:id])
    if !check_user(@user)
      flash[:messages] = [
        {
          "title": "Unauthorized Access!",
          "subtitles": ["Please sign in first into your account"],
          "type": "negative"
        }
      ]
      redirect_to(auth_sign_in_url(), status: :see_other)
    end
  end

  private def filter_params()
    return params.require(:user).permit(
      :name, :email, :password, :password_confirmation)
  end
end
