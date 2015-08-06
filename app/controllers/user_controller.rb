class UserController < ApplicationController
  before_filter :require_login, only: :invite
  before_filter :load_invite, only: :entrance

  rescue_from 'Exceptions::FriendManyInvitationsException', with: :exception_redirect_with_notice
  rescue_from 'Exceptions::FriendWatchingException',        with: :exception_redirect_with_notice
  rescue_from 'Exceptions::FriendAlreadyInvitedException',  with: :exception_redirect_with_notice
  rescue_from 'Exceptions::InvitedFriendNotValidException',  with: :exception_redirect_with_notice

  def invite
    if current_user.actived?
      current_user.invite_friend(params[:email])
    end
    redirect_to(root_path, notice: t("controller.user.successful_invite"))
  end

  def activate
    if (@user = User.load_from_activation_token(params[:token]))
      @user.activate!
      auto_login(@user)
      redirect_to(root_path, notice: t("controller.user.successful_activate"))
    else
      not_authenticated
    end
  end

  def entrance
    if User.find_by(email: user_params[:email])
      return login_user
    else
      return registration_user
    end
  end

  private
  def login_user
    @user = login(user_params[:email], user_params[:password])
    if @user
      redirect_to(root_path)
    else
      redirect_to(root_path, flash: {error: t("controller.user.failure_login_user")})
    end
  end

  def registration_user
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to(root_path, notice: t("controller.user.successful_registration_user"))
    else
      redirect_to(root_path(ref: @invite.try(:invite_token)), notice: t("controller.user.failure_registration_user"))
    end
  end

  def exception_redirect_with_notice(exception)
    redirect_to(root_path, flash: { exception.flash_type => I18n.t(exception.message, exception.params)})
  end

  def user_params
    params.require(:user).permit(:email, :password).tap do |u|
      if @invite
        u[:email]           = @invite.email
        u[:invited_user_id] = @invite.user_id
      end
    end
  end

  def load_invite
    @invite = InvitedFriend.find(params[:user][:invite_id]) if params[:user][:invite_id]
  end
end
