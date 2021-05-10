//
//  MainViewController.swift
//  baseball
//
//  Created by Issac on 2021/05/04.
//

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet var teams: [UIButton]!
    var gameManager: GameManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func receiveManager(gameManager: GameManager) {
        self.gameManager = gameManager
    }
    
    func getPlayer() {
        self.gameManager.getRequest(of: .gameList) { (result: Result<[GameList], NetworkingError>) in
            switch result {
            case .success(let gameList):
                self.loadTeamList(gameList: gameList)
            case .failure(let error):
                #if DEBUG
                NSLog(error.rawValue)
                #endif
            }
        }
    }
    
    func loadTeamList(gameList: [GameList]) {
        for (index, lineup) in gameList.enumerated() {
            teams[index * 2].setTitle(lineup.pairTeams.homeTeamName, for: .normal)
            teams[index * 2 + 1].setTitle(lineup.pairTeams.awayTeamName, for: .normal)
        }
    }
    
    func addTarget() {
        for button in self.teams {
            button.addTarget(self, action: #selector(pushGameTabBar(_:)), for: .touchUpInside)
        }
    }
    
    @objc func pushGameTabBar(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: GameTabBarViewController.className) as? GameTabBarViewController else { return }
        //MARK: - network, 둘 다 불러와야 하는건가?
        self.gameManager.getRequest(of: Path.gameStart) { (result: Result<Game, NetworkingError>) in
            <#code#>
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
