require 'rails_helper'

RSpec.describe User, type: :model do
  context 'correctly associates initiator to invitee' do
    let(:initiator) { User.create!(name: 'initiator', password: '123456', email: 'mail@mail.com') }
    let(:invitee) { User.create!(name: 'invitee', password: '123456', email: 'mail2@mail.com') }

    it 'checking sent requests list' do
      Friendship.create_friendship(initiator, invitee)
      expect(invitee.received_requests.size).to eq 1
    end

    it 'checking confirmed friends list' do
      Friendship.create_friendship(initiator, invitee, true)
      expect(initiator.confirmed_friends.size).to eq 1
    end

    it 'checking friend? method' do
      Friendship.create_friendship(initiator, invitee)
      invitee.confirm_friend(initiator.id)
      expect(initiator.friend?(invitee)).to be true
    end
  end

  context 'correctly associates invitee to initiator' do
    let(:initiator) { User.create!(name: 'initiator', password: '123456', email: 'mail@mail.com') }
    let(:invitee) { User.create!(name: 'invitee', password: '123456', email: 'mail2@mail.com') }

    it 'checking received_requests method' do
      Friendship.create_friendship(initiator, invitee)
      expect(invitee.received_requests.size).to eq 1
    end

    it 'checking confirm friend method' do
      Friendship.create_friendship(initiator, invitee)
      invitee.confirm_friend(initiator.id)
      expect(invitee.confirmed_friends).to include(initiator)
    end

    it 'checking reject friend method' do
      Friendship.create_friendship(initiator, invitee)
      invitee.reject_friend(initiator.id)
      expect(invitee.received_requests).not_to include(initiator)
    end
  end
end
