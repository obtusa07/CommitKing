//
//  ViewController.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/04.
//

import UIKit
import Lottie

class LoginViewController: UIViewController {
    // TODO: 여기서 메인 로티 이미지 삽입할 예정, 로티 작업 거치기 전에 UI 작업으로 비어 있는 이미지 넣기
    private let loginCodingImageView: LottieAnimationView = {
        let imageView = LottieAnimationView(name: "LoginCodingImage")
        imageView.loopMode = .loop
        imageView.contentMode = .scaleAspectFit
        imageView.play()
        return imageView
    }()
    private let loginButton: UIButton = {
        // MARK: - UIButton configuration 방식은 iOS 15+
        // configuration의 치명적인 단점은 버튼에 적합한 사이즈의 이미지를 리사이징 하는 기능이 없다는 것이다.
        // WWDC 2018에서 추천한 UIGraphicsImageRenderer을 이용하여 문제 해결 시도하겠음
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "github-mark")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 5
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        configuration.title = "github 로그인"
        configuration.baseBackgroundColor = .black
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .dynamic
        let button = UIButton(configuration: configuration)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonAction()
    }
    private func setupUI() {
        // MARK: - View 세팅
        view.backgroundColor = .white
        // MARK: - LoginButton 세팅
        view.addSubview(loginButton)
        view.addSubview(loginCodingImageView)
        loginCodingImageView.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginCodingImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            loginCodingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            loginCodingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            loginCodingImageView.heightAnchor.constraint(equalToConstant: 500)
        ])
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: loginCodingImageView.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func buttonAction() {
//        loginButton.addAction(loginAction, for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(goHome), for: .touchUpInside)
    }
    @objc private func goHome() {
    #warning(": [BUG] 로그인이 실제로 안 되도 자동으로 넘어가는 문제가 있음 따로 행동을 정의하기 보다 GithubAPIManager에서 처리하는게 합리적일듯")
        GithubAPIManager.loginButtonClicked()
        let viewController = MainViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    // MARK: - UIAction에서 Present를 하는 방법이 잘 모르겠다. 일단 임시로 addTarget으로 처리
    private let loginAction = UIAction { _ in
        GithubAPIManager.loginButtonClicked()
    }
}
