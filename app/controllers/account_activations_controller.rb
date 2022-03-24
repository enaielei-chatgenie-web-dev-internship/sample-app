class AccountActivationsController < ApplicationController
    def edit()
        user = User.find_by(email: params[:email])
        if user && !user.activated?() && user.authenticated(:activation, params[:id])
            user.activate()
            sign_in(user)
            flash[:messages] = [
              {
                "title": "Account has been activated!",
                "subtitles": ["You have now full access to the app's features"],
                "type": "positive"
              }
            ]
            redirect_to(user)
        else
            flash[:messages] = [
                {
                    "title": "Account activation failed!",
                    "subtitles": ["The server cannot process the activation link"],
                    "type": "error"
                }
            ]
        end
    end
end
