//
//  AppState.swift
//  HJJLogin
//
//  Created by 郝旭姗 on 2021/1/18.
//

import Foundation
import Combine

struct AppState {
    enum AccountBehavior: CaseIterable {
        case register, login
    }
        
    var isLogging = false
    var loginError: AppError?
    
    @FileStorage(directory: .documentDirectory, fileName: "user.json")
    var user: User?
    
    var isEmailValid: Bool = false

    class AccountChecker {
        @Published var accountBehavior = AccountBehavior.login
        @Published var username = ""
        @Published var password = ""
        @Published var verifyPassword = ""
        
        var isEmailValid: AnyPublisher<Bool, Never> {
            let remoteVerify = $username
                .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                .removeDuplicates()
                .flatMap { email -> AnyPublisher<Bool, Never> in
                    let validEmail = email.isValidEmailAddress
                    let canSkip = self.accountBehavior == .login
                    switch (validEmail, canSkip) {
                    case (false, _):
                        return Just(false).eraseToAnyPublisher()
                    case (true, false):
                        return EmailCheckingRequest(email: email)
                            .publisher
                            .eraseToAnyPublisher()
                    case (true, true):
                        return Just(true).eraseToAnyPublisher()
                    }
                }
            return remoteVerify.eraseToAnyPublisher()
        }
        

    }

    var accountChecker = AccountChecker()
}

extension AppState.AccountBehavior {
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}
