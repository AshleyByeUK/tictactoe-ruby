require 'game/hard_player.rb'
require 'game/game'
require 'game/board'
require 'game/game_rules'

module Game
  describe HardPlayer do
    50.times do
      before(:each) do
        @p1_token = 'X'
        @p2_token = 'O'
        @player_one = HardPlayer.new(@p1_token)
        @player_two = HardPlayer.new(@p2_token)
        @players = [@player_one, @player_two]
        @rules = GameRules.new
      end

      it "chooses the tie position when only one position remains" do
        board = Board.new(['X', 'X', 'O', 'O', 'O', 6, 'X', 'O', 'X'])
        game = Game.new(@players, board: board)
        expect(game.make_move(1).result).to eq :tie
      end

      it "chooses the win position when only one position remains" do
        board = Board.new(['X', 'X', 'O', 'X', 'X', 'O', 'O', 'O', 9])
        game = Game.new(@players, board: board)
        expect(game.make_move(1).result).to eq :win
      end

      it "blocks the opponent from winning" do
        board = Board.new([1, 'X', 'O', 'X', 'O', 6, 7, 8, 9])
        game = Game.new(@players, board: board)
        expect(game.make_move(1).result).to eq :playing
      end

      it "plays for a winning move" do
        board = Board.new(['X', 2, 'X', 'O', 'O', 6, 7, 'X', 'O'])
        game = Game.new(@players, board: board)
        expect(game.make_move(1).result).to eq :win
      end

      it "plays for a forking move" do
        board = Board.new([1, 'X', 3, 4, 5, 'O', 7, 'O', 'X'])
        game = Game.new(@players, board: board, current_player: 1)
        game = game.make_move(1)
        expect(game.result).to eq :playing
        expect(game.available_positions.include?(1)).to be false
      end
    end
  end
end