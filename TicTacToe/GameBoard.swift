//
//  GameBoard.swift
//  TicTacToe
//

/// A Gameboard is really just an array of GamePieces.  It can be treated as an opaque type,
/// using the public methods in the following Array extension.  The game board locations are
/// as follows:
///
///  0 | 1 | 2
///  ---------
///  3 | 4 | 5
///  ---------
///  6 | 7 | 8

import Foundation

enum GamePiece: String {
    case blank
    case X
    case O
}

typealias GameBoard = [GamePiece]

extension Array where Iterator.Element == GamePiece {
    var isGameOver: Bool {
        return gameWinner != nil
    }
    
    // Evaluate the board and return a GamePiece that represents the winner.
    // Returning .blank represents a tie.  Returning nil means the game is not over.
    var gameWinner: GamePiece? {
        // TODO: Code this computed property to behave as described above.
        // This placeholder code just waits until the board is full, then signals a tie
        // --------------------------------------------------------------------------
        if !self.contains(.blank) {
            return .blank
        }
        return nil
        // --------------------------------------------------------------------------
    }
    
    static func newEmpty() -> GameBoard {
        var board: GameBoard = []
        for _ in 0..<9 {
            board.append(.blank)
        }
        return board
    }
    
    func newByPlaying(_ symbol: GamePiece, atLocation boardLocation: Int) throws -> GameBoard {
        guard (0..<9).contains(boardLocation) else { throw GameBoardError.invalidBoardLocation }
        guard self[boardLocation] == .blank else { throw GameBoardError.boardLocationAlreadyOccupied }
        var newBoard: GameBoard = self
        newBoard[boardLocation] = symbol
        return newBoard
    }
    
    // Returns the game piece at the specified board location.  Valid board locations are 0...8.
    func gamePiece(atLocation boardLocation: Int) -> GamePiece? {
        guard boardLocation < self.count else { return nil }
        return self[boardLocation]
    }
}

enum GameBoardError: Error {
    case invalidBoardLocation
    case boardLocationAlreadyOccupied
}
