//
//  ViewController.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/04.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    // TODO: 여기서 메인 로티 이미지 삽입할 예정, 로티 작업 거치기 전에 UI 작업으로 비어 있는 이미지 넣기
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.tintColor = .white
        button.setTitle("github 로그인", for: .normal)
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
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
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

