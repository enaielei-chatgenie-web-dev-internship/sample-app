module SessionsHelper
    def sign_in(user)
        session[:user_id] = user.id
    end

    def get_user()
        if(user_id = session[:user_id])
            return User.find_by(id: session[:user_id])
        elsif(user_id = cookies.signed[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated(:remember, cookies[:remember_token])
                sign_in(user)
                return user
            end
        end
    end

    def signed_in()
        return !!session[:user_id]
    end

    def sign_out(user)
        forget(user)
        session.delete(:user_id)
        return nil
    end

    def remember(user)
        user.remember()
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def forget(user)
        user.forget() if user
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    def check_user(user)
        user && user == get_user()
    end

    # Redirects to stored location or to the default one
    def redirect_back_or(default, response_options={})
        redirect_to(session[:forwarding_url] || default, response_options)
        session.delete(:forwarding_url)
    end

    # Stores the URL trying to be accessed
    def store_location()
        session[:forwarding_url] = request.original_url() if request.get?()
    end
end
