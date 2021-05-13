//
//  GameViewController.swift
//  baseball
//
//  Created by Issac on 2021/05/04.
//

import UIKit
import SnapKit
import Combine



final class GameViewController: UIViewController{
    enum Section {
        case main
    }
    
    @IBOutlet weak var gameHeaderView: GameHeaderView!
    @IBOutlet weak var gameView: GameView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var ballCountTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet private var strikeCount: [UIImageView]!
    @IBOutlet private var ballCount: [UIImageView]!
    @IBOutlet private var outCount: [UIImageView]!
    @IBOutlet weak var picherName: UILabel!
    @IBOutlet weak var picherCount: UILabel!
    @IBOutlet weak var hitterName: UILabel!
    @IBOutlet weak var hitterCount: UILabel!
    
    private lazy var dataSource = makeDataSource()
    private(set) var gameManager: GameManager!
    private var cancelable = Set<AnyCancellable>()
    private typealias Datasource = UITableViewDiffableDataSource<Section, History>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, History>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameHeaderView.delegate = self
        registerNib()
        bind()
        configureTableViewHeight()
        appearPitchButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func bind() {
        self.gameManager.$gameInfo
            .receive(on: DispatchQueue.main)
            .sink { (game) in
                guard let game = game else { return }
                let history = self.gameManager.makeHistory(gameInfo: game)
                self.gameHeaderView.teamConfigure()
                self.gameHeaderView.scoreConfigure()
                self.setGameCount()
                self.setRoundInfo()
                self.setPlayers()
                self.gameView.setPlayerLayer(firstBase: game.roundInfo.firstBase, secondBase: game.roundInfo.secondBase, thirdBase: game.roundInfo.thirdBase)
                self.applySnapshot(history: history, animatingDifferences: false)
            }.store(in: &cancelable)
    }
    
    func setRoundInfo() {
        self.roundLabel.text = self.gameManager.makeRoundInfo()
    }
    
    func setGameManager(_ manager: GameManager) {
        self.gameManager = manager
    }
    
    private func configureTableViewHeight() {
        DispatchQueue.main.async {
            self.tableViewHeight.constant = self.ballCountTableView.contentSize.height
        }
    }
    
    private func registerNib() {
        let nibName = UINib(nibName: "GameStoryTableViewCell", bundle: nil)
        ballCountTableView.register(nibName, forCellReuseIdentifier: GameStoryTableViewCell.className)
    }
    
    private func makeDataSource() -> Datasource {
        Datasource.init(tableView: ballCountTableView) { (tableView, indexPath, history) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GameStoryTableViewCell.className, for: indexPath) as? GameStoryTableViewCell else { return GameStoryTableViewCell() }
            cell.configure(historyInfo: history, index: indexPath.row)
            self.reverseTableView(cell: cell, tableView: tableView)
            return cell
        }
    }
    
    private func reverseTableView(cell: UITableViewCell, tableView: UITableView) {
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
    }
    
    private func applySnapshot(history: [History], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(history, toSection: .main)
        self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func appearPitchButton() {
        let pitchButton = PitchButton()
        pitchButton.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        self.view.addSubview(pitchButton)
        pitchButton.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self.gameView.safeAreaLayoutGuide)
            $0.width.equalTo(120)
            $0.height.equalTo(30)
        }
    }
    
    @objc func buttonDidTap() {
        gameView.hit()
    }
    
    
}

extension GameViewController {
    private func setGameCount() {
        let strike = self.gameManager.gameInfo.roundInfo.strike
        let ball = self.gameManager.gameInfo.roundInfo.ball
        let out = self.gameManager.gameInfo.roundInfo.out
        
        self.strikeCount.enumerated().forEach { (index, strikeImage) in
            strikeImage.image = index + 1 <= strike ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        }
        self.ballCount.enumerated().forEach { (index, ballImage) in
            ballImage.image = index + 1 <= ball ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        }
        self.outCount.enumerated().forEach { (index, outImage) in
            outImage.image = index + 1 <= out ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        }
    }
    
    private func setPlayers() {
        guard let gameInfo = self.gameManager.gameInfo else { return }
        self.picherName.text = gameInfo.defenseTeam.pitcher.name
        self.picherCount.text = "#\(gameInfo.defenseTeam.pitcher.pit)"
        self.hitterName.text = gameInfo.offenceTeam.hitter.name
        self.hitterCount.text = "\(gameInfo.offenceTeam.hitter.tpa)타석 \(gameInfo.offenceTeam.hitter.hits)안타"
    }
    
}

extension GameViewController: HeaderScoreReloadable {
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
