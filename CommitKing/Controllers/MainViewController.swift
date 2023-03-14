//
//  MainViewController.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/13.
//

import UIKit

class MainViewController: UIViewController {
    
    private let userProfileView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userImage: UIImageView = {
        let imageView = UIImageView()
        // TODO: 하드 코딩 되어 있는 유저 정보를 로그인 단계에서 뽑아와서 하는 방식으로 바꿀 것
        imageView.imageDownload(urlString: "https://avatars.githubusercontent.com/u/47441965?v=4", contentMode: .scaleToFill)
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "obtusa"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userId: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "@obtusa07"
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weekCommit: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let getUserInfomationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setTitle("UserInfo 출력", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let getTotalCommitCountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setTitle("TotalCommitCount 출력", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setTitle("Logout", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addConstraints()
        buttonAction()
    }
    
    func addConstraints() {
        view.backgroundColor = .systemBackground
        view.addSubviews(userProfileView, getUserInfomationButton, getTotalCommitCountButton, logoutButton)
        userProfileView.addSubviews(userImage, userName, userId, weekCommit)
        
        NSLayoutConstraint.activate([
            getUserInfomationButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            getUserInfomationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getUserInfomationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            getUserInfomationButton.heightAnchor.constraint(equalToConstant: 50),
            
            getTotalCommitCountButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
            getTotalCommitCountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getTotalCommitCountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            getTotalCommitCountButton.heightAnchor.constraint(equalToConstant: 50),

            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50),
            logoutButton.leadingAnchor.constraint(equalTo: logoutButton.trailingAnchor, constant: -50),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),

            userProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userProfileView.heightAnchor.constraint(equalToConstant: 120),

            userImage.centerYAnchor.constraint(equalTo: userProfileView.centerYAnchor),
            userImage.leadingAnchor.constraint(equalTo: userProfileView.leadingAnchor, constant: 50),
            userImage.heightAnchor.constraint(equalToConstant: 70),
            userImage.widthAnchor.constraint(equalToConstant: 70),
            
            userName.topAnchor.constraint(equalTo: userImage.topAnchor),
            userName.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
            userName.trailingAnchor.constraint(equalTo: userProfileView.trailingAnchor),
            userName.heightAnchor.constraint(equalToConstant: 30),
            
            userId.heightAnchor.constraint(equalToConstant: 30),
            userId.bottomAnchor.constraint(equalTo: userImage.bottomAnchor, constant: -10),
            userId.leadingAnchor.constraint(equalTo: userName.leadingAnchor),
            userId.trailingAnchor.constraint(equalTo: userId.trailingAnchor, constant: 20),
            
            weekCommit.centerYAnchor.constraint(equalTo: userProfileView.centerYAnchor),
            weekCommit.leadingAnchor.constraint(equalTo: userProfileView.trailingAnchor, constant: -80)
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
    
    @objc
    private func goLogin() {
        GithubAPIManager.logout()
        let viewController = LoginViewController()
        viewController.modalPresentationStyle = .fullScreen
        // MAKR: - 이런식으로 사용하면 일부 경우 메모리 dealloc을 못 하는 문제 발생하지 않을까?
        self.present(viewController, animated: true, completion: nil)
    }
}
