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
        // "state" string to prevent XSS Attack
        let uuid = UUID().uuidString
        var components = URLComponents(string: GithubConfig.CODEURL)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: GithubConfig.CLIENT_ID),
            URLQueryItem(name: "scope", value: GithubConfig.SCOPE),
            URLQueryItem(name: "redirect_uri", value: GithubConfig.REDIRECT_URI+"://login"),
            URLQueryItem(name: "state", value: uuid)
        ]
        UIApplication.shared.open(components.url!)
    }
    
//    func githublogin() {
//        let uuid = UUID().uuidString
//        let authURLFull = "https://github.com/login/oauth/authorize?client_id=" + GithubConfig.CLIENT_ID + "&scope=" + GithubConfig.SCOPE + "&redirect_uri=" + GithubConfig.REDIRECT_URI + "&state=" + uuid
//        guard let url = URL(string: authURLFull) else { return }
//        UIApplication.shared.open(url)
//    }
//    func createGithubAuthVC() {
//        let githubViewController = UIViewController()
//        let uuid = UUID().uuidString
//        let webView = WKWebView()
//
//        webView.navigationDelegate = self
//
//        githubViewController.view.addSubview(webView)
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            loginButton.topAnchor.constraint(equalTo: githubViewController.view.topAnchor),
//            loginButton.leadingAnchor.constraint(equalTo: githubViewController.view.leadingAnchor),
//            loginButton.trailingAnchor.constraint(equalTo: githubViewController.view.trailingAnchor),
//            loginButton.bottomAnchor.constraint(equalTo: githubViewController.view.bottomAnchor)
//        ])
//
//        let authURLFull = "https://github.com/login/oauth/authorize?client_id=" + GithubConfig.CLIENT_ID + "&scope=" + GithubConfig.SCOPE + "&redirect_uri=" + GithubConfig.REDIRECT_URI + "&state=" + uuid
//        let urlRequest = URLRequest(url: URL(string: authURLFull)!)
//
//        webView.load(urlRequest)
//
//        let navigationController = UINavigationController(rootViewController: githubViewController)
//        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
//        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
//
//        githubViewController.navigationItem.rightBarButtonItem = refreshButton
//        githubViewController.navigationItem.title = "github.com"
//        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationController.navigationBar.titleTextAttributes = textAttributes
//        navigationController.navigationBar.isTranslucent = false
//        navigationController.navigationBar.tintColor = UIColor.white
//        navigationController.navigationBar.barTintColor = UIColor.black
//        navigationController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
//        navigationController.modalTransitionStyle = .coverVertical
//
//        self.present(navigationController, animated: true, completion: nil)
//    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
//    @objc func refreshAction() {
//        self.webView.reload()
//    }
}

