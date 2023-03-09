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
    repo = AlbumRepository.new 
    @albums = repo.all
    return erb(:albums)
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
    repo = ArtistRepository.new 
    @artists = repo.all 
    return erb(:artists)
  end 

  get '/artists/:id' do 
    artist_repo = ArtistRepository.new 
    @artist = artist_repo.find(params[:id])
    return erb(:artist)
  end 

  post '/artists' do 
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)
  end 

  get '/albums/:id' do 

    album_repo = AlbumRepository.new
    artist_repo = ArtistRepository.new
    @album = album_repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)

    return erb(:album)
  end 

end