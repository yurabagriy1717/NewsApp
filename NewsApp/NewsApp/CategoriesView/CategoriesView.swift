//
//  CategoriesView.swift
//

import SwiftUI

struct CategoriesView: View {
    @ObservedObject var vm: NewsViewModel
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(vm.categories, id: \.self) { category in
                        Text(category)
                            .font(.subheadline)
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .background(
                                vm.selectedCategory == category
                                ? Color.blue.opacity(0.2)
                                : Color(.systemGray6)
                            )
                            .foregroundColor(
                                vm.selectedCategory == category
                                ? .blue
                                : .primary
                            )
                            .cornerRadius(12)
                            .animation(.easeInOut(duration: 0.2), value: vm.selectedCategory)
                            .onTapGesture {
                                vm.selectedCategory = category
                                Task {
                                    await vm.fetchNewsCategory(for: vm.selectedCategory)
                                }
                            }
                    }
                }
            }
            if isLoading {
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
        .onReceive(vm.loadingPublisher.receive(on: DispatchQueue.main)) { loading in
            withAnimation {
                isLoading = loading
            }
        }
    }
}


#Preview {
    CategoriesView(vm: NewsViewModel(network: NetworkServiceImp(), newsModelBuilder: NewsBuilder(), savedArticlesService: SavedArticleServiceImpl(tokenStorage: TokenStorageImp())))
}
