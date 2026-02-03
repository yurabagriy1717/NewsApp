//
//  MainTabView.swift
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            FavouritesViews()
                .tabItem {
                    Label("Favourites", systemImage: "heart")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}


#Preview {
    MainTabView()
}
