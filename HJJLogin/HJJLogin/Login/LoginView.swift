//
//  LoginView.swift
//  HJJLogin
//
//  Created by 郝旭姗 on 2021/1/18.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    @EnvironmentObject var store: Store
    private var appState: AppState { //计算型属性
        store.appState
    }
    
    private var accountCheckerBinding: Binding<AppState.AccountChecker> {
        $store.appState.accountChecker
    }
        
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            Form {
               loginSection
            }
        }
        .alert(item: $store.appState.loginError) { error in
            Alert(title: Text(error.description))
        }
    }
    
    var loginSection: some View {
        Section {
            if appState.user == nil {
                Picker(selection: accountCheckerBinding.accountBehavior, label: Text("")) {
                    ForEach(AppState.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                TextField("用户名", text: accountCheckerBinding.username)
                    .foregroundColor(appState.isEmailValid ? .green : .red)
                SecureField("密码", text: accountCheckerBinding.password)
                
                if appState.accountChecker.accountBehavior == .register {
                    SecureField("确认密码", text: accountCheckerBinding.verifyPassword)
                }
                
                if appState.isLogging {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }else {
                    Button(action: {
                        self.store.executeAction(action: .login(username:appState.accountChecker.username,password: appState.accountChecker.password))
                        
                    }, label: {
                        Text(appState.accountChecker.accountBehavior == .register ? "注册" : "登录")
                            .foregroundColor(.black)
                    })
                }

            }else {
                Text(appState.user!.username)
                Button("注销") {
                    self.store.executeAction(action: .logout)
                }
            }
            
        }
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
