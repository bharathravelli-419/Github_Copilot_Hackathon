require 'sinatra'
require 'securerandom'

# In-memory hash to store URL mappings
urls = {}

# Set the views directory
set :views, File.dirname(__FILE__) + '/views'

get '/' do
  erb :index
end

post '/shorten' do
  long_url = params[:long_url]

  # Generate a unique short URL
  short_url = SecureRandom.urlsafe_base64(8)

  # Store the mapping in the hash
  urls[short_url] = long_url

  erb :shortened, locals: { short_url: "#{request.base_url}/#{short_url}" }
end

get '/:short_url' do
  short_url = params[:short_url]

  if urls.key?(short_url)
    redirect urls[short_url]
  else
    "Invalid short URL"
  end
end

# Run the application
run Sinatra::Application
