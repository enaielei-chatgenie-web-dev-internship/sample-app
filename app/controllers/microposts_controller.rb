class MicropostsController < ApplicationController
    before_action(:authenticated, only: [:new, :create, :destroy])
    before_action(:correct_user, only: [:destroy])

    def new()
        @user = get_user()
        @micropost = @user.microposts.new() if signed_in()
        @microposts = @user.microposts.page(params[:page]).per(params[:count] || 15)
    end

    def create()
        @user = get_user()
        @micropost = @user.microposts.new(filter_params()) if signed_in()
        @micropost.image.attach(params[:micropost][:image])
        @microposts = @user.microposts.page(params[:page]).per(params[:count] || 15)
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
        @micropost.destroy()
        flash[:messages] = [
            {
                "title": "Micropost deleted!",
                "subtitles": ["Your micropost has been deleted"],
                "type": "positive"
            }
        ]
        redirect_to(new_micropost_url())
    end

    private()

    def filter_params()
        return params.require(:micropost).permit(:content, :image)
    end

    def correct_user()
        @micropost = get_user().microposts.find_by(id: params[:id])
        redirect_to(root_url()) if @micropost.nil?()
    end
end
