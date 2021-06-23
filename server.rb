# require "pusher"
require "pry"
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
    @@game ||= Game.new()
  end

  def self.reset_game
    @@game = nil
  end

  get "/" do
    slim :index
  end

  post "/join" do
    player = Player.new(params["name"])
    session[:current_player] = player
    self.class.game.add_player(player)
    redirect "/lobby"
  end

  get "/lobby" do
    redirect "/" if self.class.game.players.empty?
    slim :lobby, locals: { game: self.class.game, current_player: session[:current_player] }
  end

  get "/await_turn" do
    if self.class.game.ready?
      slim :await_turn, locals: { game: self.class.game, current_player: session[:current_player] }
    else
      redirect "/lobby"
    end
  end

  get "/take_turn" do
    is_your_turn = session[:current_player].id == self.class.game.turn_player.id
    if is_your_turn
      slim :take_turn, locals: { game: self.class.game, current_player: session[:current_player] }
    else
      redirect "/await_turn"
    end
  end

  get "/your_results" do
    # card_picked = params["playingcard"]
    # player_picked = params["player"]
    self.class.game.next_turn
    slim :your_results
  end
end
