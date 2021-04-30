require "rails_helper"

RSpec.describe User, type: :model do
    context 'correctly associates initiator to invitee' do
      let(:initiator) { User.create!(name: 'initiator', password: "123456", email: "mail@mail.com") }
      let(:invitee) { User.create!(name: 'invitee', password: "123456", email: "mail2@mail.com") }

      it 'checking sent requests list' do
        f = Friendship.create!(initiator: initiator, invitee: invitee, confirmed: nil)
        expect(initiator.sent_requests.size).to eq 1
      end

      it 'checking confirmed friends list' do
        f = Friendship.create!(initiator: initiator, invitee: invitee, confirmed: true)
        expect(initiator.confirmed_friends.size).to eq 1
      end

      it 'checking friend? method' do
        f = Friendship.create!(initiator: initiator, invitee: invitee, confirmed: nil)
        invitee.confirm_friend(initiator.id)
        expect(initiator.friend?(invitee)).to be true
      end
    end

      context 'correctly associates invitee to initiator' do
        let(:initiator) { User.create!(name: 'initiator', password: "123456", email: "mail@mail.com") }
        let(:invitee) { User.create!(name: 'invitee', password: "123456", email: "mail2@mail.com") }


        it 'checking pending_friends method' do
            f = Friendship.create!(initiator: initiator, invitee: invitee, confirmed: nil)
            expect(invitee.pending_friends.size).to eq 1
        end

        it 'checking received_requests method' do
            f = Friendship.create!(initiator: initiator, invitee: invitee, confirmed: nil)
            expect(invitee.received_requests.size).to eq 1
        end

    end
end
