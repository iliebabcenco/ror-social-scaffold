require 'rails_helper'

feature 'User creates new Friendship' do
  scenario 'creating a new Friendship' do
    u1 = User.create!(name: 'initiator', password: '123456', email: 'mail@mail.com')
    User.create!(name: 'invitee', password: '123456', email: 'mail2@mail.com')

    visit user_session_path
    fill_in 'user[email]', with: u1.email
    fill_in 'user[password]', with: u1.password

    click_button 'commit'

    visit users_path
    click_button 'commit'

    expect(page).to have_text 'Invitation was successfully sent'
  end
end

feature 'User creates new Friendship' do
  scenario 'creating a new Friendship' do
    u1 = User.create!(name: 'initiator', password: '123456', email: 'mail@mail.com')
    u2 = User.create!(name: 'invitee', password: '123456', email: 'mail2@mail.com')

    visit user_session_path
    fill_in 'user[email]', with: u1.email
    fill_in 'user[password]', with: u1.password

    click_button 'commit'

    visit users_path
    click_button 'commit'

    click_link 'Sign out'

    fill_in 'user[email]', with: u2.email
    fill_in 'user[password]', with: u2.password
    click_button 'commit'

    visit user_path(u2)

    expect(page).to have_text 'Reject'
  end
end
