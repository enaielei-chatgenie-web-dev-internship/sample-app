module UsersHelper
    # Use Gravatar to grab the profile picture.
    def get_profile_image(user, options={})
        id = Digest::MD5::hexdigest(user.email.downcase())
        url = "https://secure.gravatar.com/avatar/#{id}"
        return image_tag(url, options)
    end
end
