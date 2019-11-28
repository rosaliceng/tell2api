module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]
      before_action :authorize_request, except: [:create]

      # GET /users
      def index
        @users = User.all

        render json: {result: @users, error: nil}
      end

      def searchUserByEmail
        user = User.where(" email LIKE ?","%#{params[:search]}%").select([:id,:name,:email,:country])
        puts ">>>>>>>>>>>=======#{user}"
        render json:{results: user}
      end

      def current
        render json:{ result: @current_user, error: nil}
      end

      # GET /users/1
      def show
        render json: {result: @user.as_json(:except=>[:password_digest]), error: @user.errors.full_messages}
      end

      # POST /users
      def create
        @user = User.new(user_params)

        if @user.save
          puts "=========success"
          response.status = 201
          puts @user
          render json: {result: @user.as_json(except: [:password_digest]), error: nil}
        else
          response.status = 409
          puts "=========error"
          puts @user.errors.full_messages
          render json: {result: nil, error: @user.errors.full_messages}
        end
      end

      # PATCH/PUT /users/1
      def update
        if @user.update(user_params)
          response.status = 200
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # DELETE /users/1
      def destroy
        @user.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def user_params
          params.permit(:name,:email,:password, :country)
        end
    end
  end
end
