//
//  NewsDetailsView.swift
//

import SwiftUI

struct NewsDetailsView: View {
    @StateObject private var vm: NewsDetailsViewModel
    
    init(article: NewsModel) {
        _vm = StateObject(
            wrappedValue: AppDIContainer.shared
                .makeNewsDetailsViewModel(article: article)
        )
    }
    
    var body: some View {
        VStack {
            ScrollView {
                AsyncImage(url: URL(string: vm.article.urlToImage ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                Text(vm.article.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                HStack {
                    Text(vm.article.author ?? "")
                    Spacer()
                    Text(vm.article.sourceName)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                Text(vm.article.publishedAt)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                Text(vm.article.descprition ?? "")
                    .font(.body)
                    .padding(.horizontal)
                    .padding(.top, 8)
                Button {
                    Task {
                        await vm.savedArticles()
                    }
                } label: {
                    Image(systemName: "heart")
                }
                .frame(width: 50, height: 50)
            }
        }
    }
}


#Preview {
    NewsDetailsView(
        article: NewsModel(
            author: "Apple",
            title: "MacBook Pro M3",
            descprition: "New Apple chip",
            url: "https://apple.com",
            urlToImage: "https://picsum.photos/400/200",
            publishedAt: "2025-01-01",
            sourceName: "Apple News"
        )
    )
}
