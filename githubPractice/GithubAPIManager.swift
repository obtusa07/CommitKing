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
    // 현재 ViewController에서 관리
    
    // MARK: URL을 Scene에서 받아서 POST로 보내고 Token 받아오기
    // Json으로 보내면 아래와 같은 놈이 나올거
    // Accept: application/json
//    {
//      "access_token":"tesaknlsdf;osdjfobds;fbsnd;bsdfiansbdf",
//      "scope":"repo,gist",
//      "token_type":"bearer"
//    }
    func tokenGenerate(url: URL) {
        let codeAndState = url.absoluteString.components(separatedBy: "code=").last ?? ""
        // 7f9496b62db3ed929b30&state=1CD18A2C-E17A-40AE-846B-9B8DA10A0D2F
        let code = codeAndState.components(separatedBy: "&state=").first ?? ""
        let state = codeAndState.components(separatedBy: "&state=").last ?? ""
        print(code)
        print(state)
        
    
        
        
        // UserDefaults로 토큰을 저장하기
    }
    
    func logout() {
        // UserDefaults로 토큰 삭제
        // 여기서 View를 최초 화면으로 가게 하는게 맞나? 고려할 것
    }
}
