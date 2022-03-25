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

    $('.message .close').on('click', function() {
        $(this)
        .closest('.message')
        .transition('fade');
    });
});