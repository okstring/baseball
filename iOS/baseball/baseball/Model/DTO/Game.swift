//
//  Game.swift
//  baseball
//
//  Created by Issac on 2021/05/04.
//

import Foundation

struct Game: Codable {
    let playTeam: String
    let roundInfo: RoundInfo
    let defenseTeam: DefenseTeam
    let offenceTeam: OffenceTeam
    let story: [String]
}
