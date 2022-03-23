class User < ApplicationRecord
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    attr_accessor(:remember_token)

    validates(:email, presence: true, length: {maximum: 300},
        format: {with: VALID_EMAIL_REGEX},
        uniqueness: true
    )

    validates(:name, presence: true, length: {maximum: 150})

    validates(:password, presence: true, length: {minimum: 6}, allow_nil: true)

    before_save() {self.email = email.downcase()}

    has_secure_password()

    def remember()
        self.remember_token = User.new_token()
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def forget()
        update_attribute(:remember_digest, nil)
    end

    def authenticated(token)
        return false if self.remember_digest.nil?()
        BCrypt::Password.new(self.remember_digest).is_password?(token)
    end

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ?
            BCrypt::Engine::MIN_COST :
            BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token()
        return SecureRandom.urlsafe_base64()
    end
end
