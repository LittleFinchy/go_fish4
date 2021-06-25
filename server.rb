require "pusher"
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

  def pusher
    @pusher ||= Pusher::Client.new(
      app_id: "1224238",
      key: "6440facb664c305448af",
      secret: "e18ac9f53cae9f092b9d",
      cluster: "us2",
      use_tls: true,
    )
  end

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
    if self.class.game.num_of_players == 0
      slim :index
    else
      redirect "/enter_name"
    end
  end

  post "/enter_name" do
    self.class.game.players_needed_to_start(params["num_of_players"].to_i)
    pusher.trigger("go-fish", "game-changed", {})
    redirect "/enter_name"
  end

  get "/enter_name" do
    slim :enter_name
  end

  post "/join" do
    player = Player.new(params["name"])
    session[:current_player] = player
    self.class.game.add_player(player)
    pusher.trigger("go-fish", "game-changed", {})
    redirect "/lobby"
  end

  get "/lobby" do
    redirect "/" if self.class.game.players.empty?
    slim :lobby, locals: { game: self.class.game, current_player: session[:current_player] }
  end

  get "/await_turn" do
    # pusher.trigger("go-fish", "game-started", {})
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

  post "/take_turn" do
    rank_picked = params["playingcard"]
    player_id_picked = params["player_id"].to_i
    player_picked = self.class.game.find_player_by_id(player_id_picked)
    result = self.class.game.play_turn(player_picked, rank_picked)
    pusher.trigger("go-fish", "game-changed", {})
    slim :your_results, locals: { result: result, game: self.class.game, current_player: session[:current_player] }
  end
end

# change num_of_cards_taken to result and only pass that result into the view
