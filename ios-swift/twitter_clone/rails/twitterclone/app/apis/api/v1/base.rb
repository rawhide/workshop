module API
  module V1
    class Base < Grape::API
      format :json
      default_format :json

      prefix 'api'
      version 'v1', using: :path

      helpers do
        def current_user
          User.find(1)
        end
      end

      mount V1::Tweets
    end
  end
end
