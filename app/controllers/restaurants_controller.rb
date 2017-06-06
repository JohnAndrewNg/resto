class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all

    render("restaurants/index.html.erb")
  end

  def show
    @restaurant = Restaurant.find(params[:id])

    render("restaurants/show.html.erb")
  end

  def new
    @restaurant = Restaurant.new

    render("restaurants/new.html.erb")
  end

  def create

    if Restaurant.find_by( {:placeid => params[:placeid]}) == nil

      @restaurant = Restaurant.new

      @restaurant.placeid = params[:placeid]
      @restaurant.name = params[:name]
      @restaurant.latitude = params[:latitude]
      @restaurant.longitude = params[:longitude]
      @restaurant.price_level = params[:price_level]
      @restaurant.rating = params[:rating]
      if params[:photo_reference] = "missing"
      else
        @restaurant.photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&maxheight=600&photoreference="+params[:photo_reference]+"&key=AIzaSyAuo4_mSeoT40F-4QAP8uyTvCdw8c7cbvU"
      end
      url_details =
      "https://maps.googleapis.com/maps/api/place/details/json?placeid="+@restaurant.placeid+"&key= AIzaSyAuo4_mSeoT40F-4QAP8uyTvCdw8c7cbvU"

      parsed_data = JSON.parse(open(url_details).read)

      @restaurant.addresss = parsed_data["result"]["formatted_address"]
      @restaurant.phone_number = parsed_data["result"]["formatted_phone_number"]
#      for num in 0..12 do
#        if parsed_data["result"]["address_components"][num]["types"] == "postal_code"
#          @restaurant.zipcode = parsed_data["result"]["address_components"][num]["long_name"]
#          break
#        else
#        end
#      end
#      @restaurant.zipcode = parsed_data["result"]["address_components"][7]["long_name"]
      @restaurant.opening_hours = parsed_data["result"]["opening_hours"]["weekday_text"]
      @restaurant.url = parsed_data["result"]["website"]

      save_status = @restaurant.save

      if save_status == true
        #        redirect_to("/restaurants/#{@restaurant.id}", :notice => "Restaurant created successfully.")
        redirect_to controller: "favorites", action: "create", user_id: current_user.id, restaurant_id: Restaurant.find_by( {:placeid => params[:placeid]}).id

      else
        render("restaurants/new.html.erb")
      end

    else
      #      redirect_to("/create_favorite", :user_id => current_user.id, :restaurant_id => Restaurant.find_by( {:placeid => params[:placeid]}).id)

      redirect_to controller: "favorites", action: "create", user_id: current_user.id, restaurant_id: Restaurant.find_by( {:placeid => params[:placeid]}).id
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])

    render("restaurants/edit.html.erb")
  end

  def update
    @restaurant = Restaurant.find(params[:id])

    @restaurant.placeid = params[:placeid]
    @restaurant.name = params[:name]
    @restaurant.latitude = params[:latitude]
    @restaurant.longitude = params[:longitude]
    @restaurant.addresss = params[:addresss]
    @restaurant.zipcode = params[:zipcode]
    @restaurant.phone_number = params[:phone_number]
    @restaurant.url = params[:url]
    @restaurant.price_level = params[:price_level]
    @restaurant.rating = params[:rating]
    @restaurant.opening_hours = params[:opening_hours]
    @restaurant.photo_url = params[:photo_url]

    save_status = @restaurant.save

    if save_status == true
      redirect_to("/restaurants/#{@restaurant.id}", :notice => "Restaurant updated successfully.")
    else
      render("restaurants/edit.html.erb")
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])

    @restaurant.destroy

    if URI(request.referer).path == "/restaurants/#{@restaurant.id}"
      redirect_to("/", :notice => "Restaurant deleted.")
    else
      redirect_to(:back, :notice => "Restaurant deleted.")
    end
  end
end
