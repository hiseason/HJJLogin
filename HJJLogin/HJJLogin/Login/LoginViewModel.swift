//
//  LoginViewModel.swift
//  HJJLogin
//
//  Created by 郝旭姗 on 2021/1/18.
//

import Foundation
import Combine

struct LoginViewModel {
    var username: String = ""
    var password: String = ""
    
    func login(in store: Store)  {
        //这个返回值是一个 AnyCancellable，在它被释放时，cancel() 会被自动调用，导致订阅取消。上面的代 码里发生的正是这一情况:因为我们没有存储这个值，它在创建后就立即被释放掉， 导致订阅取消。如果我们不想要这个异步操作在完成之前就被取消掉，就需要想办 法持有 sink 的返回值，直到异步操作完成。为了达到这一点，可以添加一个 SubscriptionToken 来持有 AnyCancellable
        let token = SubscriptionToken()
        LoginRequest(username: username, password: password)
            .publisher
            .sink { (complete) in
                if case .failure(let error) = complete {
                    print(error.description)
                    store.executeAction(action: .loggedIn(result: .failure(error)))
                    //isLogining = false
                }
                token.unseal()

            } receiveValue: { (user) in
                print("用户名: \(user.username) 密码: \(user.password)")
                store.executeAction(action: .loggedIn(result: .success(user)))
                //appState.isLogging = true
                //isLogining = false
            }
            .seal(in: token)
    }

}


class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    //seal 会把当前的 AnyCancellable 值 “封印” 到 SubscriptionToken 中去
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}

/*
 1. 创建一个 SubscriptionToken 值备用，它需要存活到订阅的异步事件结束。
 2. 在 sink 订阅后，把返回的 AnyCancellable 存放到 token 里。
 3. 调用 token 的 unseal 方法将 AnyCancellable 释放。在这里，unseal 中里将 cancellable 置为 nil 的操作其实并不是必须的，因为一旦 token 离开作用域 被释放后，它其中的 cancellable 也会被释放，从而导致订阅资源的释放。这 里的关键是利用闭包，让 token 本身存活到事件结束，以保证订阅本身不被取消。
 */
