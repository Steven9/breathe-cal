class CitiesController < ApplicationController
    
    skip_before_action :verify_authenticity_token

    
    def index
    end
    
    def new
    end
  
    # so i need to mimic the create route with a number of param types. 
    # or do i
    
    # ajax POST -> city create route, with certain parameters. 
    # tell create to respond to some formats... 
    
    def city_data
      if params[:geo]
        latlng = params[:geo]
        loc_key = City.get_loc_key(latlng["lat"], latlng["lng"])
        city = City.find_by(location_key: loc_key)
      end
      city.update_city_data
      puts "FLAGGSODFJSDOPIFJSDF"
      puts city.daily_data
      puts "***************************"
      render :json => city.daily_data.to_json
    end
    
    
    
    
    
    def create
      if params[:city]
        City.get_location_key(params[:city]["zip"],params[:city]["name"],params[:city]["state"],params[:city]["country"])
        city = City.find_by(params[:location_info])
      elsif params[:geo]
        latlng = params[:geo]
        loc_key = City.get_loc_key(latlng["lat"], latlng["lng"])
        city = City.find_by(location_key: loc_key)
      end
      city.update_city_data
      respond_to do |format|
        format.html {redirect_to city_path id: city.id}
        format.json {render :json => city.daily_data.to_json}
      end
    end
  
  
    def show
      @city = City.find(params[:id])
      @city.update_city_data
      @city.reload
      daily_data = @city.daily_data
      forecasts = daily_data["DailyForecasts"] 
    # daily_data is a hash with key: dailyForecasts value: array of 5 day forecast
    # we want to get "AirAndPollen" key 
    # value of AirAndPollen -> array of hashes with Name, Value, Category, CategoryValue, 
    # the first hash in AirAndPollen also has a type.
      
      # @day_1["Name"] = forecasts[0]["AirAndPollen"]["Name"]
      # @day_1["Value"] = forecasts[0]["AirAndPollen"]["Name"]
      # @day_1["Category"] = forecasts[0]["AirAndPollen"]["Name"]
      # @day_1[""] = forecasts[0]["AirAndPollen"]["Name"]
      # @day_1["Name"] = forecasts[0]["AirAndPollen"]["Name"]
      d1 = forecasts[0]["AirAndPollen"]
      d2 = forecasts[1]["AirAndPollen"]
      d3 = forecasts[2]["AirAndPollen"]
      d4 = forecasts[3]["AirAndPollen"]
      d5 = forecasts[4]["AirAndPollen"]
      @forecasts = [d1,d2,d3,d4,d5]
    end
  
end
