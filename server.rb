require "sinatra"
require "sinatra/reloader"
require "sprockets"
require "./lib/player"
require "./lib/game"

class Server < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  enable :sessions

  # initialize new sprockets environment
  set :environment, Sprockets::Environment.new

  # append assets paths
  environment.append_path "assets/stylesheets"
  environment.append_path "assets/javascripts"

  # compress assets
  environment.css_compressor = :scss

  # get assets
  get "/assets/*" do
    env["PATH_INFO"].sub!("/assets", "")
    settings.environment.call(env)
  end

  def self.game
    @@game ||= Game.new
  end

  get "/" do
    slim :index
  end

  # get "/:slug" do
  #   slim params[:slug].to_sym
  # end

  post "/join" do
    player = Player.new(params["name"])
    session[:current_player] = player
    self.class.game.add_player(player)
    redirect "/game"
  end

  get "/game" do
    redirect "/" if self.class.game.players.empty?
    slim :game, locals: { game: self.class.game, current_player: session[:current_player] }
  end
end
