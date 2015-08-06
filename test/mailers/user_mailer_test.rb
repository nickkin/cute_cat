require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "activation_needed_email" do
    user = create(:user_with_password)
    mail = UserMailer.activation_needed_email(user)
    assert_equal [user.email], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "/activate/#{user.activation_token}", mail.body.encoded
  end

  test "invite_friend" do
    invite = create(:invited_friend)

    mail = UserMailer.invite_friend(invite)
    assert_equal [invite.email], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "/?ref=#{invite.invite_token}", mail.body.encoded
  end

end
