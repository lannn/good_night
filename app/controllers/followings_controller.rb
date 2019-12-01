class FollowingsController < ApplicationController
  def create
    following = current_user.followings.build(follower_id: params[:follower_id])

    if following.save
      render json: following, status: :created
    else
      render json: { errors: following.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    following = current_user.followings.find(params[:id])
    following.destroy
    head :no_content
  end
end
