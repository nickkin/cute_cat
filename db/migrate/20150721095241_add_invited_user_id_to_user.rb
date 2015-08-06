class AddInvitedUserIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :invited_user_id, :string
  end
end
