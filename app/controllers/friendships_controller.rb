class FriendshipsController < ApplicationController
  def create
    friend_id = params[:user][:invitee_id]
    #render json: params
    h1 = { :user_id => current_user.id, :friend_id => friend_id, :initiator_id => current_user.id, :confirmed => nil }
    h2 = { :user_id => friend_id, :friend_id => current_user.id, :initiator_id => current_user.id, :confirmed => nil  }
    begin
      ActiveRecord::Base.transaction do
        Friendship.create!(h1)
        Friendship.create!(h2)
      end
      redirect_to users_path, notice: 'Invitation was successfully sent'
    rescue ActiveRecord::Rollback
      redirect_to users_path, alert: 'Cannot create such friendship'
    end
  end
end
