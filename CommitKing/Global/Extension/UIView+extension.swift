//
//  UIView+extension.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/19.
//

import UIKit

extension UIView {
    // MARK: Subviews를 한줄에서 선언 가능
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
