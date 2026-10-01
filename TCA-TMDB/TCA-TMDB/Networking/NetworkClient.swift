import Foundation

/// Performs an HTTP request and returns its response body.
public protocol NetworkClient: Sendable {
    func data(for request: URLRequest) async throws -> Data
}

public struct URLSessionNetworkClient: NetworkClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func data(for request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkClientError.nonHTTPResponse
        }

        guard (200..<300).contains(response.statusCode) else {
            throw NetworkClientError.unacceptableStatusCode(response.statusCode)
        }

        return data
    }
}

public enum NetworkClientError: Error, Equatable {
    case nonHTTPResponse
    case unacceptableStatusCode(Int)
    case unknown
}
