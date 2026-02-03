//
//  NewsCardVIew.swift
//

import SwiftUI

struct NewsCardView: View {
    let article: NewsModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
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
                .lineLimit(2)
            Text(article.descprition ?? "")
                .font(.caption)
                .foregroundColor(.secondary)
            
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 4, y: 3)
        .padding(.horizontal)
    }
}

#Preview {
    NewsCardView(
        article: NewsModel(
            author: "esgverfvcesa",
            title: "Apple презентувала MacBook Pro M3 💻",
            descprition: "Швидший, довше тримає батарею.",
            url: "gsvearfca",
            urlToImage: "https://picsum.photos/400/200?1",
            publishedAt: "2025-11-03T08:00:00Z",
            sourceName: "gfdvsrfvcer"
        )
    )
}
