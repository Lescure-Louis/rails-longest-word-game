require 'json'
require'open-uri'

class GamesController < ApplicationController

  def new
    @letters = (0...15).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    session[:score] = 0 if session[:score].nil?
    @word = params[:word].upcase
    user = open("https://wagon-dictionary.herokuapp.com/#{params[:word]}").read
    result_api = JSON.parse(user)
    @exists = result_api["found"]
    @letters = JSON.parse params[:collected_input]
    @correct = true
    letters = @letters
    params[:word].upcase.split('').each { |letter| letters.include?(letter) ? letters.slice(letters.index(letter)) : @correct = false }
    @exists == true && @correct == true ? @score = @word.length : @score = 0
    session[:score] += @score
    @total_score = session[:score]
   end


  def reset
    reset_session
    redirect_to new_url
    session[:score] = 0
  end

end
