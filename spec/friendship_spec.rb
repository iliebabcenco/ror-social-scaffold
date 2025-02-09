require 'rails_helper'

RSpec.describe Friendship, type: :model do
  context 'correctly associates friend to user' do
    let(:initiator) { User.create!(name: 'initiator', password: '123456', email: 'mail@mail.com') }
    let(:invitee) { User.create!(name: 'invitee', password: '123456', email: 'mail2@mail.com') }
    it 'checking pending friends list' do
      Friendship.create!(user_id: initiator.id, friend_id: invitee.id, initiator_id: initiator.id, confirmed: nil)
      expect(Friendship.pending.size).to eq 1
    end
    it 'checking confirmed friends list' do
      Friendship.create!(user_id: initiator.id, friend_id: invitee.id, initiator_id: initiator.id, confirmed: true)
      expect(Friendship.confirmed.size).to eq 1
    end
  end
end
