class User < ApplicationRecord
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates(:email, presence: true, length: {maximum: 300},
        format: {with: VALID_EMAIL_REGEX},
        uniqueness: true
    )

    validates(:name, presence: true, length: {maximum: 150})

    validates(:password, presence: true, length: {minimum: 6})

    before_save() {self.email = email.downcase()}

    has_secure_password()
end
