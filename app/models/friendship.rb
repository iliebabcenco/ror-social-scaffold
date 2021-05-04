class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  scope :pending, -> { where(confirmed: nil) }
  scope :confirmed, -> { where(confirmed: true) }

  def self.create_friendship(initiator, invitee, confirmed = nil)
    begin
      ActiveRecord::Base.transaction do
        Friendship.create!(user_id: initiator.id, friend_id: invitee.id, initiator_id: initiator.id,
                           confirmed: confirmed)
        Friendship.create!(user_id: invitee.id, friend_id: initiator.id, initiator_id: initiator.id,
                           confirmed: confirmed)
      end
    rescue ActiveRecord::Rollback
      return false
    end
    true
  end
end
