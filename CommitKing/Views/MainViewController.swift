//
//  MainViewController.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/13.
//

import UIKit

class MainViewController: UIViewController {
    
    private let getUserInfomationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setTitle("UserInfo 출력", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonAction()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(getUserInfomationButton)
        getUserInfomationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            getUserInfomationButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            getUserInfomationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getUserInfomationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            getUserInfomationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func buttonAction() {
        getUserInfomationButton.addAction(getUserAction, for: .touchUpInside)
    }
    let getUserAction = UIAction { _ in
        print("user")
    }
}
