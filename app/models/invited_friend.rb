class InvitedFriend < ActiveRecord::Base
  belongs_to :user

  validates :email, uniqueness: true
  validates :user, :email, presence: true
  validates :email, email: true

  def check_invite_friend!
    unless InvitedFriend.where.not(user: self.user).where(email: self.email).empty?
      fail Exceptions::FriendAlreadyInvitedException
    end

    if self.invite_last_send_at.blank?
      generated_invite_token = ::Sorcery::Model::TemporaryToken.generate_random_token
      self.invite_token = generated_invite_token
      self.invite_last_send_at = Time.now.in_time_zone
    else
      days = Rails.application.secrets.days_amount_follow_up_send_letter
      if self.invite_last_send_at.in_time_zone + days.day < Time.now.in_time_zone
        self.invite_last_send_at = Time.now.in_time_zone
      else
        fail Exceptions::FriendManyInvitationsException, days
      end
    end
    unless save
      fail Exceptions::InvitedFriendNotValidException
    end
  end
end
