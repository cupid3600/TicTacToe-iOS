//
//  TicTacToeTests.swift
//  TicTacToeTests
//

import XCTest
@testable import TicTacToe

class GameBoardTests: XCTestCase {
    
    let board1: GameBoard = [
        .X, .blank, .O,
        .O, .blank, .blank,
        .X, .blank, .blank
    ]
    
    func testAddGamePieceToGameBoard() {
        let board2: GameBoard = [
            .X, .blank, .O,
            .O, .blank, .blank,
            .X, .blank, .X
        ]
        do {
            let board3 = try board1.newByPlaying(.X, atLocation: 8)
            XCTAssertEqual(board3, board2)
        }
        catch {
            XCTFail()
        }
    }
    
    func testAddGamePieceToInvalidBoardLocation() {
        // Verify that GameBoard.newByPlaying throws GameBoardError.invalidBoardLocation
    }

    func testAddGamePieceToOccupiedBoardLocation() {
        // Verify that GameBoard.newByPlaying throws GameBoardError.boardLocationAlreadyOccupied
    }

    func testGamePieceAtLocation() {
        // Verify that GameBoard.gamePiece(atLocation:) returns the correct value(s)
    }
    
}
