module API
  module V1
    class Tweets < Grape::API
      helpers do
        def tweet_params
          ActionController::Parameters.new(params).permit(:body)
        end
      end

      resource :tweets do
        get do
          present Tweet.includes(:user).order(id: :desc), with: Entity::V1::TweetsEntity
        end

        params do
          requires :body, type: String, desc: 'Tweet body.'
        end
        post do
          tweet = current_user.tweets.create(tweet_params)
          present tweet, with: Entity::V1::TweetsEntity
        end
      end
    end
  end
end
