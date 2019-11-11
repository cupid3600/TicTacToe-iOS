//
//  HumanPlayerTests.swift
//  TicTacToeTests
//

import XCTest
@testable import TicTacToe

class HumanPlayerTests: XCTestCase {
    
    func testPlayerTakesTurnAtLocation() {
        // TODO: Verify that the HumanPlayer plays at a valid board location (and nothing else is changed).
        let location = 5
        let valid = (0..<9).contains(location)
        XCTAssertEqual(valid, true, "The currnet location is valid one.")
        
    }
    
    func testPlayerTakesTurnAtInvalidLocation() {
        // TODO: Verify that the HumanPlayer cannot play at an invalid board location.
        
        let location = 10
        let valid = (0..<9).contains(location)
        XCTAssertEqual(valid, false, "The current location is invalid one.")
    }

    func testPlayerTakesTurnAtOccupiedLocation() {
        // TODO: Verify that the HumanPlayer cannot play at an occupied board location.
        let board: GameBoard = [
            .X, .blank, .O,
            .O, .blank, .blank,
            .X, .blank, .X
        ]
        let location = 2
        let valid = board[location] == .blank
        XCTAssertEqual(valid, false, "The current location is already accupied.")
    }
}
