class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :initiated_friendships, foreign_key: :initiator_id, class_name: 'Friendship'
  has_many :friends_as_initiator, through: :initiated_friendships, source: :invitee

  has_many :invited_friendships, foreign_key: :invitee_id, class_name: 'Friendship'
  has_many :friends_as_invitee, through: :invited_friendships, source: :initiator

  def friends
    friends_as_initiator + friends_as_invitee
  end

  def confirmed_friends
    friends_as_initiator.merge(Friendship.confirmed) + friends_as_invitee.merge(Friendship.confirmed)
  end

  def pending_friends
    friends_as_initiator.merge(Friendship.pending) + friends_as_invitee.merge(Friendship.pending)
  end

  def sent_requests
    friends_as_initiator.merge(Friendship.pending)
  end

  def received_requests
    friends_as_invitee.merge(Friendship.pending)
  end

  def confirm_friend(id)
    friendship = invited_friendships.find_by_initiator_id(id)
    unless friendship.nil?
      friendship.confirmed = true
      friendship.save
    end
    friendship
  end

  def reject_friend(id)
    friendship = invited_friendships.find_by_initiator_id(id)
    return friendship.destroy unless friendship.nil?

    false
  end

  def friend?(user)
    confirmed_friends.include?(user)
  end
end
