require 'test_helper'

class UserControllerTest < ActionController::TestCase

  def setup
    @user_attributes = attributes_for(:user_with_password)
  end

  test "should registration new user" do
    post :entrance, {user: @user_attributes}
    user = User.find_by(email: @user_attributes[:email])
    assert_not_nil user
    assert user.activation_state, "pending"
    assert_redirected_to root_url
  end

  test "should registration send mail for new user" do
    assert_difference('ActionMailer::Base.deliveries.size', +1) do
      post :entrance, {user: @user_attributes}
    end
  end

  test "should redirect root after registration" do
    post :entrance, {user: @user_attributes}
    assert_redirected_to root_url
  end

  test "should successful login new user" do
    @user = create(:user_with_password)
    login_user
    assert_not_nil session[:user_id]
    assert logged_in?
    logout_user

    post :entrance, {user: {email:@user.email, password: "test"}}
    assert_redirected_to root_url
  end

  test "should failure login new user" do
    @user = create(:user_with_password)

    post :entrance, {user: {email:@user.email}}
    assert_nil session[:user_id]
    assert_not logged_in?

    assert_redirected_to root_url
  end

  test "should successful activate new user" do
    @user = create(:user_with_password)

    get(:activate, token: @user.activation_token)
    assert session[:user_id]
    assert logged_in?
    assert @user.reload.actived?

    assert_redirected_to root_url
  end

  test "should failure activate new user" do
    @user = create(:user_with_password)

    get(:activate, token: @user.activation_token + "failure")
    assert_not session[:user_id]
    assert_not logged_in?
    assert_not @user.reload.actived?

    assert_redirected_to root_url
  end

  test "should successful invite friend" do
    @user = create(:user_with_password)
    @user.activate!
    login_user

    assert_difference('InvitedFriend.count', +1) do
      assert_difference('ActionMailer::Base.deliveries.size', +1) do
        post :invite, {email:Faker::Internet.email}
      end
    end

    assert_redirected_to root_url
  end

  test "should failure invite friend, not activate user" do
    @user = create(:user_with_password)
    login_user

    assert_difference('InvitedFriend.count', 0) do
      post :invite, {email:Faker::Internet.email}
    end
    assert_redirected_to root_url
  end

  test "should failure invite friend, activate user incorrect friend email" do
    @user = create(:user_with_password)
    @user.activate!
    login_user

    assert_difference('InvitedFriend.count', 0) do
      post :invite, {email:""}
    end

    assert_difference('InvitedFriend.count', 0) do
      post :invite, {email:"not_email"}
    end

    assert_redirected_to root_url
  end

  test "should failure invite friend, activate user many invitations friend" do
    @user = create(:user_with_password)
    @user.activate!
    login_user

    friend_email = Faker::Internet.email

    assert_difference('InvitedFriend.count', +1) do
      post :invite, {email: friend_email }
    end

    invite = @user.invited_friends.where(email: friend_email).first

    assert_difference('InvitedFriend.count', 0) do
      assert_no_difference 'invite.invite_last_send_at' do
        post :invite, {email: friend_email }
      end
    end

    old_invite_last_send_at = invite.invite_last_send_at

    assert_difference('ActionMailer::Base.deliveries.size', 0) do
      post :invite, {email: friend_email }
    end

    Timecop.freeze(Time.now.in_time_zone + Rails.application.secrets.days_amount_follow_up_send_letter.day) do
      assert_difference('ActionMailer::Base.deliveries.size', +1) do
        post :invite, {email: friend_email }
      end
      new_invite_last_send_at = invite.reload.invite_last_send_at
      assert_not old_invite_last_send_at == new_invite_last_send_at
    end

    assert_redirected_to root_url
  end

  test "should successful registration new user with invited" do
    invited_friend = create(:invited_friend)
    post :entrance, {user: {password: "test", invite_id:invited_friend.id}}
    assert session[:user_id]
    assert logged_in?

    user = User.find_by(email: invited_friend.email)
    assert_not_nil user
    assert user.activation_state, "pending"
    assert user.inviter_user, invited_friend.user
    assert_redirected_to root_url
  end

  test "should failure registration new user with invited" do
    invited_friend = create(:invited_friend)
    post :entrance, {user: {invite_id:invited_friend.id}}

    user = User.find_by(email: invited_friend.email)
    assert_nil user
    assert_redirected_to root_url(ref: invited_friend.invite_token)
  end
end
