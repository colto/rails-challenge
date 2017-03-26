class UsersController < ApplicationController
  def index
    @users = User.search(params[:search])
  end

  def show
    @user = User.find(params[:id])
  end

  def add_friend
    user = User.find(params[:user_id])
    if current_user.befriend(user)
      redirect_to users_path, flash: {notice: "You are now friends with #{user.full_name}"}
    end
  end
end
