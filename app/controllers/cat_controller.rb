require 'open-uri'

class CatController < ApplicationController
  before_filter :require_login, only: :image

  def index
    @user = current_user || User.new
    @invite = InvitedFriend.find_by(invite_token: params[:ref]) if params[:ref]
  end

  def image
    begin
      data = open("http://thecatapi.com//api/images/get?size=med", {read_timeout: 3})
    rescue
      data = File.open(Rails.root.join("public", "cat.jpg"))
    end
    send_data data.read, filename: "cat.jpg", type: "image/jpeg", disposition: 'inline',  stream: 'true', buffer_size: '4096'
  end
end
