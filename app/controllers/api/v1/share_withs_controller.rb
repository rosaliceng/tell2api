module Api
  module V1
    class ShareWithsController < ApplicationController
      before_action :authorize_request, except: [:create]

      def create
        share = ShareWith.new(share_params)
        if share.save
          render json: {results: share, error: nil}
        else
          render json: {result: nil, error: share.errors.full_messages}
        end
      end

      private
      def share_params
        params.permit(:user_id,:place_id)
      end
    end
  end
end
