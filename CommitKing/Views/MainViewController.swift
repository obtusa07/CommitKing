//
//  MainViewController.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/13.
//

import UIKit

class MainViewController: UIViewController {
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        // TODO: 하드 코딩 되어 있는 유저 정보를 로그인 단계에서 뽑아와서 하는 방식으로 바꿀 것
        imageView.imageDownload(urlString: "https://avatars.githubusercontent.com/u/47441965?v=4", contentMode: .scaleToFill)
        return imageView
    }()
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
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setTitle("Logout", for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonAction()
    }
    func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(getUserInfomationButton, getTotalCommitCountButton, logoutButton, userImage)
        getUserInfomationButton.translatesAutoresizingMaskIntoConstraints = false
        getTotalCommitCountButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        userImage.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoutButton.leadingAnchor.constraint(equalTo: logoutButton.trailingAnchor, constant: -50),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -250),
            userImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userImage.trailingAnchor.constraint(equalTo: userImage.leadingAnchor, constant: 50),
            userImage.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func buttonAction() {
        getUserInfomationButton.addAction(getUserAction, for: .touchUpInside)
        getTotalCommitCountButton.addAction(getTotalCommitCount, for: .touchUpInside)
//        logoutButton.addAction(logoutAction, for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(goLogin), for: .touchUpInside)
    }
    let getUserAction = UIAction { _ in
        GithubAPIManager.getMyInfo()
    }
    let getTotalCommitCount = UIAction { _ in
        GithubAPIManager.totalCommits(username: "obtusa07", days: 0) { count, error in
            if let count = count {
                // MARK: 설정된 기간동안 커밋한 숫자를 보여줌
                print("Number of commits : \(count)")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    // MARK: - Navigation 안 되는 문제로 임시로 goLogin 메서드로 대체해서 화면 이동중
    let logoutAction = UIAction { _ in
        GithubAPIManager.logout()
    }
    @objc private func goLogin() {
        GithubAPIManager.logout()
        let viewController = LoginViewController()
        viewController.modalPresentationStyle = .fullScreen
        // MAKR: - 이런식으로 사용하면 일부 경우 메모리 dealloc을 못 하는 문제 발생하지 않을까?
        self.present(viewController, animated: true, completion: nil)
    }
}
