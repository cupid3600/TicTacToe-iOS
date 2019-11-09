//
//  Player.swift
//  TicTacToe
//

import Foundation

protocol Player {
    var symbol: GamePiece { get }
    func takeTurn(onBoard board: GameBoard, completion: @escaping TurnCompletionHandler)
}

extension Equatable where Self: Player {}

func ==(lhs: Player, rhs: Player) -> Bool {
    // Players are considered equal if they have the same symbol
    return lhs.symbol == rhs.symbol
}
