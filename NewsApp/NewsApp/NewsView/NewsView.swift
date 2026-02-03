//
//  NewsView.swift
//

import SwiftUI

struct NewsView: View {
    @StateObject private var vm = AppDIContainer.shared.makeNewsViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                TextField("search", text: $vm.searchQuery)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                CategoriesView(vm: vm)
                NewsListVIew(vm: vm)
                
                    .background(Color(.systemGroupedBackground))
                    .navigationTitle("News")
                    .navigationBarTitleDisplayMode(.large)
                //                .searchable(text: $vm.searchQuery)
                //                .onChange(of: vm.searchQuery) {
                //                    Task {
                //                        guard !vm.searchQuery.isEmpty else { return }
                //                        await vm.fetchNews(for: vm.searchQuery)
                //                    }
                //                }
            }
            if vm.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView("Завантаження...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                .transition(.opacity)
            }
        }
        .alert("Error", isPresented: .constant(vm.error != nil )) {
            Button("OK", role: .cancel) { vm.error = nil }
        } message: {
            Text(vm.error ?? "")
        }
    }
}


#Preview {
    NavigationStack {
        NewsView()
    }
}
