require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end 
  end
  describe 'adding to Rotten Potatoes' do
    it 'should call create_from_tmdb for each checked box' do
      expect(Movie).to receive(:create_from_tmdb).with('72105')
      expect(Movie).to receive(:create_from_tmdb).with('214756')
      post :add_tmdb, {:tmdb_movies =>{"72105"=>"1", "214756"=>"1"}}
    end
    it 'redirect to the movie_path' do
      allow(Movie).to receive(:create_from_tmdb)
      post :add_tmdb, {:tmdb_movies =>{"72105"=>"1", "214756"=>"1"}}
      expect(response).to redirect_to('/movies')
    end
  end
end
