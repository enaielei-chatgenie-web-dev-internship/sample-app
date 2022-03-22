class SessionsController < ApplicationController
  def new()
    @user = get_user()
    if @user
      redirect_to(@user, status: :see_other)
    end
  end

  def create()
    session = filter_params()
    @user = User.find_by(email: session[:email].downcase())

    if @user
      if @user.authenticate(session[:password])
        sign_in(@user)
        redirect_to(@user)
        return
      else
        flash.now[:errors] = [
          "The password is incorrect"
        ]
      end
    else
      flash.now[:errors] = [
        "The User with such an email does not exist"
      ]
    end
    render(:new, status: :unprocessable_entity)
  end

  def destroy()
    sign_out()
    redirect_to(root_url(), status: :see_other)
  end

  private def filter_params()
    return params.require(:session).permit(
      :email, :password)
  end
end
