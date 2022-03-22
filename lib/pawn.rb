require 'colorize'
require_relative 'game_board.rb'

class Pawn
  attr_accessor :piece, :position, :team

  def initialize(y, x, team)
    @team = team
    @base = [y,x]
    @position = [y, x]
    if team == 'white'
      @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u2659 ".colorize( :background => :light_black)  : " \u2659 ".colorize( :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u2659 ".colorize( :background => :light_magenta)  : " \u2659 ".colorize( :background => :light_black))
    else
      @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u265F ".colorize( :color => :black, :background => :light_black)  : " \u265F ".colorize( :color => :black, :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u265F ".colorize( :color => :black, :background => :light_magenta)  : " \u265F ".colorize( :color => :black, :background => :light_black))
    end
  end

  def move_set(move)
    white_move_one = [(@position[0] - 1), @position[1]]
    white_move_two = [(@position[0] - 2), @position[1]]
    black_move_one = [(@position[0] + 1), @position[1]]
    black_move_two = [(@position[0] + 2), @position[1]]
    if @team == 'white'
      if @position == @base
        if move == white_move_one || move == white_move_two
          true
        else
          false
        end
      else
        if move == white_move_one
          true
        else
          false
        end
      end
    elsif @team == 'black'
      if @position == @base
        if move == black_move_one || move == black_move_two
          true
        else
          false
        end
      else
        if move == black_move_one
          true
        else
          false
        end
      end
    end
  end

  def attack_set(move)
    white_move_one = [(@position[0] - 1), (@position[1] - 1)]
    white_move_two = [(@position[0] - 1), (@position[1] + 1)]
    black_move_one = [(@position[0] + 1), (@position[1] - 1)]
    black_move_two = [(@position[0] + 1), (@position[1] + 1)]
    if @team == 'white'
      if move == white_move_one || move == white_move_two
        true
      else
        false
      end
    elsif @team == 'black'
      if move == black_move_one || move == black_move_two
        true
      else
        false
      end
    end
  end

  def update_position(move)
    @position = move
  end

  def update_piece
    if team == 'white'
      @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u2659 ".colorize( :background => :light_black)  : " \u2659 ".colorize( :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u2659 ".colorize( :background => :light_magenta)  : " \u2659 ".colorize( :background => :light_black))
    else
      @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u265F ".colorize( :color => :black, :background => :light_black)  : " \u265F ".colorize( :color => :black, :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u265F ".colorize( :color => :black, :background => :light_magenta)  : " \u265F ".colorize( :color => :black, :background => :light_black))
    end
  end
end

# comment