//
//  AutomatedPlayer.swift
//  TicTacToe
//

import Foundation

class AutomatedPlayer: Player {
    private(set) var symbol: GamePiece
    var aiPlayer: GamePiece
    var huPlayer: GamePiece
    
    init(symbol: GamePiece) {
        self.symbol = symbol
        
        // ai
        self.aiPlayer = self.symbol
        //human
        self.huPlayer = self.symbol == .O ? GamePiece.X : GamePiece.O
    }
    
    func takeTurn(onBoard board: GameBoard, completion: @escaping TurnCompletionHandler) {
        // TODO: Code a strategy for the automated player (it doesn't have to be very sophisticated).
        // This placeholder code just plays in the first open spot
        // --------------------------------------------------------------------------
        
        // Determine if computer is first oder to play and all spots are blank.
        var first = true
        for i in 0..<9 {
            if board.gamePiece(atLocation: i) != GamePiece.blank {
                first = false
                break
            }
        }
        if first {
            do {
                completion(try board.newByPlaying(symbol, atLocation: 0))
            } catch {}
        } else {
            // In case of all spots are not blank
            let origBoard = board
            let bestSpot = self.minimax(newBoard: origBoard, player: self.aiPlayer)
            let index = bestSpot.value(forKey: "index") as! Int
            if let gamePiece = board.gamePiece(atLocation: index), gamePiece == .blank {
                do {
                    completion(try board.newByPlaying(symbol, atLocation: index))
                } catch {}
            }
        }
        /*
        for i in 0..<9 {
            guard let gamePiece = board.gamePiece(atLocation: i), gamePiece == .blank else { continue }
            do {
                completion(try board.newByPlaying(symbol, atLocation: i))
                break
            } catch {}
        }*/
        // --------------------------------------------------------------------------
    }
    func minimax(newBoard: GameBoard, player: GamePiece) -> NSMutableDictionary {
        //available spots
        let availSpots = self.emptyIndexies(newBoard: newBoard)
        
        let n: NSMutableDictionary = NSMutableDictionary()
        if self.winning(newBoard: newBoard, player: self.huPlayer) {
            n.setValue(-10, forKey: "score")
            return n
        } else if (self.winning(newBoard: newBoard, player: self.aiPlayer)) {
            n.setValue(10, forKey: "score")
            return n
        } else if (availSpots.count == 0) {
            n.setValue(0, forKey: "score")
            return n
        }
        var moves = [NSMutableDictionary]()
        for i in 0..<availSpots.count {
            let move: NSMutableDictionary = NSMutableDictionary()
            move.setValue(availSpots[i], forKey: "index")
            var board = newBoard
            board[availSpots[i]] = player
            if(player == self.aiPlayer) {
                let result = self.minimax(newBoard: board, player: self.huPlayer)
                move.setValue(result["score"], forKey: "score")
            } else {
                let result = self.minimax(newBoard: board, player: self.aiPlayer)
                move.setValue(result["score"], forKey: "score")
            }
            
            //reset the spot to empty
            board[availSpots[i]] = GamePiece.blank
            
            //push the object to the array
            moves.append(move)
        }
        // if it is the computer's turn loop over the moves and choose the move with the highest score
        var bestMove: Int?
        if (player == self.aiPlayer) {
            var bestScore = -10000
            for j in 0..<moves.count {
                let move = moves[j]
                if move["score"] as! Int > bestScore {
                    bestScore = move["score"] as! Int
                    bestMove = j
                }
            }
        } else {
            var bestScore = 10000
            for j in 0..<moves.count {
                let move = moves[j]
                if  (move["score"] as! Int) < bestScore {
                    bestScore = move["score"] as! Int
                    bestMove = j
                }
            }
        }
        
        //return the chosen move (object) from the array to the higher depth
        return moves[bestMove!]
    }
    func winning(newBoard: GameBoard, player: GamePiece) -> Bool {
        if(
            (newBoard[0] == player && newBoard[1] == player && newBoard[2] == player) ||
            (newBoard[3] == player && newBoard[4] == player && newBoard[5] == player) ||
            (newBoard[6] == player && newBoard[7] == player && newBoard[8] == player) ||
            (newBoard[0] == player && newBoard[3] == player && newBoard[6] == player) ||
            (newBoard[1] == player && newBoard[4] == player && newBoard[7] == player) ||
            (newBoard[2] == player && newBoard[5] == player && newBoard[8] == player) ||
            (newBoard[0] == player && newBoard[4] == player && newBoard[8] == player) ||
            (newBoard[2] == player && newBoard[4] == player && newBoard[6] == player)
            ) {
            return true
        } else {
            return false
        }
    }
    func emptyIndexies(newBoard: GameBoard) -> [Int] {
        var indexies = [Int]()
        for index in 0..<9 {
            if newBoard[index] == GamePiece.blank {
                indexies.append(index)
            }
        }
        return indexies
    }
}
