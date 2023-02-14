//
//  ViewController.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/04.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
    
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
        loginButton.addAction(loginAction, for: .touchUpInside)
    }
    
    let loginAction = UIAction { _ in
        GithubAPIManager.loginButtonClicked()
    }
    
}
