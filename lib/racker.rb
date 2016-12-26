require_relative 'models/game'
require 'erb'

class Racker
  attr_reader :game, :name

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @game = game
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def response
    case @request.path
      when '/start'       then start
      when '/get_hint'    then get_hint
      when '/input'       then check_input
      else Rack::Response.new('Not Found', 404)
    end
  end

  def start
    user_name = @request['user_name'] || @request.session[:name]
    @request.session.clear
    @game = Codebreaker::Game.new
    @request.session[:name] = user_name
    redirect_to_game
  end

  def save_data
    game.save(name)
  end

  def end_game
    Rack::Response.new(render('index.html.erb'))
  end

  def redirect_to_game
    return Rack::Response.new(render('game.html.erb')) unless game.attempts == 0
    @request.session[:answer] = 'lose'
    redirect_to_end
  end

  def redirect_to_end
    save_data
    Rack::Response.new(render('end.html.erb'))
  end

  def get_hint
    @request.session[:hint] = @game.get_hint
    redirect_to_game
  end

  def name
    @request.session[:name]
  end

  def hint
    @request.session[:hint]
  end

  def game
    @request.session[:game] ||= Codebreaker::Game.new
  end

  def answer
    @request.session[:answer]
  end

  def check_input
    input = @request['input']
    @request.session[:answer] = game.get_answer(input)
    return redirect_to_end if answer == 'won'
    redirect_to_game
  end

  def statistics
    @request.session[:statistics] = game.get_statistics.split
  end
end