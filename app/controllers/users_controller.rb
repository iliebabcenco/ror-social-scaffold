class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(:user).ordered_by_most_recent
  end

  def confirm_friendship
    friendship = current_user.confirm_friend(params[:friend_id])
    if friendship
      redirect_to user_path(current_user), notice: 'Friend successfully confirmed'
    else
      friendship.errors
      redirect_to user_path(current_user), alert: 'Could not find friend request'
    end
  end

  def reject_friendship
    if current_user.reject_friend(params[:id])
      redirect_to user_path(current_user), notice: 'Friend Request Rejected'
    else
      redirect_to user_path(current_user), alert: 'Request not completed. please try again.'
    end
  end
end
