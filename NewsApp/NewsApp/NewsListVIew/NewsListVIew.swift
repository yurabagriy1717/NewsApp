//
//  NewsListVIew.swift
//

import SwiftUI

struct NewsListVIew: View {
    @EnvironmentObject var coordinator: AppCoorinator
    @ObservedObject var vm: NewsViewModel
    
    var body: some View {
        if vm.isLoading {
            ProgressView("Downloading...")
                .padding(.top, 50)
        }
        else {
            ScrollView {
                LazyVStack {
                    ForEach(vm.filteredNews) { article in
                        Button {
                            coordinator.push(.detailsNews(article: article))
                        } label: {
                            NewsCardView(article: article)
                        }

                    }
                }
                .padding(.vertical, 10)
            }
            .refreshable {
                await vm.fetchNews(for: vm.searchQuery)
            }
        }
    }
}

#Preview {
    NewsListVIew(vm: NewsViewModel(network: NetworkServiceImp()
                                   , newsModelBuilder: NewsBuilder(), savedArticlesService: SavedArticleServiceImpl(tokenStorage: TokenStorageImp()) )
    )
}

