class UsersController < ApplicationController
  def index
    @users = User.all

    render("users/index.html.erb")
  end

  def show
    @user = User.find(params[:id])

    render("users/show.html.erb")
  end

  def timeline
    @user = current_user

    render("timeline.html.erb")
  end



  def destroy
    @user = User.find(params[:id])

    @user.destroy

    if URI(request.referer).path == "/user/#{@user.id}"
      redirect_to("/", :notice => "User deleted.")
    else
      redirect_to(:back, :notice => "User deleted.")
    end
  end


end
