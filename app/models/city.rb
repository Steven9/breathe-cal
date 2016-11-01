class City < ActiveRecord::Base
  serialize :daily_data, JSON

  
  def update_city_data
    location_key = self.location_key
    if self.updated_at <= Date.today.to_time.beginning_of_day or !self.daily_data
      url = "http://dataservice.accuweather.com/forecasts/v1/daily/5day/#{location_key}"
      response = HTTParty.get(url, query: {apikey: "5NMWDxuXmQpNLf7AQ2gj0Y8uBkLXT8q3", language:"en-us", details: "true"})
      self.update_attribute("daily_data" , response) 
    end
    # daily  
    # daily_data is a hash with key: dailyForecasts value: array of 5 day forecast
    # we want to get "AirAndPollen" key 
    # value of AirAndPollen -> array of hashes with Name, Value, Category, CategoryValue, 
    # the first hash in AirAndPollen also has a type. 
  end
  
  
  #save by lat long? place id? something else?
  
  # probably need a better pattern for this anyway.. 
  def self.get_loc_key(lat,lng)
    city = City.find_by(lat: lat, lng: lng)
    if city
      return city.location_key
    end
    url = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search"
    response = HTTParty.get(url, query: {apikey: "5NMWDxuXmQpNLf7AQ2gj0Y8uBkLXT8q3" ,q: "#{lat},#{lng}",language:"en-us" } )
    location_key = response["Key"]
    City.create(lat: lat, lng: lng, location_key: location_key)
    return location_key
  end
  
  def self.get_location_key(zip, name, state, country)
    city = City.find_by(name: name, state: state,country: country)
    if city
      return city.location_key
    end
    if zip 
      if state and country
        url = "http://dataservice.accuweather.com/locations/v1/#{country}/#{state}/search"
        response = HTTParty.get(url, query: {apikey: "5NMWDxuXmQpNLf7AQ2gj0Y8uBkLXT8q3" ,q: "#{zip}",language:"en-us" } )
        location_key = response[0]["Key"]
        City.create(name: name, zip: zip, state: state, country: country, location_key: location_key )
        return location_key
      end
    end
  end
  
  
  
  
  
end
