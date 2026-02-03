//
//  RegisterView.swift
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var vm = AppDIContainer.shared.makeRegisterViewModel()
    @EnvironmentObject var coordinator: AppCoorinator
    
    var body: some View {
        VStack {
            Button {
                coordinator.goToLogin()
            } label: {
                Text("Back")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            
            Text("Create account")
                .font(.largeTitle.bold())
                .padding(.top, 60)
            
            VStack {
                TextField("Name", text: $vm.name)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                TextField("Surname", text: $vm.surname)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
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
                SecureField("Confirm password", text: $vm.confirmPassword)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                Button {
                    Task {
                        await vm.register()
                    }
                    coordinator.goToNews()
                } label: {
                    if vm.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
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
    RegisterView()
}
