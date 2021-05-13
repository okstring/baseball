//
//  HeaderScoreReloadable.swift
//  baseball
//
//  Created by Issac on 2021/05/13.
//

import UIKit

class HeaderScoreDelegate: NSObject, HeaderScoreReloadable {
    private var gameManager: GameManager
    
    init(gameManager: GameManager) {
        self.gameManager = gameManager
    }
    
    func didLoadScoreInfo() -> (offenceTeam: Int, deffenceTeam: Int) {
        let gameInfo = self.gameManager.gameInfo
        return (gameInfo?.offenceTeam.score ?? 0,
                gameInfo?.defenseTeam.score ?? 0)
    }
    
    func didLoadTeamInfo() -> (offenceTeam: String, deffenceTeam: String) {
        let gameInfo = self.gameManager.gameInfo
        return (gameInfo?.offenceTeam.teamName ?? "",
                gameInfo?.defenseTeam.teamName ?? "")
    }
}
