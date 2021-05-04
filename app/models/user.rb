class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships
  has_many :friends, through: :friendships, source: :friend

  def received_requests
    friends.where('NOT initiator_id = ?', id).merge(Friendship.pending)
  end

  def confirmed_friends
    friends.merge(Friendship.confirmed)
  end

  def confirm_friend(friend_id)
    friendship1 = Friendship.where('user_id = ? AND friend_id = ?', id, friend_id).first
    friendship2 = Friendship.where('user_id = ? AND friend_id = ?', friend_id, id).first
    result = true
    return false if friendship1.nil? || friendship2.nil?

    friendship1.confirmed = true
    friendship2.confirmed = true
    begin
      ActiveRecord::Base.transaction do
        friendship1.save!
        friendship2.save!
      end
    rescue ActiveRecord::Rollback
      result = false
    end

    result
  end

  def reject_friend(friend_id)
    result = true
    friendship1 = Friendship.where('user_id = ? AND friend_id = ?', id, friend_id).first
    friendship2 = Friendship.where('friend_id = ? AND user_id = ?', id, friend_id).first
    begin
      ActiveRecord::Base.transaction do
        return friendship1.destroy && friendship2.destroy unless friendship1.nil? || friendship2.nil?
      end
    rescue ActiveRecord::Rollback
      result = false
    end
    result
  end

  def friend?(user)
    confirmed_friends.include?(user)
  end

  def friends_and_own_posts
    Post.where(user: (self.confirmed_friends.to_a << self))
 end
end
