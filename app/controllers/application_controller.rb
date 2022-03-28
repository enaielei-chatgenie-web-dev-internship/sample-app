class ApplicationController < ActionController::Base
    include SessionsHelper

    $AUTHOR = "Nommel Isanar L. Amolat"

    
    private()
    
    def authenticated()
        if !signed_in()
        store_location()
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
end
