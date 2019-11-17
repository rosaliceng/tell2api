module Api
  module V1
    class PlacesController < ApplicationController
      before_action :authorize_request
      before_action :set_places, only: [:show, :update]

      def index
        # if !params[:user_id].nil?

          places = Place.where(:user_id=>@decoded[:user_id])
          puts "=================#{places.count}"
          render json: {results: places.as_json(:include=>[:shareWiths],except:[:created_at,:updated_at,:user_id]), error: nil}
        # else
        #   render json: {result: nil, error: "id must be exists!"}
        # end
      end

      # def show
      #   render json: {result: @place}
      # end

      def create
        place = Place.new(place_params)
        # puts "DECODER value #{@decoder[]}"
        place.user_id = @decoded[:user_id]
        if place.save
          share = ShareWith.new
          share.user_id = params["shareWiths"][0]["user_id"]
          puts ">>>>>>>>>>#{params["shareWiths"][0]["user_id"]}"
          share.place_id = place.id
          if share.save
            response.status = 201
            render json:{result: place, error: nil}
          else
            response.status = 409
            render json:{result: nil, error: share.errors.full_messages}
          end
        else
          puts "ta damdo merda aqui"
          puts "Erro>>>>>#{place.errors.full_messages}"
          response.status = 409
          render json:{result: nil, error: place.errors.full_messages}
        end
      end

      def update
      end


      private
      def set_places
        @place = Place.find_by_id(params[:id])
      end

      def place_params
        params.permit(:address,:isEnable,:lat,:long,:placeName,:radius,:user_id,:place_id)
      end
    end
  end
end
