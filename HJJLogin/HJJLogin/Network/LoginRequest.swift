//
//  LoginRequest.swift
//  HJJLogin
//
//  Created by 郝旭姗 on 2021/1/18.
//

import Foundation
import Combine

struct LoginRequest {
    
    let username: String
    let password: String
    
    var publisher: AnyPublisher<User,AppError> {
        Future { promise in
            DispatchQueue.global()
                .asyncAfter(deadline: .now() + 2) {
                    if (self.username == "haojj" && self.password == "password") {
                        let user = User(username: username, password: password)
                        promise(.success(user))
                    }else if (self.username != "password"){
                        promise(.failure(.userNotExist))
                    }else if (self.password != "password") {
                        promise(.failure(.passwordWrong))
                    }
                }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        //Cannot convert return expression of type 'Future<Output, Failure>' to return type 'AnyPublisher<User, AppError>'

    }
}


struct User: Codable {
    var username: String
    var password: String
}



