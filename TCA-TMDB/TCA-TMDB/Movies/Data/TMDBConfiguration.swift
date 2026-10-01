import Foundation

public struct TMDBConfiguration: Sendable {
    public let accessToken: String
    public let baseURL: URL

    public init(
        accessToken: String,
        baseURL: URL = URL(string: "https://api.themoviedb.org/3")!
    ) {
        self.accessToken = accessToken
        self.baseURL = baseURL
    }
}
