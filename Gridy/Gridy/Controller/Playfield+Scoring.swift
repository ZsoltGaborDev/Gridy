//
//  Scoring.swift
//  Gridy
//
//  Created by zsolt on 20/04/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

extension PlayfieldView {
    func scoring(moves: Int) {
        self.moves += 1
        scoreLabel.text = "\(moves)"
    }
    func yourScore() -> Int {
        let score = moves * 100 / (moves - rightMoves)
        return score
    }
}
