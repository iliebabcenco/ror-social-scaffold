class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # has_many :friendships
  # has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"

  has_many :initiated_friendships, foreign_key: :initiator_id, class_name: 'Friendship'
  has_many :friends_as_initiator, through: :initiated_friendships, source: :invitee

  has_many :invited_friendships, foreign_key: :invitee_id, class_name: 'Friendship'
  has_many :friends_as_invitee, through: :invited_friendships, source: :initiator

  def friends
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
  end

  def friend?(user)
    friends.include?(user)
  end

end
