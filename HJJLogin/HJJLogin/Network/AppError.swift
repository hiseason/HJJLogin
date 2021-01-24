//
//  AppError.swift
//  HJJLogin
//
//  Created by 郝旭姗 on 2021/1/20.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String { description }
    case userNotExist
    case passwordWrong
    case fileError
    
}

extension AppError {
    var description: String {
        switch self {
        case .userNotExist: return "用户名不存在"
        case .passwordWrong: return "密码错误"
        case .fileError: return "文件操作错误"
        }
    }
}

