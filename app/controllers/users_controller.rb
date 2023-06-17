class UsersController < ApplicationController
  before_action :set_types_of_selectable_levels

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end

  def set_types_of_selectable_levels
    @level = Sheet.types_of_selectable_levels
  end
end
