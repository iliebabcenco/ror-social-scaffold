class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships
  has_many :friends, through: :friendships, source: :friend
  has_many :confirmed_friendships, class_name: 'Friendship', -> where: { confirmed: true }
  has_many :confirmed_friends, through: :confirm_friendships, source: :friend
  has_many :pending_friendships, class_name: 'Friendship', -> where: { confirmed: nil }
  has_many :pending_friends, through: :pending_friendships, source: :friend


  def received_requests
    pending_friends.where('NOT initiator_id = ?', id)
  end

  def confirm_friend(friend_id)
    friendship1 = friendships.where('user_id = ? AND friend_id = ?', id, friend_id).first
    friendship2 = friendships.where('friend_id = ? AND user_id = ?', id, friend_id).first
    result = true
    unless friendship1.nil? && friendship2.nil?
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
    end
    result
  end

  def reject_friend(friend_id)
    result = true
    friendship1 = friendships.where('user_id = ? AND friend_id = ?', id, friend_id).first
    friendship2 = friendships.where('friend_id = ? AND user_id = ?', id, friend_id).first
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
end
