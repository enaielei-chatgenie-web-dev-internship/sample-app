class RelationshipsController < ApplicationController
    before_action(:authenticated)

    def create()
        @user = User.find(params[:followed_id])
        get_user().follow(@user)
        respond_to() do |format|
            format.html() {redirect_to(@user)}
            format.js()
        end
    end

    def destroy()
        @user = Relationship.find(params[:id]).followed
        get_user().unfollow(@user)
        respond_to() do |format|
            format.html() {redirect_to(@user)}
            format.js()
        end
    end
end
