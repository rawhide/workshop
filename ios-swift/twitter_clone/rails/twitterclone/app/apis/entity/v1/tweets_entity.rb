module Entity
  module V1
    class TweetsEntity < Grape::Entity
      expose :body, :created_at

      expose :user do |tweet|
        tweet.user.name
      end
    end
  end
end
