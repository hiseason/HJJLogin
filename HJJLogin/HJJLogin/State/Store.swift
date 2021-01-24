//
//  Store.swift
//  HJJLogin
//
//  Created by 郝旭姗 on 2021/1/18.
//

import Foundation
import Combine

//Store 负责刷新 AppState
class Store: ObservableObject {
    // 将 Store 声明为 ObservableObject，这样我们就可以在 View 里通过 @ObservedObject 或者 @EnvironmentObject 来订阅它了。
    // @Published 修饰的属性一更新就会通知订阅者
    @Published var appState = AppState()
    var disposeBag = [AnyCancellable]()
    
    //处理某个 AppAction，并返回新的 AppState
    //只在 Store 中更改 AppState
    func executeAction(action: AppAction) {
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        
        var loginVM: LoginViewModel?
        
        switch action {
        case .login(let username, let password):
            guard !appState.isLogging else {
                break
            }
            appState.isLogging = true
            
            loginVM = LoginViewModel(username:username,password: password)
            loginVM!.login(in: self)
        
        case .loggedIn(let result):
            appState.isLogging = false
            switch result {
            case .success(let user):
                appState.user = user
            case .failure(let error):
                appState.loginError = error
            }
            
        case .logout:
            appState.user = nil
            
        case .emailValid(valid: let valid):
            appState.isEmailValid = valid
        }
        
    }
    
    init() {
        setupObservers()
    }
    
    func setupObservers() {
        appState.accountChecker.isEmailValid.sink { isValid in
            self.executeAction(action: .emailValid(valid: isValid))
        }.store(in: &disposeBag)
    }
    
}
