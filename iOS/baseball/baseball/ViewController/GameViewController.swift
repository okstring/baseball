//
//  GameViewController.swift
//  baseball
//
//  Created by Issac on 2021/05/04.
//

import UIKit
import SnapKit
import Combine



final class GameViewController: UIViewController {
    enum Section {
        case main
    }
    
    @IBOutlet weak var gameView: GameView!
    @IBOutlet weak var ballCount: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    private lazy var dataSource = makeDataSource()
    private(set) var gameManager: GameManager!
    private var cancelable = Set<AnyCancellable>()
    
    private typealias Datasource = UITableViewDiffableDataSource<Section, History>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, History>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        bind()
        configureTableViewHeight()
        appearPitchButton()
        
    }
    
    func bind() {
        self.gameManager.$gameInfo
            .receive(on: DispatchQueue.main)
            .sink { (game) in
                guard let game = game else { return }
                let history = self.gameManager.makeHistory(gameInfo: game)
                //MARK: - 화면 표시
                
                self.applySnapshot(history: history, animatingDifferences: false)
            }.store(in: &cancelable)
    }
    
    func setGameManager(_ manager: GameManager) {
        self.gameManager = manager
    }
    
    private func configureTableViewHeight() {
        DispatchQueue.main.async {
            self.tableViewHeight.constant = self.ballCount.contentSize.height
        }
    }
    
    private func registerNib() {
        let nibName = UINib(nibName: "GameStoryTableViewCell", bundle: nil)
        ballCount.register(nibName, forCellReuseIdentifier: GameStoryTableViewCell.className)
    }
    
    private func makeDataSource() -> Datasource {
        Datasource.init(tableView: ballCount) { (tableView, indexPath, history) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GameStoryTableViewCell.className, for: indexPath) as? GameStoryTableViewCell else { return GameStoryTableViewCell() }
            cell.configure(historyInfo: history, index: indexPath.row)
            return cell
        }
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

