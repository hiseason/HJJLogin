//
//  AppAction.swift
//  HJJLogin
//
//  Created by 郝旭姗 on 2021/1/18.
//

import Foundation

enum AppAction {
    case login(username:String, password: String)
    case loggedIn(result: Result<User,AppError>)
    case logout
    case emailValid(valid: Bool)
}
