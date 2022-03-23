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
        session[:remembered] == "1" ? remember(@user) : forget(@user)
        redirect_back_or(@user)
        return
      else
        flash.now[:messages] = [
          {
            "title": "Sign in failure",
            "subtitles": ["The password is incorrect"],
            "type": "negative"
          }
        ]
      end
    else
      flash.now[:messages] = [
        {
          "title": "Sign in failure",
          "subtitles": ["The User with such an email does not exist"],
          "type": "negative"
        }
      ]
    end
    render(:new, status: :unprocessable_entity)
  end

  def destroy()
    sign_out(@user) if signed_in()
    redirect_to(root_url(), status: :see_other)
  end

  private def filter_params()
    return params.require(:session).permit(
      :email, :password, :remembered)
  end
end
