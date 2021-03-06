//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    private let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            self.currentState.begin()
        }
    }
    private lazy var referee = Referee(gameboard: self.gameboard)
    private var turn = 0
    
    @IBOutlet weak var modeControl: UISegmentedControl!
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    @IBAction func didModeChanged(_ sender: Any) {
        restartGame()
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        restartGame()
    }
    
    private func restartGame() {
        Log(.restartGame)
        gameboardView.clear()
        gameboard.clear()
        goToFirstState()
        turn = 0
        gameboardView.markInvoker
    }
    
    private func goToFirstState() {
        let player = Player.first
        switch modeControl.selectedSegmentIndex {
        case 0:
            currentState = PlayerInputState(player: player,
                                                 gameViewController: self,
                                                 gameboard: gameboard,
                                                 gameboardView: gameboardView)
        case 1:
            currentState = ComputersTurnState(player: player,
                                                 markViewPrototype: player.markViewPrototype,
                                                 gameViewController: self,
                                                 gameboard: gameboard,
                                                 gameboardView: gameboardView)
        default:
            return
        }
    }

    private func goToNextState() {
        turn += 1
        if turn >= GameboardSize.count {
            self.currentState = GameEndedState(winner: nil, gameViewController: self)
            return
        }
        
        if let winner = self.referee.determineWinner() {
            self.currentState = GameEndedState(winner: winner, gameViewController: self)
            return
        }
        if let playerInputState = currentState as? PlayerInputState {
            let player = playerInputState.player.next
            self.currentState = PlayerInputState(player: player,
                                                 gameViewController: self,
                                                 gameboard: gameboard,
                                                 gameboardView: gameboardView)
        }
        if let playerInputState = currentState as? ComputersTurnState {
            let player = playerInputState.player.next
            self.currentState = ComputersTurnState(player: player,
                                                 markViewPrototype: player.markViewPrototype,
                                                 gameViewController: self,
                                                 gameboard: gameboard,
                                                 gameboardView: gameboardView)
        }
        
    }
}

