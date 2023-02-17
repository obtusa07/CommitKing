//
//  UIImageView+extension.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/17.
//

import UIKit


extension UIImageView {
    
    /// image를 다운받는 extension
    /// - Parameters:
    ///   - url: avatarURL 혹은 gravatarID 중 하나를 사용한다. 둘다 받아서 avatar가 nil이면 gravatar를 사용하는 방법도 있다.
    //
    func imageDownload(urlString: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        if let cacheImage = Cache.imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async() { [weak self] in
                self?.contentMode = mode
                self?.image = cacheImage
            }
        }
        else {
            guard let url = URL(string: urlString) else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, (200..<300).contains(httpURLResponse.statusCode),
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else {
                    print("Download image fail : \(url)")
                    return
                }
                
                DispatchQueue.main.async() { [weak self] in
                    print("Download image success \(url)")
                    
                    self?.contentMode = mode
                    self?.image = image
                }
            }.resume()
        }
    }
}
