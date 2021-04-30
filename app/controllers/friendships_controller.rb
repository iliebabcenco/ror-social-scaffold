class FriendshipsController < ApplicationController
  def create
    invitee = User.find(params[:friendship][:invitee_id])
    invitation = current_user.initiated_friendships.build(invitee: invitee)
    if invitation.save
      redirect_to users_path, notice: 'Invitation was successfully sent'
    else
      redirect_to users_path, alert: invitation.errors.full_messages.join('. ').to_s
    end
  end

  private

    def friendship_param

    end
end
