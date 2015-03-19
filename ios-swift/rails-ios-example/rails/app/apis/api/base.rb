module API
  class Base < Grape::API
    format :json
    default_format :json

    prefix 'api'
    version 'v1', using: :path

    mount V1::Users
  end
end
