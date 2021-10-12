//
//  Copying.swift
//  XO-game
//
//  Created by Margarita Novokhatskaia on 12/10/2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

protocol Copying {
    init(_ prototype: Self)
}

extension Copying {
    func copy() -> Self {
        return type(of: self).init(self)
    }
}
