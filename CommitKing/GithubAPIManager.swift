//
//  GithubAPIManager.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/05.
//

import Foundation
import Security
import UIKit

class GithubAPIManager {
//    static let shared = GithubAPIManager()
    
    static func loginButtonClicked() {
        let uuid = UUID().uuidString
        print("오리지널 uuid: \(uuid)")
        guard var components = URLComponents(string: GithubConfig.CODEURL) else {
            preconditionFailure("GithubConfig is broken. Fail to load CODEURL")
        }
        components.queryItems = [
            URLQueryItem(name: "client_id", value: GithubConfig.CLIENT_ID),
            URLQueryItem(name: "scope", value: GithubConfig.SCOPE),
            URLQueryItem(name: "redirect_uri", value: GithubConfig.REDIRECT_URI_LOGIN),
            URLQueryItem(name: "state", value: uuid)
        ]
        guard let url = components.url else {
            preconditionFailure("GithubConfig is broken. Fail to make URL")
        }
        UserDefaults.standard.set(uuid, forKey: "LoginCodeState")
        UIApplication.shared.open(url)
    }
    
    // MARK: URL을 Scene에서 받아서 POST로 보내고 Token 받아오는 메서드
    static func tokenGenerate(url: URL) {
        guard let codeAndState = url.absoluteString.components(separatedBy: "code=").last else {
            preconditionFailure("Fail to find code in redirected url ")
        }
        guard let code = codeAndState.components(separatedBy: "&state=").first else {
            preconditionFailure("Cant't separeated code")
        }
        guard let state = codeAndState.components(separatedBy: "&state=").last else {
            preconditionFailure("Cant't separeated state")
        }
        
        // MARK: --"state" string prevent "cross site request forgery(CSRF)" attack
        let original = UserDefaults.standard.string(forKey: "LoginCodeState")
        if original != state {
            fatalError("CSRF 공격이 감지되었습니다.")
        }
        UserDefaults.standard.removeObject(forKey: "LoginCodeState")
        
        
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
                let token = try decoder.decode(GithubToken.self, from: data)
                // MARK: KeyChain에 토큰 저장. encrytion 불가 문제로 UserDefaults 대신 채택
                GithubAPIManager.saveTokenInKeychain(token: token)
            } catch {
                preconditionFailure("Can't decode Token json Data")
            }
        }.resume()
    }
    
    static func saveTokenInKeychain(token: GithubToken) {
        let tokenData = token.accessToken.data(using: .utf8)
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: Bundle.main.bundleIdentifier!,
                                    kSecAttrAccount as String: "TokenService",
                                    kSecValueData as String: tokenData!]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("Successfully added to keychain.")
            UserDefaults.standard.set(true, forKey: "isTokenAvailable")
        } else {
            if let error: String = SecCopyErrorMessageString(status, nil) as String? {
                print(error)
                // MARK: 이 토큰이 어떤 기한을 가지는지 모르겠다. 토큰이 유효하지 않게 되면 여기서 해당 코드에 대한 error 처리를 해줘야 한다.
            }
        }
    }
    
    static func findTokenInKeychain() -> String {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrService as String: Bundle.main.bundleIdentifier!,
                                kSecAttrAccount as String: "TokenService",
                                 kSecMatchLimit as String: kSecMatchLimitOne,
                           kSecReturnAttributes as String: true,
                                 kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess {
            print("Successfully extracted to Keychain")
        } else {
            if let error: String = SecCopyErrorMessageString(status, nil) as String? {
                print(error)
            }
        }
        guard let existingItem = item as? [String : Any],
              let tokenData = existingItem[kSecValueData as String] as? Data,
              let token = String(data: tokenData, encoding: String.Encoding.utf8) else {
            preconditionFailure("Failed to load token data to Keychain")
        }
        return token
    }
    
    static func logout() {
        // MARK: Keychain "TokenService"의 Token 데이터 삭제, UserDefaults의 토글 false
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: Bundle.main.bundleIdentifier!,
                                    kSecAttrAccount as String: "TokenService"]
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Successfully deleted Token to Keychain")
            UserDefaults.standard.set(false, forKey: "isTokenAvailable")
            // 여기서 초기화면으로 보내버리기
        } else {
            if let error: String = SecCopyErrorMessageString(status, nil) as String? {
                print(error)
            }
        }
    }
}
