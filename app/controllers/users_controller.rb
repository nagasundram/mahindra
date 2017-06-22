class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to edit_user_registration_path
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to root_path, :alert => "Access denied."
    end
  end

end
