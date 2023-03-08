# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do 
    arr_album = []
    repo = AlbumRepository.new 
    albums = repo.all

    albums.each do |album|
      arr_album << album.title
    end 
    return arr_album.join(", ")
  end 

  post '/albums' do 
    repo = AlbumRepository.new 

    album = Album.new

    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]

    repo.create(album)
  end

  get '/artists' do 
    arr_artists = []
    repo = ArtistRepository.new 
    artists = repo.all 

    artists.each do |artist|
      arr_artists << artist.name 
    end
    return arr_artists.join(", ")
  end 

  post '/artists' do 
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)
  end 
end