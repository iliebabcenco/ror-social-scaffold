module ApplicationHelper
  def menu_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'menu-item active' : 'menu-item'

    content_tag(:div, class: class_name) do
      link_to link_text, link_path
    end
  end

  def like_or_dislike_btn(post)
    like = Like.find_by(post: post, user: current_user)
    if like
      link_to('Dislike!', post_like_path(id: like.id, post_id: post.id), method: :delete)
    else
      link_to('Like!', post_likes_path(post_id: post.id), method: :post)
    end
  end

  def current_user_page_link(user)
    return unless current_user

    box_wrapper('menu-item') do
      menu_link_to 'My Page', user_path(user)
    end
  end

  def login_check(_user)
    if current_user
      link_to 'Sign out', destroy_user_session_path, method: :delete
    else
      link_to 'Sign in', user_session_path
    end
  end

  def render_notification(notice, class_name)
    return unless notice.present?

    box_wrapper(class_name) do
      notice
    end
  end

  private

  def box_wrapper(class_name, &block)
    content = capture(&block)
    content_tag(:div, content, class: class_name)
  end
end
