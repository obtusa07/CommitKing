//
//  ViewController.swift
//  githubPractice
//
//  Created by Taehwan Kim on 2023/02/04.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
//    var webView = WKWebView()
//    let getAddress = "https://github.com/login/oauth/authrize"
    
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
        loginButton.addAction(loginAction, for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    let loginAction = UIAction { _ in
        // MARK: "state" string prevent cross site request forgery attack
        GithubAPIManager.loginButtonClicked()
        
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

