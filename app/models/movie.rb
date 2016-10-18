class Movie < ActiveRecord::Base
  
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
   class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    begin
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")  
      results =  Tmdb::Movie.find(string)
     
      hash = {}
      arrOfHash = Array.new
      results.each_index{|i| 
        results[i].instance_variables.each {|var| hash[var.to_s.delete("@")] = results[i].instance_variable_get(var) }
        arrOfHash.push hash
        movieID =arrOfHash[i]["id"]
        countries =Tmdb::Movie.releases(movieID)["countries"]
        countries.each{|country|
          if country["iso_3166_1"] == "US" 
            arrOfHash[i]["rating"] = country["certification"]
            break
          end
        }
        hash = {}
      }
      return arrOfHash
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  def self.create_from_tmdb(input)
    details = Tmdb::Movie.detail(input)
    movieRating =""
    countries =Tmdb::Movie.releases(input)["countries"]
    countries.each{|country|
        if country["iso_3166_1"] == "US" 
          movieRating= country["certification"]
        end
    }  
  
    puts "rating"+movieRating
    create(title: details["title"], rating: movieRating, release_date: details["release_date"], description: details["overview"])
  end
  
end
