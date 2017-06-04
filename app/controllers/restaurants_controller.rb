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
    @restaurant = Restaurant.new

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
      redirect_to("/restaurants/#{@restaurant.id}", :notice => "Restaurant created successfully.")
    else
      render("restaurants/new.html.erb")
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
