class UserSessionsController < ApplicationController
  before_action :set_types_of_selectable_levels

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to root_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, success: t('.success')
  end

  private

  def set_types_of_selectable_levels
    @level = Sheet.types_of_selectable_levels
  end
end
