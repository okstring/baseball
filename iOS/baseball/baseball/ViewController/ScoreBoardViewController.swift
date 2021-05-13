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
        self.playerScoreTableView.delegate = self
        self.tableViewCellRegisterNib()
        bind()
        gameManager.getScoreBoard()
//        configureTableViewHeight()
    }
    
//    private func configureTableViewHeight() {
//        DispatchQueue.main.async {
//            self.tableViewHeight.constant = self.playerScoreTableView.contentSize.height
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameManager.getScoreBoard()
    }
    
    func bind() {
        self.gameManager.$scoreBoardInfo
            .receive(on: DispatchQueue.main)
            .sink { (scoreBoard) in
                guard let scoreBoard = scoreBoard else { return }
                self.setTeamControllerBarTitle(home: scoreBoard.homeTeam.teamName, away: scoreBoard.awayTeam.teamName)
                self.setTeamScoreBoard(board: scoreBoard)
            }.store(in: &cancelable)
        
        self.gameManager.$homePlayerScoreBoardInfo
            .receive(on: DispatchQueue.main)
            .sink { homePlayerScoreBoard in
                guard let homePlayerScoreBoard = homePlayerScoreBoard else { return }
                self.itemListDidLoad(playerScore: homePlayerScoreBoard)
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
    
    private func setTeamControllerBarTitle(home: String, away: String) {
        teamControllBar.setTitle(home, forSegmentAt: 0)
        teamControllBar.setTitle(away, forSegmentAt: 1)
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
        let footer = Bundle.main.loadNibNamed(PlayerScoreFooterTableViewCell.className, owner: self, options: nil)?.last as! PlayerScoreFooterTableViewCell
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}
