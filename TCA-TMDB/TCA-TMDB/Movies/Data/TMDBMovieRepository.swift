import Foundation

public struct TMDBMovieRepository: MovieRepository {
    private let networkClient: any NetworkClient
    private let configuration: TMDBConfiguration

    public init(
        networkClient: any NetworkClient = URLSessionNetworkClient(),
        configuration: TMDBConfiguration
    ) {
        self.networkClient = networkClient
        self.configuration = configuration
    }

    public func searchMovies(query: String, page: Int) async throws -> MoviePage {
        try await fetchPage(for: .search(query: query, page: page))
    }

    public func nowPlayingMovies(page: Int) async throws -> MoviePage {
        try await fetchPage(for: .nowPlaying(page: page))
    }

    private func fetchPage(for endpoint: TMDBMovieEndpoint) async throws -> MoviePage {
        let request = try endpoint.makeRequest(configuration: configuration)
        let data = try await networkClient.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(TMDBMoviePageResponse.self, from: data)

        return MoviePage(
            page: response.page,
            movies: response.results.map(\.domain),
            totalPages: response.totalPages,
            totalResults: response.totalResults
        )
    }
}

private struct TMDBMoviePageResponse: Decodable {
    let page: Int
    let results: [TMDBMovieResponse]
    let totalPages: Int
    let totalResults: Int
}

private struct TMDBMovieResponse: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    let releaseDate: String?

    var domain: Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            voteAverage: voteAverage,
            releaseDate: releaseDate
        )
    }
}
