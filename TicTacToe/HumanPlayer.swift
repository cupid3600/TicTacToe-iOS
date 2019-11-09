//
//  HumanPlayer.swift
//  TicTacToe
//

import Foundation

class HumanPlayer: Player {
    private(set) var symbol: GamePiece
    
    private var currentBoard: GameBoard?
    private var turnCompletionHandler: TurnCompletionHandler?
    
    init(symbol: GamePiece) {
        self.symbol = symbol
    }
    
    func takeTurn(onBoard board: GameBoard, completion: @escaping TurnCompletionHandler) {
        currentBoard = board
        turnCompletionHandler = completion
    }
    
    func handleGameBoardTapped(atLocation boardLocation: Int) {
        guard let board = currentBoard, let completion = turnCompletionHandler else { return }
        guard let gamePiece = board.gamePiece(atLocation: boardLocation), gamePiece == .blank else { return }
        do {
            completion(try board.newByPlaying(symbol, atLocation: boardLocation))
            currentBoard = nil
            turnCompletionHandler = nil
        }
        catch {
            // If the user tapped on an already-occupied space, then ignore it
        }
    }
}
