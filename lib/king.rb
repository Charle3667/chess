require 'colorize'
require_relative 'game_board.rb'

class King
  attr_accessor :piece, :position, :team

  def initialize(y, x, team)
    @team = team
    @base = [y,x]
    @position = [y, x]
    if team == 'white'
      @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u2654 ".colorize( :background => :light_black)  : " \u2654 ".colorize( :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u2654 ".colorize( :background => :light_magenta)  : " \u2654 ".colorize( :background => :light_black))
    else
      @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u265A ".colorize( :color => :black, :background => :light_black)  : " \u265A ".colorize( :color => :black, :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u265A ".colorize( :color => :black, :background => :light_magenta)  : " \u265A ".colorize( :color => :black, :background => :light_black))
    end
  end

  def move_set(move)
    possible_moves = [[(@position[0] - 1), @position[1]], 
[(@position[0] - 1), (@position[1] +1)], [(@position[0]), (@position[1] +1)], 
[(@position[0] + 1), (@position[1] +1)], [(@position[0] + 1), (@position[1])], 
[(@position[0] + 1), (@position[1] - 1)], [(@position[0]), (@position[1] - 1)], 
[(@position[0] - 1), (@position[1] - 1)]]
    if possible_moves.any?(move)
      true
    else
      false
    end
  end

  def attack_set(move)
    possible_moves = [[(@position[0] - 1), @position[1]], 
[(@position[0] - 1), (@position[1] +1)], [(@position[0]), (@position[1] +1)], 
[(@position[0] + 1), (@position[1] +1)], [(@position[0] + 1), (@position[1])], 
[(@position[0] + 1), (@position[1] - 1)], [(@position[0]), (@position[1] - 1)], 
[(@position[0] - 1), (@position[1] - 1)]]
    if possible_moves.any?(move)
      true
    else
      false
    end
  end

  def update_position(move)
    @position = move
  end

  def update_piece
    if team == 'white'
      @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u2654 ".colorize( :background => :light_black)  : " \u2654 ".colorize( :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u2654 ".colorize( :background => :light_magenta)  : " \u2654 ".colorize( :background => :light_black))
    else
      @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u265A ".colorize( :color => :black, :background => :light_black)  : " \u265A ".colorize( :color => :black, :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u265A ".colorize( :color => :black, :background => :light_magenta)  : " \u265A ".colorize( :color => :black, :background => :light_black))
    end
  end
end