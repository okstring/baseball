//
//  GameTabBarViewController.swift
//  baseball
//
//  Created by Issac on 2021/05/06.
//

import UIKit

final class GameTabBarViewController: UITabBarController {
    private(set) var gameManager: GameManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGameManagerOfOtherViewController()
        self.setTabBarItems()
        self.getGameInfo()
    }
    
    func setGameManager(_ manager: GameManager) {
        self.gameManager = manager
    }
    
    func getGameInfo() {
        self.gameManager.getGameInfo()
    }
    
    private func setGameManagerOfOtherViewController() {
        guard let gameViewController = self.viewControllers?[0] as? GameViewController else { return }
        gameViewController.setGameManager(self.gameManager)
        guard let scoreBoardViewController = self.viewControllers?[1] as? ScoreBoardViewController else { return }
        scoreBoardViewController.setGameManager(self.gameManager)
    }
    
    private func setTabBarItems() {
        guard let gameItem = self.tabBar.items?[0] else { return }
        gameItem.image = UIImage(named: "baseball")
        gameItem.title = "Game"
        
        guard let scoreItem = self.tabBar.items?[1] else { return }
        scoreItem.image = UIImage(systemName: "chart.bar.xaxis")
        scoreItem.title = "Scores"
    }
}
