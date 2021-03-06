//
//  ComputersTurnState.swift
//  XO-game
//
//  Created by Margarita Novokhatskaia on 13/10/2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

public class ComputersTurnState: GameState {
    
    public private(set) var isCompleted = false
    public let markViewPrototype: MarkView
    
    public let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    init(player: Player, markViewPrototype: MarkView, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
    }
    
    public func begin() {
        switch self.player {
        case .first:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = true
            self.gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        self.gameViewController?.winnerLabel.isHidden = true
    }
    
    public func addMark(at position: GameboardPosition) {
        var playerPosition: GameboardPosition
        switch self.player {
        case .first:
            playerPosition = position
        case .second:
            playerPosition = GameboardPosition(column: Int.random(in: 0..<GameboardSize.columns),
                                               row: Int.random(in: 0..<GameboardSize.rows))
        }
        guard let gameboardView = self.gameboardView,
              gameboardView.canPlaceMarkView(at: playerPosition) else { return }
        Log(.playerInput(player: self.player, position: playerPosition))
        self.gameboard?.setPlayer(self.player, at: playerPosition)
        self.gameboardView?.placeMarkView(self.markViewPrototype.copy(), at: playerPosition)
        self.isCompleted = true
    }
}

