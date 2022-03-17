class ApplicationController < ActionController::Base
    $AUTHOR = "Nommel Isanar L. Amolat"

    def index()
        render(html: "Hello World!")
    end
end
