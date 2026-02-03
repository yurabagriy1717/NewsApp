//
//  FavouritesViews.swift
//

import SwiftUI

struct FavouritesViews: View {
    @StateObject private var vm = AppDIContainer.shared.makeFavouritesViewModel()
    
    var body: some View {
        List() {
            ForEach(vm.articles) { article in
                VStack {
                    AsyncImage(url: URL(string: article.image_url)) {
                        image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    Text(article.title)
                        .font(.headline)
                    if let description = article.description {
                        Text(description)
                            .font(.caption)
                    }
                }
            }
//            .onDelete
        }
        .task {
            await vm.loadArticles()
            
        }
    }
}

#Preview {
    FavouritesViews()
}
