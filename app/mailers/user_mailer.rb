class UserMailer < ApplicationMailer

  def activation_needed_email(user)
    @user = user
    mail(:to => user.email,
         :subject => "Подтвердите почту для просмотра котика")
  end

  def invite_friend(invite)
    @user = invite.user
    @invite = invite
    mail(:to => @invite.email,
         :subject => "Вас пригласил друг #{@user.email} посмотреть котика")
  end
end
