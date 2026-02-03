//
//  LoginView.swift
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var vm = AppDIContainer.shared.makeLoginViewModel()
    @EnvironmentObject var coordinator: AppCoorinator

    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle.bold())
                .padding(.top, 60)
            
            VStack {
                TextField("Email", text: $vm.email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                SecureField("Password", text: $vm.password)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button {
                    Task { 
                        await vm.login()
                    }
                } label: {
                    if vm.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Log in")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                Button {
                    coordinator.goToRegister()
                } label: {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear {
            vm.coordinator = coordinator
        }
    }
}


#Preview {
    LoginView()
}

