//
//  GameManager.swift
//  baseball
//
//  Created by Issac on 2021/05/06.
//

import Foundation

final class GameManager {
    private let networkingCenter: ServerCommunicable
    private let jsonProcessCenter: JSONDecodable
    private(set) var token: String!
    @Published private(set) var teams: [PairTeams]!
    @Published private(set) var gameInfo: Game!
    @Published private(set) var scoreBoardInfo: ScoreBoard!
    @Published private(set) var homePlayerScoreBoardInfo: PlayerScoreBoard!
    @Published private(set) var awayPlayerScoreBoardInfo: PlayerScoreBoard!
    var errorHandler: ((String) -> ())?
    
    
    init(serverCommunicable: ServerCommunicable, JSONDecodable: JSONDecodable) {
        self.networkingCenter = serverCommunicable
        self.jsonProcessCenter = JSONDecodable
    }
    
    func setToken(token: String) {
        self.token = token
    }
    
    func setGameData(game: Game) {
        self.gameInfo = game
    }
    
    func getGameInfo() {
        self.getRequest(of: .gameScore) { (result: Result<Game, NetworkingError>) in
            switch result {
            case .success(let game):
                self.gameInfo = game
            case .failure(let error):
                self.errorHandler?(error.rawValue)
            }
        }
    }
    
    func getScoreBoard() {
        self.getRequest(of: .gameScore) { (result: Result<ScoreBoard, NetworkingError>) in
            switch result {
            case .success(let scoreBoard):
                self.scoreBoardInfo = scoreBoard
                self.getPlayerScoreBoard(of: scoreBoard.homeTeam.teamName, isHomeTeam: true)
                self.getPlayerScoreBoard(of: scoreBoard.awayTeam.teamName, isHomeTeam: false)
            case .failure(let error):
                self.errorHandler?(error.rawValue)
            }
        }
    }
    
    func getPlayerScoreBoard(of team: String, isHomeTeam: Bool) {
        self.getRequest(of: .gameScore, parameter: team) { (result: Result<PlayerScoreBoard, NetworkingError>) in
            switch result {
            case .success(let playerScoreBoard):
                if isHomeTeam {
                    self.homePlayerScoreBoardInfo = playerScoreBoard
                } else {
                    self.awayPlayerScoreBoardInfo = playerScoreBoard
                }
            case .failure(let error):
                self.errorHandler?(error.rawValue)
            }
        }
    }
    
    func getTeams() {
        self.getRequest(of: .gameList) { (result: Result<[PairTeams], NetworkingError>) in
            switch result {
            case .success(let pairTeams):
                self.teams = pairTeams
            case .failure(let error):
                self.errorHandler?(error.rawValue)
            }
        }
    }
    
    private func getRequest<T: Decodable>(of path: Path, parameter: String? = nil, completion: @escaping ((Result<T, NetworkingError>) -> ())) {
        self.networkingCenter.request(path: path, token: self.token, parameter: parameter) { (result) in
            switch result {
            case .success(let data):
                let decodeResult = self.jsonProcessCenter.decodeData(typeOf: T.self, data: data)
                switch decodeResult {
                case .success(let dto):
                    DispatchQueue.main.async {
                        completion(.success(dto))
                    }
                case .failure(_):
                    completion(.failure(NetworkingError.decodeError))
                }
            case .failure(_):
                completion(.failure(NetworkingError.responseError))
            }
        }
    }
}
