//
//  EmailCheckingRequest.swift
//  HJJLogin
//
//  Created by 郝旭姗 on 2021/1/20.
//

import Foundation
import Combine

struct EmailCheckingRequest {
    let email: String

    var publisher: AnyPublisher<Bool, Never> {
        Future<Bool, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                if self.email.lowercased() == "haojj@163.com" {
                    promise(.success(false))
                } else {
                    promise(.success(true))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
