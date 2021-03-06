class User < ApplicationRecord
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    has_many(:microposts, dependent: :destroy)
    has_many(:active_relationships, class_name: "Relationship",
        foreign_key: "follower_id",
        dependent: :destroy
    )
    has_many(:passive_relationships, class_name: "Relationship",
        foreign_key: "followed_id",
        dependent: :destroy
    )
    has_many(:following, through: :active_relationships, source: :followed)
    has_many(:followers, through: :passive_relationships, source: :follower)

    attr_accessor(:remember_token, :activation_token, :reset_token)

    validates(:email, presence: true, length: {maximum: 300},
        format: {with: VALID_EMAIL_REGEX},
        uniqueness: true
    )

    validates(:name, presence: true, length: {maximum: 150})

    validates(:password, presence: true, length: {minimum: 6}, allow_nil: true)

    before_save(:downcase_email)
    before_create(:create_activation_digest)

    has_secure_password()

    def remember()
        self.remember_token = User.new_token()
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def forget()
        update_attribute(:remember_digest, nil)
    end

    def authenticated(attribute, token)
        digest = self.send("#{attribute}_digest")
        return false if digest.nil?()
        BCrypt::Password.new(digest).is_password?(token)
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

    def activate()
        self.update(activated: true, activated_at: Time.zone.now())
    end

    def send_activation_email()
        UserMailer.account_activation(self).deliver_now()
    end

    def create_reset_digest()
        self.reset_token = User.new_token()
        digest = User.digest(self.reset_token)
        self.update(reset_digest: digest, reset_sent_at: Time.zone().now())
    end

    def send_password_reset_email()
        UserMailer.password_reset(self).deliver_now()
    end

    def reset_expired()
        self.reset_sent_at < 2.hours.ago
    end

    def follow(user)
        self.following.append(user)
    end

    def unfollow(user)
        self.following.delete(user)
    end

    def is_following(user)
        self.following.include?(user)
    end

    def feed()
        following_ids = "
            select followed_id from relationships
            where follower_id = :user_id
        "
        return Micropost.where(
            "user_id in (#{following_ids}) or user_id = :user_id",
            user_id: self.id
        )
    end

    private()

    def downcase_email()
        self.email = email.downcase()
    end

    def create_activation_digest()
        self.activation_token = User.new_token()
        self.activation_digest = User.digest(self.activation_token)
    end
end
