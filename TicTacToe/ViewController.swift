//
//  ViewController.swift
//  TicTacToe
//

import UIKit

class ViewController: UIViewController {
    private var boardPositions: [UIButton] = []
    private let humanIsPlayer1Button = UIButton()
    private let humanIsPlayer1Label = UILabel()
    private let humanIsPlayer2Button = UIButton()
    private let humanIsPlayer2Label = UILabel()
    private let startEndButton = UIButton()
    
    private let radioButtonSize: CGFloat = 32
    
    private var isHumanPlayer1 = true
    private var game: Game?
    
    // MARK: - Lifecycle / Setup Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        
        setupBoard()
        view.addSubviewWithAutoLayout(humanIsPlayer1Button)
        view.addSubviewWithAutoLayout(humanIsPlayer1Label)
        view.addSubviewWithAutoLayout(humanIsPlayer2Button)
        view.addSubviewWithAutoLayout(humanIsPlayer2Label)
        view.addSubviewWithAutoLayout(startEndButton)
        
        humanIsPlayer1Label.text = humanIsPlayer1Text
        humanIsPlayer2Label.text = humanIsPlayer2Text
        
        setupPlayerSelectorButton(humanIsPlayer1Button, handler: #selector(handleHumanIsPlayer1))
        setupPlayerSelectorButton(humanIsPlayer2Button, handler: #selector(handleHumanIsPlayer2))
        updatePlayerOrderButtons()
        
        startEndButton.setTitleColor(UIColor.black, for: .normal)
        startEndButton.addTarget(self, action: #selector(handleStartEndGame), for: .touchUpInside)
        startEndButton.layer.cornerRadius = 4
        updateStartEndButton()

        layout()
    }
    
    private func setupBoard() {
        for i in 0..<9 {
            let boardPosition = UIButton()
            boardPosition.setTitleColor(UIColor.black, for: .normal)
            boardPosition.titleLabel?.font = UIFont.systemFont(ofSize: 56)
            boardPosition.backgroundColor = UIColor.white
            view.addSubviewWithAutoLayout(boardPosition)
            boardPosition.tag = i
            boardPosition.addTarget(self, action: #selector(handleTapped(boardPosition:)), for: .touchUpInside)
            boardPositions.append(boardPosition)
        }
    }
    
    private func setupPlayerSelectorButton(_ button: UIButton, handler: Selector) {
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.addTarget(self, action: handler, for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = radioButtonSize / 2
    }
    
    private func layout() {
        for row in 0..<3 {
            layoutGameBoardRow(row)
        }
        
        NSLayoutConstraint.activate([
            // Human is player 1 row
            humanIsPlayer1Button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            humanIsPlayer1Button.topAnchor.constraint(equalTo: boardPositions[6].bottomAnchor, constant: 30),
            humanIsPlayer1Button.widthAnchor.constraint(equalToConstant: radioButtonSize),
            humanIsPlayer1Button.heightAnchor.constraint(equalTo: humanIsPlayer1Button.widthAnchor),
            humanIsPlayer1Label.leadingAnchor.constraint(equalTo: humanIsPlayer1Button.trailingAnchor, constant: 8),
            humanIsPlayer1Label.centerYAnchor.constraint(equalTo: humanIsPlayer1Button.centerYAnchor),
            
            // Human is player 2 row
            humanIsPlayer2Button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            humanIsPlayer2Button.topAnchor.constraint(equalTo: humanIsPlayer1Button.bottomAnchor, constant: 15),
            humanIsPlayer2Button.widthAnchor.constraint(equalToConstant: radioButtonSize),
            humanIsPlayer2Button.heightAnchor.constraint(equalTo: humanIsPlayer1Button.widthAnchor),
            humanIsPlayer2Label.leadingAnchor.constraint(equalTo: humanIsPlayer2Button.trailingAnchor, constant: 8),
            humanIsPlayer2Label.centerYAnchor.constraint(equalTo: humanIsPlayer2Button.centerYAnchor),

            startEndButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            startEndButton.topAnchor.constraint(equalTo: humanIsPlayer2Button.bottomAnchor, constant: 30),
            startEndButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            startEndButton.heightAnchor.constraint(equalToConstant: 44),
            ])
    }
    
    private func layoutGameBoardRow(_ row: Int) {
        let boardPositionBaseIndex = row * 3
        var rowTopAnchor = view.safeAreaLayoutGuide.topAnchor
        var topAnchorOffset: CGFloat = 30
        if row > 0 {
            rowTopAnchor = boardPositions[boardPositionBaseIndex-3].bottomAnchor
            topAnchorOffset = 8
        }
        
        NSLayoutConstraint.activate([
            boardPositions[boardPositionBaseIndex].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            boardPositions[boardPositionBaseIndex].topAnchor.constraint(equalTo: rowTopAnchor, constant: topAnchorOffset),
            boardPositions[boardPositionBaseIndex].heightAnchor.constraint(equalTo: boardPositions[boardPositionBaseIndex].widthAnchor),
            
            boardPositions[boardPositionBaseIndex+1].leadingAnchor.constraint(equalTo: boardPositions[boardPositionBaseIndex].trailingAnchor, constant: 8),
            boardPositions[boardPositionBaseIndex+1].topAnchor.constraint(equalTo: rowTopAnchor, constant: topAnchorOffset),
            boardPositions[boardPositionBaseIndex+1].widthAnchor.constraint(equalTo: boardPositions[boardPositionBaseIndex].widthAnchor),
            boardPositions[boardPositionBaseIndex+1].heightAnchor.constraint(equalTo: boardPositions[boardPositionBaseIndex].widthAnchor),
            
            boardPositions[boardPositionBaseIndex+2].leadingAnchor.constraint(equalTo: boardPositions[boardPositionBaseIndex+1].trailingAnchor, constant: 8),
            boardPositions[boardPositionBaseIndex+2].topAnchor.constraint(equalTo: rowTopAnchor, constant: topAnchorOffset),
            boardPositions[boardPositionBaseIndex+2].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            boardPositions[boardPositionBaseIndex+2].widthAnchor.constraint(equalTo: boardPositions[boardPositionBaseIndex].widthAnchor),
            boardPositions[boardPositionBaseIndex+2].heightAnchor.constraint(equalTo: boardPositions[boardPositionBaseIndex].widthAnchor),
            ])
    }
    
    // MARK: - Button Handlers
    
    @objc
    private func handleHumanIsPlayer1() {
        isHumanPlayer1 = true
        updatePlayerOrderButtons()
    }

    @objc
    private func handleHumanIsPlayer2() {
        isHumanPlayer1 = false
        updatePlayerOrderButtons()
    }

    @objc
    private func handleStartEndGame() {
        if let _ = game {
            reset()
        }
        else {
            setPlayerButtons(enabled: false)
            let player1: Player = isHumanPlayer1 ? HumanPlayer(symbol: .X) : AutomatedPlayer(symbol: .X)
            let player2: Player = isHumanPlayer1 ? AutomatedPlayer(symbol: .O) : HumanPlayer(symbol: .O)
            game = Game(player1: player1, player2: player2)
            game?.gameOverHandler = handleGameOver
            game?.updatedBoardHandler = handleUpdatedGameBoard
            game?.start()
        }
        updateStartEndButton()
    }

    @objc
    private func handleTapped(boardPosition: UIButton) {
        game?.handleGameBoardTapped(atLocation: boardPosition.tag)
    }

    // MARK: - Helper Methods
    
    private func reset() {
        game = nil
        updateStartEndButton()
        setPlayerButtons(enabled: true)
        for i in 0..<9 {
            boardPositions[i].setTitle("", for: .normal)
        }
    }
    
    private func setPlayerButtons(enabled isEnabled: Bool) {
        humanIsPlayer1Button.isEnabled = isEnabled
        humanIsPlayer2Button.isEnabled = isEnabled
        humanIsPlayer1Button.setTitleColor((isEnabled ? UIColor.black : UIColor.lightGray), for: .normal)
        humanIsPlayer2Button.setTitleColor((isEnabled ? UIColor.black : UIColor.lightGray), for: .normal)
    }
    
    private func updatePlayerOrderButtons() {
        if isHumanPlayer1 {
            humanIsPlayer1Button.setTitle("✓", for: .normal)
            humanIsPlayer2Button.setTitle("", for: .normal)
        }
        else {
            humanIsPlayer1Button.setTitle("", for: .normal)
            humanIsPlayer2Button.setTitle("✓", for: .normal)
        }
    }

    private func updateStartEndButton() {
        if let _ = game {
            startEndButton.backgroundColor = UIColor.red
            startEndButton.setTitle(endGameText, for: .normal)
        }
        else {
            startEndButton.backgroundColor = UIColor.green
            startEndButton.setTitle(startGameText, for: .normal)
        }
    }

    private func getGameResultText(forWinner winner: Player?) -> String {
        guard let winner = winner else { return youTiedText }
        
        var gameResultText: String
        if isHumanPlayer1 {
            gameResultText = (winner.symbol == .X ? youWonText : youLostText)
        }
        else {
            gameResultText = (winner.symbol == .O ? youWonText : youLostText)
        }
        return gameResultText
    }

    // MARK: - Game Callback Methods

    // Signal the game end and display the result to the user, then reset the game
    private func handleGameOver(withWinner winner: Player?) {
        // TODO: Inform the user of the game-end result (this can be as creative or simple as you want to make it)
        // This placeholder code just throws up an alert
        // --------------------------------------------------------------------------
        let alert = UIAlertController(title: gameOverText, message: getGameResultText(forWinner: winner), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: okButtonTitle, style: .default) { (_) in
            self.reset()
        })
        present(alert, animated: true, completion: nil)
        // --------------------------------------------------------------------------
    }
    
    private func handleUpdatedGameBoard(_ board: GameBoard) {
        for i in 0..<9 {
            if let symbol = board.gamePiece(atLocation: i) {
                let symbolString = (symbol != .blank ? symbol.rawValue : "")
                boardPositions[i].setTitle(symbolString, for: .normal)
            }
        }
    }
}

// MARK: - Localizable Strings

private let humanIsPlayer1Text = NSLocalizedString("You are X (player 1)", comment: "Human is Player 1 (X) label text")
private let humanIsPlayer2Text = NSLocalizedString("You are O (player 2)", comment: "Human is Player 2 (O) label text")
private let startGameText = NSLocalizedString("Start Game", comment: "Start game button text")
private let endGameText = NSLocalizedString("End Game", comment: "End game button text")
private let gameOverText = NSLocalizedString("Game Over", comment: "Game Over")
private let youWonText = NSLocalizedString("You Won!", comment: "You Won")
private let youLostText = NSLocalizedString("You Lost.", comment: "You Lost")
private let youTiedText = NSLocalizedString("You Tied.", comment: "You tied")
private let okButtonTitle = NSLocalizedString("Ok", comment: "Ok button text")

// MARK: - UIView Convenience Extension

extension UIView {
    func addSubviewWithAutoLayout(_ subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subView)
    }
}
