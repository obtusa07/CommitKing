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
        guard var components = URLComponents(string: GithubConfig.CODEURL) else {
            preconditionFailure("GithubConfig is broken. Fail to load CODEURL")
        }
        components.queryItems = [
            URLQueryItem(name: "client_id", value: GithubConfig.CLIENTID),
            URLQueryItem(name: "scope", value: GithubConfig.SCOPE),
            URLQueryItem(name: "redirect_uri", value: GithubConfig.REDIRECTURILOGIN),
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
        // MARK: - "state" string prevent "cross site request forgery(CSRF)" attack
        let original = UserDefaults.standard.string(forKey: "LoginCodeState")
        if original != state {
            fatalError("CSRF 공격이 감지되었습니다.")
        }
        UserDefaults.standard.removeObject(forKey: "LoginCodeState")
        let param = ["client_id": GithubConfig.CLIENTID, "client_secret": GithubConfig.CLIENTSECRET,
                     "code": code, "redirect_uri": GithubConfig.REDIRECTURILOGIN]
        let paramData = try? JSONSerialization.data(withJSONObject: param, options: [])
        guard let url = URL(string: GithubConfig.TOKENURL) else {
            preconditionFailure("GithubConfig is broken. Fail to load TOKENURL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let paramData = paramData else {
            preconditionFailure("make paramData is failed")
        }
        request.httpBody = paramData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        let configuration = URLSessionConfiguration.ephemeral // Code는 Credential이라 판단
        
        URLSession(configuration: configuration).dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                preconditionFailure("Failed to receive Token response \(String(describing: response))")
            }
            guard let data = data else {
                preconditionFailure("Failed to receive Token Data")
            }
            do {
                let decoder = JSONDecoder()
                let token = try decoder.decode(GithubToken.self, from: data)
                // KeyChain에 토큰 저장. encrytion 불가 문제로 UserDefaults 대신 채택
                GithubAPIManager.saveTokenInKeychain(token: token)
                
                // UserDefaults에 유저 데이터를 저장해주자
                saveMyInfo()
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
                if error == "The specified item already exists in the keychain." {
                    UserDefaults.standard.set(true, forKey: "isTokenAvailable")
                }
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
        guard let existingItem = item as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data,
              let token = String(data: tokenData, encoding: String.Encoding.utf8) else {
            preconditionFailure("Failed to load token data to Keychain")
        }
        return token
    }
    /// 전반적인 User의 정보를 모두 받아오는 메서드
    static func saveMyInfo() {
        // TODO: getMyInfo는 로그인할 때 수행하고 화면에 반영하는 것까지 완료한 상태에서 다음 화면으로 가게 만들기
        guard let url = URL(string: GithubUrls.MYINFO) else {
            preconditionFailure("GithubConfig is broken. Fail to load TOKENURL")
        }
        let token = findTokenInKeychain()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let configuration = URLSessionConfiguration.default
        URLSession(configuration: configuration).dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                preconditionFailure("Failed to receive Token response \(String(describing: response))")
            }
            guard let data = data else {
                preconditionFailure("Failed to receive Token Data")
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(GithubMyInfo.self, from: data)
                UserDefaults.standard.set(try? PropertyListEncoder().encode(result), forKey: "GithubMyInfo")
                print("User data is saved")
            } catch {
                preconditionFailure("Can't decode Token json Data")
            }
        }.resume()
    }
    
    static func totalCommits(username: String, days: Int, completion: @escaping (Int?, Error?) -> Void) {
        // MARK: days로 0이 들어가면 오늘 날짜, days가 음수면 Error
        if days < 0 {
            preconditionFailure("Days must be natural number (0 or positive integer)")
        }
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // MARK: timeRange로 기간을 산정함
        let timeRange = DateInterval(start: Calendar.current.date(byAdding: .day, value: -days, to: now)!,
                                     end: now)
        let since = dateFormatter.string(from: timeRange.start)
        let until = dateFormatter.string(from: timeRange.end)
        guard var components = URLComponents(string: GithubConfig.COMMITURL) else {
            preconditionFailure("GithubConfig is broken. Fail to load CODEURL")
        }
        components.queryItems = [
            URLQueryItem(name: "q", value: "author:\(username)+committer-date:\(since)..\(until)")
        ]
        guard let url = components.url else {
            preconditionFailure("GithubConfig is broken. Fail to make URL")
        }
        let token = findTokenInKeychain()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let configuration = URLSessionConfiguration.default
        URLSession(configuration: configuration).dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                preconditionFailure("Failed to receive Token response \(String(describing: response))")
            }
            guard let data = data else {
                preconditionFailure("Failed to receive Token Data")
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(GithubCommitsConfig.self, from: data)
                let count = result.totalCount
                completion(count, nil)
            } catch let error {
                completion(nil, error)
            }
        }.resume()
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

/*
 json 뽑아서 보는 용도 테스트 코드
 if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
    if let name = json["name"] as? String {
        print(name) // hyeon
    }
 }
 */
