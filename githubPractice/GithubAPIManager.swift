//
//  GithubAPIManager.swift
//  githubPractice
//
//  Created by Taehwan Kim on 2023/02/05.
//

import Foundation

class GithubAPIManager {
    static let sharedInstance = GithubAPIManager()
    // MARK: 이곳으로 Code 받는 로그인 시도 옮겨오기
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
        guard let codeAndState = url.absoluteString.components(separatedBy: "code=").last else {
            preconditionFailure("Fail to find code in redirected url ")
        }
        
        // 7f9496b62db3ed929b30&state=1CD18A2C-E17A-40AE-846B-9B8DA10A0D2F
        guard let code = codeAndState.components(separatedBy: "&state=").first else {
            preconditionFailure("Cant't separeated code")
        }
        
        guard let state = codeAndState.components(separatedBy: "&state=").last else {
            preconditionFailure("Cant't separeated state")
        }
        // TODO: CSRF 공격을 방어하기 위하여 1차 통신 때 uuid와 돌아온 state가 같지 않으면 과정을 중단할 것. 순위가 낮다
//        if state == ViewController.uuid {
//            print("something is good")
//        }
        
        guard var components = URLComponents(string: GithubConfig.TOKENURL) else {
            preconditionFailure("GithubConfig is broken. Fail to load TOKENURL")
        }
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: GithubConfig.CLIENT_ID),
            URLQueryItem(name: "client_secret", value: GithubConfig.CLIENT_SECRET),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: GithubConfig.REDIRECT_URI_LOGIN),
            URLQueryItem(name: "state", value: state)
        ]
        
        guard let url = components.url else {
            preconditionFailure("Code for token url Error")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                print("response: \(String(describing: response))")
                return
            }
            
            guard let data = data else {
                return
            }
            guard let result = String(data: data, encoding: .utf8) else {
                preconditionFailure("Fail to generate Token result")
            }
            print(result) // "access_token=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&scope=read%3Auser%2Cuser%3Aemail&token_type=bearer"
            
            // MARK: UserDefaults에 토큰 저장
            UserDefaults.standard.object(forKey: <#T##String#>)
        }
        task.resume()
    
    
    }
    
    func logout() {
        // UserDefaults로 토큰 삭제
        // 여기서 View를 최초 화면으로 가게 하는게 맞나? 고려할 것
    }
}
