require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_artists_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do 
    reset_albums_table
    reset_artists_table
  end
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GETS /albums" do
    it 'returns 200 OK and all albums' do 
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/1">Doolittle</a>')
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a>')      
    end
  end

  context "GET /albums/new" do 
    it "returns a new album form" do 
      response = get('/albums/new')
      expect(response.status).to eq(200)
      expect(response.body).to include('<form action="/albums" method="POST">')
      expect(response.body).to include('<input type="text" name="title">')
      expect(response.body).to include('<input type="text" name="release_year">')
      expect(response.body).to include('<input type="text" name="artist_id">')
    end 
  end 

  context "GET /albums/:id" do 
    it "return the first album" do 
      response = get('/albums/1')
      expect(response.body).to include("Doolittle")
      expect(response.body).to include("Pixies")
      expect(response.body).to include("1989")
      expect(response.status).to eq(200)
    end
  end 

  context "POST /albums" do
    it 'returns 200 OK when creating a new album' do
      response = post(
        '/albums', 
        title: 'Voyage', 
        release_year: '2022', 
        artist_id: '2'
      )
      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      result = get('/albums')
      expect(result.body).to include("Voyage")
    end
  end 
  

# ARTISTS


  context "GET /artists" do 
    it "returns response 200 ok and a list of artists" do 
      response = get('/artists')
      expect(response.body).to include ('<a href="/artist/1">Pixies</a>')
      expect(response.body).to include ('<a href="/artist/2">ABBA</a>')

      expect(response.status).to eq(200)
    end
  end

  context "GET /artists/new" do 
    it "returns a form to add a new artist" do 
      response = get('/artists/new')
      expect(response.status).to eq(200)
      expect(response.body).to include('<form action="/artists" method="POST">')
      expect(response.body).to include('<input type="text" name="name">')
      expect(response.body).to include('<input type="text" name="genre">')
    end 
  end

  context "GET /artists/:id" do 
    it "returns response 200 ok and a single artist" do 
      response = get('/artists/1')
      expect(response.status).to eq(200)
      expect(response.body).to include("Pixies")
      expect(response.body).to include("Rock")
    end 
  end 

  context "POST /artists" do 
    it "returns 200 ok and creates a new artist" do
      response = post(
        '/artists', 
        name: "Wild nothing", 
        genre: "Indie"
      )
      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      result = get('/artists')
      expect(result.body).to include("Wild nothing")
    end 
  end 

end
