import SwiftUI
import ComposableArchitecture

@Reducer
struct MovieListStore {
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    @ObservableState
    struct State: Equatable {
        var movies: [Movie] = []
    }
    
    enum Action {
        case fetchMovies
        case movieResponse(Result<[Movie], Error>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchMovies:
                return .run { send in
                    do {
                        let movies = try await self.movieRepository.nowPlayingMovies()
                        await send(.movieResponse(.success(movies.movies)))
                    } catch {
                        await send(.movieResponse(.failure(error)))
                    }
                }
            case .movieResponse(.success(let movies)):
                state.movies = movies
                return .none
            case .movieResponse(.failure(_)):
                return .none
            }
        }
    }
}

struct MovieListView: View {
    let store: StoreOf<MovieListStore>
    
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
                    }
                }
                .padding()
            }
            .background(MovieColors.background)
            .navigationTitle("Movies")
            .onAppear {
                store.send(.fetchMovies)
            }
        }
        .tint(MovieColors.accent)
    }
}

enum MovieColors {
    static let background = Color(red: 0.98, green: 0.96, blue: 0.94)
    static let accent = Color(red: 1.0, green: 0.45, blue: 0.40)
    static let card = Color.white
    static let warning = Color(red: 1.0, green: 0.70, blue: 0.30)
    static let text = Color(red: 0.20, green: 0.20, blue: 0.25)
    static let secondaryText = Color(red: 0.50, green: 0.50, blue: 0.55)
    static let shadow = Color.black.opacity(0.08)
}
