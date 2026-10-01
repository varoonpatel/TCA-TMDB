import Foundation

public struct Movie: Equatable, Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String?
    public let voteAverage: Double
    public let releaseDate: String?
    public var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    public init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String?,
        voteAverage: Double,
        releaseDate: String?
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
    }
}

/// A single page returned by a TMDB movie list endpoint.
public struct MoviePage: Equatable, Sendable {
    public let page: Int
    public let movies: [Movie]
    public let totalPages: Int
    public let totalResults: Int

    public init(page: Int, movies: [Movie], totalPages: Int, totalResults: Int) {
        self.page = page
        self.movies = movies
        self.totalPages = totalPages
        self.totalResults = totalResults
    }

    public var hasNextPage: Bool {
        page < totalPages
    }

    public var nextPage: Int? {
        hasNextPage ? page + 1 : nil
    }
}
