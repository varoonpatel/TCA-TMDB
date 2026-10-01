import ComposableArchitecture
import Foundation

extension DependencyValues {
    var movieRepository: any MovieRepository {
        get {
            self[MovieRepositoryKey.self]
        } set {
            self[MovieRepositoryKey.self] = newValue
        }
    }
}

private enum MovieRepositoryKey: DependencyKey {
    static var liveValue: any MovieRepository {
        guard
            let accessToken = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String,
            !accessToken.isEmpty
        else {
            fatalError("Add a non-empty API_KEY value to the app's Info.plist.")
        }

        return TMDBMovieRepository(
            configuration: TMDBConfiguration(accessToken: accessToken)
        )
    }
}

private struct UnimplementedMovieRepository: MovieRepository {
    func searchMovies(query: String, page: Int) async throws -> MoviePage {
        throw MovieRepositoryDependencyError.testOverrideRequired
    }

    func nowPlayingMovies(page: Int) async throws -> MoviePage {
        throw MovieRepositoryDependencyError.testOverrideRequired
    }
}

private enum MovieRepositoryDependencyError: Error {
    case testOverrideRequired
}
