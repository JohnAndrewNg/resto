class SearchController < ApplicationController
  def new
    @location = current_user.location


    url_map = "http://maps.googleapis.com/maps/api/geocode/json?address="+@location
    parsed_data = JSON.parse(open(url_map).read)
    @latitude = parsed_data["results"][0]["geometry"]["location"]["lat"]
    @longitude = parsed_data["results"][0]["geometry"]["location"]["lng"]


    render("search/new.html.erb")
  end

  def results
    @address = params[:address]
    @keyword = params[:keyword]

    url_search = "http://maps.googleapis.com/maps/api/geocode/json?address="+@address
    parsed_data = JSON.parse(open(url_search).read)
    @latitude = parsed_data["results"][0]["geometry"]["location"]["lat"]
    @longitude = parsed_data["results"][0]["geometry"]["location"]["lng"]

    @lat = @latitude.to_s
    @lng = @longitude.to_s

    url_restaurants = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+@lat+","+@lng+"&keyword="+@keyword+"&radius=500&type=restaurant&key=AIzaSyAuo4_mSeoT40F-4QAP8uyTvCdw8c7cbvU"

    parsed_data = JSON.parse(open(url_restaurants).read)
    @results = parsed_data["results"]

    render("search/results.html.erb")
  end

  #  def destroy
  #    @user = User.find(params[:id])

  #    @user.destroy

  #    if URI(request.referer).path == "/user/#{@user.id}"
  #      redirect_to("/", :notice => "User deleted.")
  #    else
  #      redirect_to(:back, :notice => "User deleted.")
  #    end
  #  end


end
