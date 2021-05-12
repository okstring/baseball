//
//  ViewController.swift
//  baseball
//
//  Created by 양준혁 on 2021/05/03.
//

import UIKit
import OctoKit
import AuthenticationServices

final class OAuthViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    var webAuthSession: ASWebAuthenticationSession?
    var gameManager: GameManager!
    var oauthManager: OAuthManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        let networkingCenter = NetworkingCenter()
        self.gameManager = GameManager(serverCommunicable: networkingCenter)
        self.oauthManager = OAuthManager(serverCommunicable: networkingCenter)
        self.configOAuth()
    }
    
    func bind() {
        self.oauthManager.errorHandler = { error in
            #if DEBUG
            NSLog(error)
            #endif
        }
    }
    
    func configOAuth() {
        webAuthSession = self.oauthManager.initPostLoginCodeWebAuthSession() { (userDTO) in
            DispatchQueue.main.async {
                guard let vc = self.storyboard?.instantiateViewController(identifier: MainViewController.className) as? MainViewController else { return }
                self.gameManager.setToken(token: userDTO.token)
                vc.receiveManager(gameManager: self.gameManager)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        webAuthSession?.presentationContextProvider = self
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    @IBAction func touchGithubLogin(_ sender: UIButton) {
        webAuthSession?.start()
    }
}
