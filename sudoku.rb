require_relative 'board'

class Game
  def initialize
    @board = Board.new
  end

  def play
    until @board.solved?
      @board.render
      get_input
    end
  end

  def get_input
    puts "enter coordinates"
    pos = gets.chomp.split(",").map(&:to_i)

    puts "enter number"
    value = gets.chomp.to_i
    until (0..9).to_a.include?(value)
      puts "enter a number 0 - 9"
      value = gets.chomp.to_i
    end

    @board.set_value(pos, value)
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
