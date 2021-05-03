class FriendshipsController < ApplicationController
  def create
    h1 = { :user_id => current_user.id, :friend_id => params[:friendship][:invitee_id], :initiator_id => current_user.id, :confirmed => nil }
    h2 = { :user_id => params[:friendship][:invitee_id], :friend_id => current_user.id, :initiator_id => current_user.id, :confirmed => nil  }
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
