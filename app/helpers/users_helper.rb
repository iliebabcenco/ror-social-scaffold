module UsersHelper
  def include_invite_link?(user1, user2)
    !(user1.id == user2.id || user1.friends.include?(user2))
  end

  def pending_friend_request?(user)
    user.received_requests.size.positive?
  end

  def user_side_bar(user)
    return unless user.id == current_user.id
    render 'user_page_aside', friend_requests: user.received_requests, friends: user.confirmed_friends
  end

  def render_friend_requests(friends)
    return render 'empty_list_info', info: 'You do not have any pending requests' if friends.empty?
    partials = friends.map { |friend| render 'friend_request', friend: friend }
    safe_join partials
  end

  def render_friends(friends)
    return render 'empty_list_info', info: 'You have not made any friends yet.' if friends.empty?
    partials = friends.map { |friend| render 'friend_request', friend: friend }
    safe_join partials
  end
end
