import Foundation

/// Runtime configuration for the TMDB API. Supply a TMDB API Read Access Token
/// from app configuration or a secure store; do not commit it to source control.
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
