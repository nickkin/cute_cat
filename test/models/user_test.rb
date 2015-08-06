require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "#default_activation_state" do
    user = build(:user)
    assert user.activation_state == "new"
  end

  test "#clear_invites" do
    invited_friend = create(:invited_friend)
    assert_difference('InvitedFriend.count', -1) do
      create(:user_with_password, email: invited_friend.email)
    end
  end

  test "#invite_friend" do
    user = create(:user_with_password)
    user2 = create(:user_with_password)
    assert_not user.email == user2.email
    assert_raises "Exceptions::FriendWatchingException" do
      user.invite_friend(user2.email)
    end
  end
end
