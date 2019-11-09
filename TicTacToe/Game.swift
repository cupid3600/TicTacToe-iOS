//
//  Game.swift
//  TicTacToe
//

import Foundation

typealias TurnCompletionHandler = (GameBoard) -> Void

class Game {
    private var currentPlayer: Player
    private var player1: Player
    private var player2: Player
    private var board: GameBoard
    
    // Injectable function: called when the game is over (nil indicates a tie)
    var gameOverHandler: (Player?) -> Void = { _ in }
    // Injectable function: called after each play to allow UI updates
    var updatedBoardHandler: (GameBoard) -> Void = { _ in }
    
    init(player1: Player, player2: Player) {
        self.currentPlayer = player1
        self.player1 = player1
        self.player2 = player2
        self.board = GameBoard.newEmpty()
    }
    
    func start() {
        currentPlayer.takeTurn(onBoard: board, completion: handleTurnTaken)
    }
    
    func handleGameBoardTapped(atLocation boardLocation: Int) {
        if let humanPlayer = player1 as? HumanPlayer {
            humanPlayer.handleGameBoardTapped(atLocation: boardLocation)
        }
        else if let humanPlayer = player2 as? HumanPlayer {
            humanPlayer.handleGameBoardTapped(atLocation: boardLocation)
        }
    }
    
    private func handleTurnTaken(_ newBoard: GameBoard) {
        updatedBoardHandler(newBoard)
        
        DispatchQueue.main.async {
            // If the game is over then signal that fact
            if let winningGamePiece = newBoard.gameWinner {
                self.gameOverHandler(self.getPlayer(withSymbol: winningGamePiece))
                return
            }
            
            // Let the next player take their turn
            self.currentPlayer = (self.currentPlayer == self.player1 ? self.player2 : self.player1)
            self.board = newBoard
            self.currentPlayer.takeTurn(onBoard: self.board, completion: self.handleTurnTaken)
        }
    }
    
    private func getPlayer(withSymbol symbol: GamePiece) -> Player? {
        if symbol == .blank { return nil }
        return self.player1.symbol == symbol ? self.player1 : self.player2
    }
}
