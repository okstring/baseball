//
//  ViewController.swift
//  baseball
//
//  Created by 양준혁 on 2021/05/03.
//

import UIKit
import OctoKit
import AuthenticationServices
import Lottie

final class OAuthViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    var webAuthSession: ASWebAuthenticationSession?
    var gameManager: GameManager!
    var oauthManager: OAuthManager!
    private var animationView: AnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let networkingCenter = NetworkingCenter()
        self.gameManager = GameManager(serverCommunicable: networkingCenter)
        self.oauthManager = OAuthManager(serverCommunicable: networkingCenter)
        self.configOAuth()
        self.view.backgroundColor = #colorLiteral(red: 0.1921346784, green: 0.1921729147, blue: 0.1921265125, alpha: 1)
        self.navigationController?.navigationBar.isHidden = true
        makeGameTitleView()
        setAnimationView()
    }
    
    func setAnimationView() {
        animationView = .init(name: "ball")
        animationView?.isUserInteractionEnabled = false
        animationView?.frame = self.view.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        view.addSubview(animationView!)
        animationView?.play()
        
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
    
    @IBAction func loginWithGithub(_ sender: Any) {
        webAuthSession?.start()
    }
    
    func makeGameTitleView() {
        let maskedView = MaskedLabelView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height/3))
        view.addSubview(maskedView)
        maskedView.label.text = "HitAndRun\nProBaseBallManager\n2021"
        maskedView.label.textColor = .black
        maskedView.label.font = UIFont(name: "BlackOpsOne-Regular", size: 30)
        maskedView.startColor = .red
        maskedView.endColor = .black
        maskedView.duration = 3
        maskedView.animate()
    }

}
