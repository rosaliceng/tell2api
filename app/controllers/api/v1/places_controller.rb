module Api
  module V1
    class PlacesController < ApplicationController
      before_action :authorize_request
      before_action :set_places, only: [:show, :update]

      def index
          places = Place.where(:user_id=>@decoded[:user_id])
          placeData = places.as_json(:include=>[:shareWiths=>{:include=>[:user]}],except:[:created_at,:updated_at,:user_id])
          puts placeData
          render json: {results: placeData, error: nil}
      end

      def create
        place = Place.new(place_params)
        place.user_id = @decoded[:user_id]
        if place.save
          unless params["shareWiths"][0].empty?
            share = ShareWith.new
            share.user_id = params["shareWiths"][0]["user_id"]
            share.place_id = place.id
            if share.save
              response.status = 201
              render json:{result: place, error: nil}
            else
              response.status = 409
              render json:{result: nil, error: share.errors.full_messages}
            end
          else
            response.status = 201
            render json:{result: place, error:nil}
          end
        else
          response.status = 409
          render json:{result: nil, error: place.errors.full_messages}
        end
      end

      def show
        render json:{result: @place, error: nil}
      end

      def update
        if place = Place.update(params[:id],place_params)
          shareParams = params["shareWiths"][0]
          if shareParams['id'] != nil
            shareWith = ShareWith.find_by_id(shareParams["id"])
            shareWith.place_id = shareParams['place_id']
          else
            shareWith = ShareWith.new
            shareWith.place_id = place.id
          end
          shareWith.user_id = shareParams['user_id']
          if shareWith.save
            response.status = 200
            render json:{result: place, error: nil}
          else
            render json:{result: nil, error: shareWith.errors.full_messages}
          end
        else
          response.status = 409
          render json:{result: nil, error: place.errors.full_messages}
        end
      end

      def destroy
        if place = Place.find_by_id(params[:id]).destroy
          if share = ShareWith.where("place_id = ?",params[:id]).destroy_all
            render json: {result: nil, error: nil}
          else
            render json: {result: nil, error: share.errors.full_messages}
          end
        else
          render json: {result: nil, error: place.errors.full_messages}
        end

      end

      private
      def set_places
        begin
          @place = Place.find_by_id(params[:id])
        rescue
          render json:{result: nil, error: @place.errors.full_messages}
        end
      end

      def place_params
        params.permit(:address,:isEnable,:lat,:long,:placeName,:radius,:user_id,:place_id)
      end
    end
  end
end
