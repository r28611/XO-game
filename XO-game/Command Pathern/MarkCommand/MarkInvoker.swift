//
//  MarkInvoker.swift
//  XO-game
//
//  Created by Margarita Novokhatskaia on 14/10/2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation
// MARK: - Invoker

final class MarkInvoker {
    
    // MARK: Singleton
    
    static let shared = MarkInvoker()
    
    // MARK: Private properties
    
    private let batchSize = 5
    
    private var commands: [MarkCommand] = []
    
    // MARK: Internal
    
    func addMarkCommand(_ command: MarkCommand) {
        self.commands.append(command)
        self.executeCommandsIfNeeded()
    }
    
    // MARK: Private
    
    private func executeCommandsIfNeeded() {
        guard self.commands.count >= batchSize else {
            return
        }
        self.commands.forEach { $0.execute() }
        self.commands = []
    }
}
