module UsersHelper
  def include_invite_link?(user1, user2)
    !(user1.id == user2.id || user1.friends.include?(user2))
  end

  def has_pending_friend_request(user)
    user.received_requests.size > 0
  end
end
