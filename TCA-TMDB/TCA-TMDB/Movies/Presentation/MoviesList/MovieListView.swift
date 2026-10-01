import SwiftUI
import ComposableArchitecture


struct MovieListView: View {
    @Bindable var store: StoreOf<MovieListStore>
    
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(store.movies) { movie in
                        MovieCardView(movie: movie)
                            .onAppear {
                                if shouldLoadNextPage(movie: movie) {
                                    store.send(.loadNextPage)
                                }
                            }
                    }
                }
                .padding()
            }
            .id(store.movies.first?.id)
            .background(MovieColors.background)
            .navigationTitle("Now Playing")
            .onAppear {
                store.send(.fetchMovies)
            }
        }
        .searchable(text: $store.searchQuery.sending(\.searchQueryChanged))
        .task(id: store.searchQuery) {
            try? await Task.sleep(for: .milliseconds(300))
            await store.send(.searchDebounced).finish()
        }
    }
    
    private func shouldLoadNextPage(movie: Movie) -> Bool {
        guard let index = store.movies.firstIndex(of: movie),
              store.hasMorePages else {
            return false
        }
        
        return index == store.movies.count - 4
    }
}
