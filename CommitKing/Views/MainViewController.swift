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
    private let getTotalCommitCountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setTitle("TotalCommitCount 출력", for: .normal)
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
        view.addSubview(getTotalCommitCountButton)
        getUserInfomationButton.translatesAutoresizingMaskIntoConstraints = false
        getTotalCommitCountButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            getUserInfomationButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            getUserInfomationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getUserInfomationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            getUserInfomationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            getTotalCommitCountButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
            getTotalCommitCountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getTotalCommitCountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            getTotalCommitCountButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func buttonAction() {
        getUserInfomationButton.addAction(getUserAction, for: .touchUpInside)
        getTotalCommitCountButton.addAction(getTotalCommitCount, for: .touchUpInside)
    }
    
    let getUserAction = UIAction { _ in
        GithubAPIManager.getMyInfo()
    }
    let getTotalCommitCount = UIAction { _ in
//        GithubAPIManager.totalCommits(username: "obtusa07")
        GithubAPIManager.getgetgetTemp(username: "obtusa07", days: 7) { count, error in
            if let count = count {
                print("Number of commits in the last week: \(count)")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }

    }
}
