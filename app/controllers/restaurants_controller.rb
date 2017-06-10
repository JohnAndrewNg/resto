class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all

    render("restaurants/index.html.erb")
  end

  def show
    @restaurant = Restaurant.find(params[:id])

    @hours = @restaurant.opening_hours

    @location = @restaurant.name
    @latitude = @restaurant.latitude
    @longitude = @restaurant.longitude
    @zoom = 16


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
      if params[:photo_reference] == "missing"
      else
        @restaurant.photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&maxheight=600&photoreference="+params[:photo_reference]+"&key=AIzaSyAuo4_mSeoT40F-4QAP8uyTvCdw8c7cbvU"
      end
      url_details =
      "https://maps.googleapis.com/maps/api/place/details/json?placeid="+@restaurant.placeid+"&key= AIzaSyAuo4_mSeoT40F-4QAP8uyTvCdw8c7cbvU"

      parsed_data = JSON.parse(open(url_details).read)

      if parsed_data["result"]["formatted_address"] == nil
      else
        @restaurant.address = parsed_data["result"]["formatted_address"]
      end

      if parsed_data["result"]["formatted_phone_number"] == nil
      else
        @restaurant.phone_number = parsed_data["result"]["formatted_phone_number"]
      end
      #      for num in 0..12 do
      #        if parsed_data["result"]["address_components"][num]["types"] == "postal_code"
      #          @restaurant.zipcode = parsed_data["result"]["address_components"][num]["long_name"]
      #          break
      #        else
      #        end
      #      end
      #      @restaurant.zipcode = parsed_data["result"]["address_components"][7]["long_name"]
      if parsed_data["result"]["opening_hours"] == nil
      else
        @restaurant.opening_hours = parsed_data["result"]["opening_hours"]["weekday_text"]
      end

      if parsed_data["result"]["website"] == nil
      else
        @restaurant.url = parsed_data["result"]["website"]
      end

      save_status = @restaurant.save

      if save_status == true
        #        redirect_to("/restaurants/#{@restaurant.id}", :notice => "Restaurant created successfully.")

        if params[:actiontype] == "store"
          redirect_to("/restaurants/#{@restaurant.id}")
        else

          redirect_to controller: "favorites", action: "create", user_id: current_user.id, restaurant_id: Restaurant.find_by( {:placeid => params[:placeid]}).id

        end
      else
        render("restaurants/new.html.erb")
      end

    else
      #      redirect_to("/create_favorite", :user_id => current_user.id, :restaurant_id => Restaurant.find_by( {:placeid => params[:placeid]}).id)

      if params[:actiontype] == "store"
        redirect_to("/restaurants/#{Restaurant.find_by( {:placeid => params[:placeid]}).id}")

      else

        redirect_to controller: "favorites", action: "create", user_id: current_user.id, restaurant_id: Restaurant.find_by( {:placeid => params[:placeid]}).id

      end
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])

    render("restaurants/edit.html.erb")
  end

  def update


    @restaurant = Restaurant.find(params[:id])


    if params[:update_type] == "manual"

      @restaurant.placeid = params[:placeid]
      @restaurant.name = params[:name]
      @restaurant.latitude = params[:latitude]
      @restaurant.longitude = params[:longitude]
      @restaurant.address = params[:address]
      @restaurant.zipcode = params[:zipcode]
      @restaurant.phone_number = params[:phone_number]
      @restaurant.url = params[:url]
      @restaurant.price_level = params[:price_level]
      @restaurant.rating = params[:rating]
#      @restaurant.opening_hours = params[:opening_hours]

      @restaurant.opening_hours =
      ["Monday: "+params[:monday],
      "Tuesday: "+params[:tuesday],
      "Wednesday: "+params[:wednesday],
      "Thursday: "+params[:thursday],
      "Friday: "+params[:friday],
      "Saturday: "+params[:saturday],
      "Sunday: "+params[:sunday]]

      @restaurant.photo_url = params[:photo_url]

    else

      url_details =
      "https://maps.googleapis.com/maps/api/place/details/json?placeid="+@restaurant.placeid+"&key= AIzaSyAuo4_mSeoT40F-4QAP8uyTvCdw8c7cbvU"

      parsed_data = JSON.parse(open(url_details).read)

      @restaurant.name = parsed_data["result"]["name"]
      @restaurant.latitude = parsed_data["result"]["geometry"]["location"]["lat"]
      @restaurant.longitude = parsed_data["result"]["geometry"]["location"]["lng"]
      @restaurant.price_level = parsed_data["result"]["price_level"]
      @restaurant.rating = parsed_data["result"]["rating"]
      if parsed_data["result"]["photos"] == nil
      else
        @restaurant.photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&maxheight=600&photoreference="+parsed_data["result"]["photos"][0]["photo_reference"]+"&key=AIzaSyAuo4_mSeoT40F-4QAP8uyTvCdw8c7cbvU"
      end

      if parsed_data["result"]["formatted_address"] == nil
      else
        @restaurant.address = parsed_data["result"]["formatted_address"]
      end

      if parsed_data["result"]["formatted_phone_number"] == nil
      else
        @restaurant.phone_number = parsed_data["result"]["formatted_phone_number"]
      end
      #      for num in 0..12 do
      #        if parsed_data["result"]["address_components"][num]["types"] == "postal_code"
      #          @restaurant.zipcode = parsed_data["result"]["address_components"][num]["long_name"]
      #          break
      #        else
      #        end
      #      end
      #      @restaurant.zipcode = parsed_data["result"]["address_components"][7]["long_name"]
      if parsed_data["result"]["opening_hours"] == nil
      else
        @restaurant.opening_hours = parsed_data["result"]["opening_hours"]["weekday_text"]
      end

      if parsed_data["result"]["website"] == nil
      else
        @restaurant.url = parsed_data["result"]["website"]
      end

    end

    save_status = @restaurant.save

    if save_status == true
      #      redirect_to("/restaurants/#{@restaurant.id}", :notice => "Restaurant updated successfully.")
      redirect_to(:back, :notice => "Restaurant updated")

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
