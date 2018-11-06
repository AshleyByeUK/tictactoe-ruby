module Game
  class GameRules
    def game_over?(board)
      win?(board) || tie?(board)
    end

    def game_result(board)
      game_over?(board) ? game_over_reason(board) : :playing
    end

    private

    def win?(board)
      win = false
      p = board.possible_winning_positions
      p.each do |combination|
        win = winning_combination?(combination) if win == false
      end
      win
    end

    def winning_combination?(combination)
      combination.uniq.length == 1
    end

    def tie?(board)
      board.available_positions.empty?
    end

    def game_over_reason(board)
      win?(board) ? :win : :tie
    end
  end
end
