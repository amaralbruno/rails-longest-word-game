class WordsController < ApplicationController

  before_action :grid

  def score
    @try = params[:guess]

    @grid
    @start_time = params[:starttime]
    @end_time = params[:endtime]

    @final = run_game(@try, @grid, @start_time.to_i, Time.now.to_i)

  end

  def game
    @time = Time.now
  end

  private

  def grid
    g = generate_grid(20)
    @grid = g.to_sentence(last_word_connector: ', ')
  end

  def generate_grid(grid_size)
  # TODO: generate random grid of letters
  range = [*'A'..'Z']
  Array.new(grid_size) { range.sample }
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    hash = {}
    url = "http://api.wordreference.com/0.8/80143/json/enfr/"
    link = url + attempt
    raw_json = JSON.parse(open(link).read)

    a = grid

    b = attempt.upcase.split("")

    if raw_json.key?("Error")
      hash[:translation] = nil
      hash[:score] = 0
      hash[:message] = "not an english word"
    else
      b.each do |letter|
        if a.include?(letter)
          a.delete_at(a.index(letter))
          hash[:translation] = raw_json["term0"]["PrincipalTranslations"]["0"]["FirstTranslation"]["term"]
          hash[:message] = "well done"
          hash[:score] = (attempt.size * ((end_time - start_time) * 10)) / 100000000
        else
          hash[:message] = "not in the grid"
          hash[:score] = 0
          break
        end
      end
    end
    hash
  end
end
