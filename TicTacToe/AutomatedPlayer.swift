//
//  AutomatedPlayer.swift
//  TicTacToe
//

import Foundation

class AutomatedPlayer: Player {
    private(set) var symbol: GamePiece
    
    init(symbol: GamePiece) {
        self.symbol = symbol
    }
    
    func takeTurn(onBoard board: GameBoard, completion: @escaping TurnCompletionHandler) {
        // TODO: Code a strategy for the automated player (it doesn't have to be very sophisticated).
        // This placeholder code just plays in the first open spot
        // --------------------------------------------------------------------------
        for i in 0..<9 {
            guard let gamePiece = board.gamePiece(atLocation: i), gamePiece == .blank else { continue }
            do {
                completion(try board.newByPlaying(symbol, atLocation: i))
                break
            } catch {}
        }
        // --------------------------------------------------------------------------
    }
}
