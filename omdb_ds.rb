require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  
  erb :omdb_index

end

post '/results' do
  search_str = params[:movie]

  response = Typhoeus.get("www.omdbapi.com", :params => {:s => search_str})
  result = JSON.parse(response.body)

  if result["Search"] == nil
    erb :omdb_index
  else  
    @movie_array = result["Search"].sort_by { |movie| movie["Year"] }.reverse
    erb :omdb_results
  end    

end

get '/movie-info/:imdbID' do |imdb_id|
  # raise params.inspect to show parameters
  # Make another api call here to get the url of the poster.
  response = Typhoeus.get("www.omdbapi.com", :params => {:i => imdb_id})
  @movie_result = JSON.parse(response.body)

  erb :omdb_movieinfo

end

