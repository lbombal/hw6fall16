require 'spec_helper'
require 'rails_helper'

describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        searchResults = [double('movie1'),double('movie2')]
        
        expect( Tmdb::Movie).to receive(:find).with('Inception').
        and_return(searchResults)
        Movie.find_in_tmdb('Inception')
      end
      
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  describe 'adding Tmdb movie to database' do
    it 'should add the movie to the database' do
      
      expect {Movie.create_from_tmdb("72105")}.to change{Movie.count}
    end
  end
end