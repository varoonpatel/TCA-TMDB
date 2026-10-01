import Foundation

public protocol MovieRepository: Sendable {
    func searchMovies(query: String, page: Int) async throws -> MoviePage
    func nowPlayingMovies(page: Int) async throws -> MoviePage
}

public extension MovieRepository {
    func searchMovies(query: String) async throws -> MoviePage {
        try await searchMovies(query: query, page: 1)
    }

    func nowPlayingMovies() async throws -> MoviePage {
        try await nowPlayingMovies(page: 1)
    }
}
