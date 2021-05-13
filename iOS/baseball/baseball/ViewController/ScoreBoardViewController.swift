//
//  ScoreBoardViewController.swift
//  baseball
//
//  Created by Issac on 2021/05/04.
//

import UIKit
import Combine

final class ScoreBoardViewController: UIViewController {
    enum Section {
        case main
    }
    
    @IBOutlet weak var gameHeaderView: GameHeaderView!
    @IBOutlet weak var homeTotalScore: UILabel!
    @IBOutlet weak var awayTotalScore: UILabel!
    @IBOutlet var homeScores: [UILabel]!
    @IBOutlet var awayScores: [UILabel]!
    @IBOutlet weak var playerScoreTableView: UITableView!
    @IBOutlet weak var teamControllBar: UISegmentedControl!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    private(set) var gameManager: GameManager!
    private var cancelable = Set<AnyCancellable>()
    
    fileprivate typealias DataSource = UITableViewDiffableDataSource<Section, PlayerScoreBoard>
    fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PlayerScoreBoard>
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gameHeaderViewDelegate = HeaderScoreDelegate(gameManager: self.gameManager)
        self.gameHeaderView.delegate = gameHeaderViewDelegate
        self.playerScoreTableView.delegate = self
        self.tableViewCellRegisterNib()
        bind()
        gameManager.getScoreBoard()
        gameHeaderView.teamConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameManager.getScoreBoard()
        gameHeaderView.scoreConfigure()
    }
    
    func bind() {
        self.gameManager.$scoreBoardInfo
            .receive(on: DispatchQueue.main)
            .sink { (scoreBoard) in
                guard let scoreBoard = scoreBoard else { return }
                self.setTeamControllerBar()
                self.setTeamScoreBoard(board: scoreBoard)
            }.store(in: &cancelable)
        
        self.gameManager.$homePlayerScoreBoardInfo
            .receive(on: DispatchQueue.main)
            .sink { homePlayerScoreBoard in
                guard let homePlayerScoreBoard = homePlayerScoreBoard else { return }
                self.itemListDidLoad(playerScore: homePlayerScoreBoard)
            }.store(in: &cancelable)
        
        self.gameManager.$awayPlayerScoreBoardInfo
            .receive(on: DispatchQueue.main)
            .sink { awayPlayerScoreBoard in
                guard let awayPlayerScoreBoard = awayPlayerScoreBoard else { return }
                self.itemListDidLoad(playerScore: awayPlayerScoreBoard)
            }.store(in: &cancelable)
    }
    
    func setTeamScoreBoard(board: ScoreBoard) {
        board.homeTeam.scores.enumerated().forEach{ (index, score) in
            self.homeScores[index].text = String(score)
        }
        board.awayTeam.scores.enumerated().forEach{ (index, score) in
            self.awayScores[index].text = String(score)
        }
    }
    
    
    func setGameManager(_ manager: GameManager) {
        self.gameManager = manager
    }
    
    private func setTeamControllerBar() {
        guard let scoreBoard = self.gameManager.scoreBoardInfo else { return }
        teamControllBar.setTitle(scoreBoard.homeTeam.teamName, forSegmentAt: 0)
        teamControllBar.setTitle(scoreBoard.awayTeam.teamName, forSegmentAt: 1)
        self.teamControllBar.addTarget(self, action: #selector(controllerBarChanged(_:)), for: .valueChanged)
    }

    @objc func controllerBarChanged(_ sender: UISegmentedControl) {
        guard let scoreBoard = self.gameManager.scoreBoardInfo else { return }
        switch teamControllBar.selectedSegmentIndex {
        case 0: gameManager.getPlayerScoreBoard(of: scoreBoard.homeTeam.teamName, isHomeTeam: true)
        case 1: gameManager.getPlayerScoreBoard(of: scoreBoard.awayTeam.teamName, isHomeTeam: false)
        default: break
        }
    }
    
    private func tableViewCellRegisterNib() {
        let nib = UINib(nibName: PlayerScoreTableViewCell.className, bundle: nil)
        self.playerScoreTableView.register(nib, forCellReuseIdentifier: PlayerScoreTableViewCell.className)
        let headerNib = UINib(nibName: PlayerScoreHeaderTableViewCell.className, bundle: nil)
        self.playerScoreTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: PlayerScoreHeaderTableViewCell.className)
        let footerNib = UINib(nibName: PlayerScoreFooterTableViewCell.className, bundle: nil)
        self.playerScoreTableView.register(footerNib, forHeaderFooterViewReuseIdentifier: PlayerScoreFooterTableViewCell.className)
    }
    
    private func itemListDidLoad(playerScore: [PlayerScoreBoard]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(playerScore, toSection: .main)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func makeDataSource() -> DataSource {
        DataSource(tableView: self.playerScoreTableView) { (tableView, indexPath, playerScoreBoard) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerScoreTableViewCell.className) as? PlayerScoreTableViewCell else { return PlayerScoreTableViewCell() }
            cell.configure(playerScoreBoard: playerScoreBoard)
            return cell
        }
    }
}

extension ScoreBoardViewController {
    private func sumScore(of scores: [UILabel]) -> String{
        return "\(scores.reduce(0, { $0 + (Int($1.text ?? "0") ?? 0)  }))"
    }
}

extension ScoreBoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = Bundle.main.loadNibNamed(PlayerScoreHeaderTableViewCell.className, owner: self, options: nil)?.last as? PlayerScoreHeaderTableViewCell else { return nil }
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = Bundle.main.loadNibNamed(PlayerScoreFooterTableViewCell.className, owner: self, options: nil)?.last as? PlayerScoreFooterTableViewCell else { return nil }
        guard let team = GameManager.Team(rawValue: self.teamControllBar.selectedSegmentIndex),
              gameManager.homePlayerScoreBoardInfo != nil else { return footer }
        footer.configure(playerScore: self.gameManager.totalPlayerScoreCount(team: team))
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}
