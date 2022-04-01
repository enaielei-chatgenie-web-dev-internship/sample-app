$(() => {
    $("#account-details-form").form({
        on: "blur",
        selector: {
            message: ".form-error-message"
        },
        fields: {
            "user[email]": ["email", "maxLength[300]"],
            "user[name]": ["empty", "maxLength[150]"],
            "user[password]": ["empty", "minLength[6]"],
            "user[password_confirmation]": {
                rules: [
                    {
                        type: "match[user[password]]",
                        prompt: "Password confirmation must match password"
                    }
                ]
            }
        }
    });

    $("#sign-in-form").form({
        on: "blur",
        selector: {
            message: ".form-error-message"
        },
        fields: {
            "session[email]": ["email"],
            "session[password]": {
                rules: [
                    {
                        type: "empty",
                        prompt: "Password must have a value"
                    }
                ]
            }
        }
    });

    $("#password-reset-form").form({
        on: "blur",
        selector: {
            message: ".form-error-message"
        },
        fields: {
            "password_reset[email]": ["email"],
            "user[password]": ["empty", "minLength[6]"],
            "user[password_confirmation]": {
                rules: [
                    {
                        type: "match[user[password]]",
                        prompt: "Password confirmation must match password"
                    }
                ]
            }
        }
    });

    $("#post-form").form({
        on: "blur",
        selector: {
            message: ".form-error-message"
        },
        fields: {
            "micropost[content]": ["empty", "maxLength[140]"],
        }
    });

    $('.message .close').on('click', function() {
        $(this)
        .closest('.message')
        .transition('fade');
    });

    $("#micropost_images").on("change", function(ev) {
        for(let file of ev.currentTarget.files) {
            let size_in_megabytes = file.size/1024/1024;
            if (size_in_megabytes > 5) {
                alert("Maximum file size is 5MB per image. Please choose a smaller file.");
                ev.preventDefault();
                return
            }
        }
    });

    $(".ui.accordion").accordion();

    $("#micropost_images").on("change", (ev) => {
        let files = ev.currentTarget.files;
        if(files.length > 0) {
            $("#image-previews-parent").removeAttr("style");
            $("#image-previews .image-preview").remove();
            for(file of files) {
                img = $("#image-preview").clone().appendTo("#image-previews");
                id = img.attr("id");
                img.removeAttr("id");
                img.addClass(id);
                img.removeAttr("style");
                img.children("img").attr("src", URL.createObjectURL(file));
            }
        } else {
            $("#image-previews-parent").css("display", "none");
        }
    });

    $("#micropost_images").trigger("change");
});