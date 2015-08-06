class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :invited_friends, dependent: :destroy
  has_many :invited_users, class_name: "User", foreign_key: :invited_user_id
  belongs_to :inviter_user, class_name: "User", foreign_key: :invited_user_id

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :email, email: true
  validates :password, length: { minimum: 1 }

  after_initialize :default_activation_state
  after_create     :clear_invites

  def invite_friend(email)
    if User.where(email: email).empty?
      invite = self.invited_friends.find_or_initialize_by(email: email)
      invite.check_invite_friend!
      UserMailer.invite_friend(invite).deliver_now
    else
      fail Exceptions::FriendWatchingException
    end
  end

  def actived?
    self.activation_state == "active"
  end

  private
  def default_activation_state
    self.activation_state ||= "new"
  end

  def clear_invites
    InvitedFriend.where(email: self.email).destroy_all
  end
end
