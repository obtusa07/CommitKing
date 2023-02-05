//
//  GithubAPIManager.swift
//  githubPractice
//
//  Created by Taehwan Kim on 2023/02/05.
//

import Foundation

class GithubAPIManager {
    static let sharedInstance = GithubAPIManager()
    // MARK: 이곳으로 로그인 시도 옮겨오기
//    현재 ViewController에서 관리
    
    
    // MARK: URL을 Scene에서 받아서 POST로 보내고 Token 받아오기
    // Json으로 보내면 아래와 같은 놈이 나올거
    // Accept: application/json
//    {
//      "access_token":"gho_16C7e42F292c6912E7710c838347Ae178B4a",
//      "scope":"repo,gist",
//      "token_type":"bearer"
//    }
    func tokenGenerate(url: URL) {
        let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
        print(code)
        
        
        // UserDefaults로 토큰을 저장하기
    }
    
    func logout() {
        // UserDefaults로 토큰 삭제
        // 여기서 View를 최초 화면으로 가게 하는게 맞나? 고려할 것
    }
}
