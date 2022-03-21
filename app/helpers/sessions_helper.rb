module SessionsHelper
    def sign_in(user)
        session[:user_id] = user.id
    end

    def get_user()
        if session[:user_id]
            return User.find_by(id: session[:user_id])
        end
    end

    def signed_in()
        return !!session[:user_id]
    end

    def sign_out()
        session.delete(:user_id)
    end
end
