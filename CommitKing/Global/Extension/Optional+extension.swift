//
//  Optional+extension.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/19.
//

import Foundation

extension Optional<String> {
    // MARK: String에 대해 nil 뿐만 아니라 빈 문자열인 경우에도 처리하게 만들어줌
    var isNilOrEmpty: Bool {
        return self == nil || self == ""
    }
    // MARK: optionalSTring ?? "" 와 같은 문장을 그냥 orEmpty라는 프로퍼티로 대체 가능
    var orEmpty: String {
        self ?? ""
    }
}
