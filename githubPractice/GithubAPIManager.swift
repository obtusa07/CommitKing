//
//  GithubAPIManager.swift
//  githubPractice
//
//  Created by Taehwan Kim on 2023/02/05.
//

import Foundation
import Security

class GithubAPIManager {
    static let sharedInstance = GithubAPIManager()
    // MARK: 이곳으로 Code 받는 로그인 시도 옮겨오기
    // 현재 ViewController에서 관리
    
    // MARK: URL을 Scene에서 받아서 POST로 보내고 Token 받아오기
    // Json으로 보내면 아래와 같은 놈이 나올거
    // Accept: application/json
    //    {
    //      "access_token":"tesaknlsdf;osdjfobds;fbsnd;bsdfiansasdfasdfasdfsabdf",
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
        print(code)
        guard let state = codeAndState.components(separatedBy: "&state=").last else {
            preconditionFailure("Cant't separeated state")
        }
        // TODO: CSRF 공격을 방어하기 위하여 1차 통신 때 uuid와 돌아온 state가 같지 않으면 과정을 중단할 것. 순위가 낮다
        //        if state == ViewController.uuid {
        //            print("something is good")
        //        }
        
        //        guard var components = URLComponents(string: GithubConfig.TOKENURL) else {
        //            preconditionFailure("GithubConfig is broken. Fail to load TOKENURL")
        //        }
        
        //        components.queryItems = [
        //            URLQueryItem(name: "client_id", value: GithubConfig.CLIENT_ID),
        //            URLQueryItem(name: "client_secret", value: GithubConfig.CLIENT_SECRET),
        //            URLQueryItem(name: "code", value: code),
        //            URLQueryItem(name: "redirect_uri", value: GithubConfig.REDIRECT_URI_LOGIN),
        //            URLQueryItem(name: "state", value: state)
        //        ]
        
        let param = ["client_id": GithubConfig.CLIENT_ID, "client_secret": GithubConfig.CLIENT_SECRET,
                     "code": code, "redirect_uri":GithubConfig.REDIRECT_URI_LOGIN]
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])

        guard let url = URL(string: GithubConfig.TOKENURL) else {
            preconditionFailure("GithubConfig is broken. Fail to load TOKENURL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        let configuration = URLSessionConfiguration.ephemeral // Code는 Credential이라 판단

        URLSession(configuration: configuration).dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                preconditionFailure("Failed to receive Token response \(String(describing: response))")
            }
            guard let data = data else {
                preconditionFailure("Failed to receive Token Data")
            }
            do {
                let decoder = JSONDecoder()
                let token = try decoder.decode(GithubTokenParser.self, from: data)
                // MARK: KeyChain에 토큰 저장. encrytion 불가 문제로 UserDefaults 대신 채택
                let tokenData = token.accessToken.data(using: .utf8)
                let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                            kSecAttrService: Bundle.main.bundleIdentifier!,
                                            kSecAttrAccount: "TokenService",
                                            kSecValueData: tokenData!]

                let status = SecItemAdd(query as CFDictionary, nil)
                if status == errSecSuccess {
                    print("Successfully added to keychain.")
                } else {
                    if let error: String = SecCopyErrorMessageString(status, nil) as String? {
                        print(error)
                    }
                }
//                // Retrieve token from Keychain
//                var queryResult: AnyObject?
//                let retrieveQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
//                                                    kSecAttrAccount as String: "token_key",
//                                                    kSecReturnData as String: true,
//                                                    kSecMatchLimit as String: kSecMatchLimitOne]
//                let retrieveStatus = SecItemCopyMatching(retrieveQuery as CFDictionary, &queryResult)
//
//                if retrieveStatus == errSecSuccess, let retrievedTokenData = queryResult as? Data,
//                    let retrievedToken = String(data: retrievedTokenData, encoding: .utf8) {
//                    print("Retrieved token: \(retrievedToken)")
//                }
            } catch {
                preconditionFailure("Can't decode Token json Data")
            }
        }.resume()
        
        
    }
    
    func logout() {
        // UserDefaults로 토큰 삭제
        // 여기서 View를 최초 화면으로 가게 하는게 맞나? 고려할 것
    }
}
