import Foundation

enum TMDBMovieEndpoint {
    case search(query: String, page: Int)
    case nowPlaying(page: Int)

    func makeRequest(configuration: TMDBConfiguration) throws -> URLRequest {
        let path: String
        let queryItems: [URLQueryItem]

        switch self {
        case let .search(query, page):
            path = "search/movie"
            queryItems = [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page)),
            ]
        case let .nowPlaying(page):
            path = "movie/now_playing"
            queryItems = [URLQueryItem(name: "page", value: String(page))]
        }

        guard var components = URLComponents(
            url: configuration.baseURL.appending(path: path),
            resolvingAgainstBaseURL: false
        ) else {
            throw TMDBRequestError.invalidURL
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw TMDBRequestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(configuration.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

enum TMDBRequestError: Error, Equatable {
    case invalidURL
}
