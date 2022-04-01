class MicropostsController < ApplicationController
    before_action(:authenticated, only: [:new, :create, :destroy])
    before_action(:correct_user, only: [:destroy])

    def new()
        @user = get_user()
        @micropost = @user.microposts.new() if signed_in()
        @microposts = @user.feed().page(params[:page]).per(params[:count] || 15)
    end

    def create()
        @user = get_user()
        @micropost = @user.microposts.new(filter_params()) if signed_in()
        @micropost.images.attach(params[:micropost][:images])
        @microposts = @user.feed().page(params[:page]).per(params[:count] || 15)
        if @micropost.save()
            flash[:messages] = [
                {
                    "title": "Micropost created!",
                    "subtitles": ["Your micropost has been created"],
                    "type": "positive"
                }
            ]
            redirect_to(new_micropost_url())
        else
            render(:new, status: :unprocessable_entity)
        end
    end

    def destroy()
        attachment_id = params["attachment-id"]
        if attachment_id
            attachment = @micropost.images.find(attachment_id)
            attachment.purge()
            flash[:messages] = [
                {
                    "title": "Successfully deleted image attachement!",
                    "subtitles": ["Your image for a micropost has been deleted"],
                    "type": "positive"
                }
            ]
        else
            @micropost.destroy()
            flash[:messages] = [
                {
                    "title": "Micropost deleted!",
                    "subtitles": ["Your micropost has been deleted"],
                    "type": "positive"
                }
            ]
        end
        redirect_to(new_micropost_url())
    end

    private()

    def filter_params()
        return params.require(:micropost).permit(:content, :images)
    end

    def correct_user()
        @micropost = get_user().microposts.find_by(id: params[:id])
        redirect_to(root_url()) if @micropost.nil?()
    end
end
