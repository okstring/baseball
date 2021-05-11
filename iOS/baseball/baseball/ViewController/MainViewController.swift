//
//  MainViewController.swift
//  baseball
//
//  Created by Issac on 2021/05/04.
//

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet var teams: [UIButton]!
    private var gameManager: GameManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func receiveManager(gameManager: GameManager) {
        self.gameManager = gameManager
    }
    
    func getPlayer() {
        self.gameManager.getRequest(of: .gameList) { (result: Result<[PairTeams], NetworkingError>) in
            switch result {
            case .success(let pairTeams):
                self.loadTeamList(pairTeams: pairTeams)
            case .failure(let error):
                #if DEBUG
                NSLog(error.rawValue)
                #endif
            }
        }
    }
    
    func loadTeamList(pairTeams: [PairTeams]) {
        for (index, lineup) in pairTeams.enumerated() {
            teams[index * 2].setTitle(lineup.homeTeamName, for: .normal)
            teams[index * 2 + 1].setTitle(lineup.awayTeamName, for: .normal)
        }
        self.addTarget()
    }
    
    func addTarget() {
        for button in self.teams {
            button.addTarget(self, action: #selector(pushGameTabBar(_:)), for: .touchUpInside)
        }
    }
    
    @objc func pushGameTabBar(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: GameTabBarViewController.className) as? GameTabBarViewController else { return }
        //MARK: - network 부분 처리
        self.gameManager.getRequest(of: .gameStart, parameter: sender.currentTitle) { (result: Result<Game, NetworkingError>) in
            switch result {
            case .success(let game):
                print(game)
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                #if DEBUG
                NSLog(error.rawValue)
                #endif
            }
        }
    }
}
