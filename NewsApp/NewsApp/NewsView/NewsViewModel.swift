//
//  NewsViewModel.swift
//

import Foundation
import Combine

@MainActor
class NewsViewModel:ObservableObject {
    @Published var newsDomainModel: [NewsModel] = []
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    @Published var selectedCategory: String = "Technology"
    
    let errorPublisher = PassthroughSubject<String, Never>()
    let loadingPublisher = CurrentValueSubject<Bool, Never>(false)
    
    private var cancellables = Set<AnyCancellable>()
    
    let categories: [String] = ["business","entertainment", "general", "health", "science", "sports", "technology", "all"]
    
    private let network: NetworkService
    private let newsModelBuilder: NewsBuildable
    private let savedArticlesService: SavedArticleService
    
    init(
        network: NetworkService,
        newsModelBuilder: NewsBuildable,
        savedArticlesService: SavedArticleService
    ) {
        self.network = network
        self.newsModelBuilder = newsModelBuilder
        self.savedArticlesService = savedArticlesService
        
        $searchQuery
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                Task {
                    guard !query.isEmpty else { return }
                    await self.fetchNews(for: query)
                }
            }
            .store(in: &cancellables)
        
        loadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] loading in
                self?.isLoading = loading
            }
            .store(in: &cancellables)
        
        errorPublisher
            .receive(on: RunLoop.main)
            .sink {[weak self] error in
                self?.error = error
            }
            .store(in: &cancellables)
        
        Task {
            await fetchNews()
        }
        
        
    }
    
    private func mapNews(serviceModel: NewsResponse) -> [NewsModel] {
        newsModelBuilder.mapNews(response: serviceModel)
    }
    
    func fetchNews(for query: String? = nil) async {
        do {
            loadingPublisher.send(true)
//            network.publisher.sink { [weak self] newData in
//                print(newData)
//            }
//            network.fetchNews(for: "gfdgdf")

            let newsServiceModel = try await network.fetchNews(for: query ?? "")
            let newsDomainModel = mapNews(serviceModel: newsServiceModel)
            await MainActor.run {
                self.newsDomainModel = newsDomainModel
            }
            loadingPublisher.send(false)
        }
        catch {
            await MainActor.run {
                self.loadingPublisher.send(false)
                self.errorPublisher.send("Error search news")
                print("❌ Fetch error:", error)
                dump(error)
            }
        }
    }
    
    func fetchNewsCategory(for category: String? = nil) async {
        do {
            loadingPublisher.send(true)
            let newsServiceModel = try await network.fetchNewsCategory(for: category ?? "")
            let newsDomainModel = mapNews(serviceModel: newsServiceModel)
            await MainActor.run {
                self.newsDomainModel = newsDomainModel
            }
            loadingPublisher.send(false)
        }
        catch {
            self.loadingPublisher.send(false)
            print("❌ Fetch error:", error)
            dump(error)
        }
    }
    
    var filteredNews: [NewsModel] {
        guard !searchQuery.isEmpty else {
            return newsDomainModel
        }
        return newsDomainModel.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
    }
}
