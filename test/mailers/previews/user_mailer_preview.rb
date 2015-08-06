# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/activation_needed_email
  def activation_needed_email
    user = User.create(FactoryGirl.attributes_for(:user_with_password))
    UserMailer.activation_needed_email(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/invite_friend
  def invite_friend
    invite = FactoryGirl.create(:invited_friend)

    UserMailer.invite_friend(invite)
  end

end
