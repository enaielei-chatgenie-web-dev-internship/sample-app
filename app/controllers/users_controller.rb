class UsersController < ApplicationController
  def show()
    @user = User.find(params[:id])
  end

  def new()
    @user = get_user() || User.new()
    if signed_in()
      redirect_to(@user, status: :see_other)
    end
  end

  def create()
    @user = User.new(filter_params())

    if @user.save()
      sign_in(@user)
      flash[:signed_up] = {
        "title": "Welcome aboard!",
        "subtitle": "Your account has been successfully created!",
        "type": "positive"
      }
      redirect_to(@user)
    else
      return render(:new, status: :unprocessable_entity)
    end
  end

  private def filter_params()
    return params.require(:user).permit(
      :name, :email, :password, :password_confirmation)
  end
end
