//
//  MockMovieRepository.swift
//  TCA-TMDB
//
//  Created by Varun on 2026-10-01.
//

@testable import TCA_TMDB

extension MoviePage {
    static func makeMoviePage(page: Int, movieTitle: String) -> Self {
        MoviePage(
            page: page,
            movies: [Movie(
                id: 1,
                title: movieTitle,
                overview: "",
                posterPath: nil,
                voteAverage: 9,
                releaseDate: nil
            )],
            totalPages: 4,
            totalResults: 2
        )
    }
}

final class MockMovieRepository: MovieRepository {
    private let result: Result<MoviePage, NetworkClientError>
    
    init(
        moviePage: MoviePage = .makeMoviePage(page: 1, movieTitle: "Test 1"),
        error: NetworkClientError? = nil
    ) {
        if let error {
            result = .failure(error)
        } else {
            result = .success(moviePage)
        }
    }
    
    func nowPlayingMovies(page: Int) async throws -> MoviePage {
        try result.get()
    }
    
    func searchMovies(query: String, page: Int) async throws -> MoviePage {
        try result.get()
    }
}
