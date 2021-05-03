class UpdateNamesInFriendship < ActiveRecord::Migration[5.2]
  def change
    rename_column :friendships, :initiator_id, :user_id
    rename_column :friendships, :invitee_id, :friend_id
    add_column :friendships, :initiator_id, :integer 
    add_index :friendships, [:user_id, :friend_id], :unique => true
  end
end
