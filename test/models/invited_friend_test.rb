require 'test_helper'

class InvitedFriendTest < ActiveSupport::TestCase
  test "#check_invite_friend! Exceptions::FriendAlreadyInvitedException" do
    user = create(:user_with_password)
    invite = create(:invited_friend)

    assert_raises "Exceptions::FriendAlreadyInvitedException" do
      user.invite_friend(invite.email)
    end
  end

  test "#check_invite_friend! Exceptions::FriendManyInvitationsException" do
    user = create(:user_with_password)
    email = Faker::Internet.email
    user.invite_friend(email)

    assert_raises "Exceptions::FriendManyInvitationsException" do
      user.invite_friend(email)
    end
  end

  test "#check_invite_friend! Exceptions::InvitedFriendNotValidException" do
    user = create(:user_with_password)

    assert_raises "Exceptions::FriendManyInvitationsException" do
      user.invite_friend("failemail")
    end
  end
end