require 'test_helper'

class CatControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get cat_active.jpg" do
    @user = create(:user_with_password)
    login_user
    get "image"
    assert_response :success
    assert @response.headers["Content-Transfer-Encoding"], "binary"
    assert @response.header["Content-Type"], 'image/png'
    assert @response.header["Content-Disposition"], 'inline; filename="cat.jpg"'
  end

  test "should get with ref token, correct association with invitation" do
    invited_friend = create(:invited_friend)
    get :index, {ref: invited_friend.invite_token}

    assert_select 'form#new_user input[name="user[invite_id]"]' do |input|
      assert input.first["value"], invited_friend.id
    end
    assert_response :success
  end
end
