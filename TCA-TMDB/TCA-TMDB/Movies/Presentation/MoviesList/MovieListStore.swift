//
//  MovieListStore.swift
//  TCA-TMDB
//
//  Created by Varun on 2026-10-01.
//

import ComposableArchitecture

@Reducer
struct MovieListStore {
    @Dependency(\.movieRepository) var movieRepository
    
    @ObservableState
    struct State: Equatable {
        var movies: [Movie] = []
        var movieError: NetworkClientError?
        var searchQuery: String = ""
        var hasMorePages: Bool = false
        var currentPage: Int = 1
    }
    
    enum Action {
        case fetchMovies
        case movieResponse(Result<MoviePage, NetworkClientError>)
        case searchQueryChanged(String)
        case searchDebounced
        case loadNextPage
        case nextPageResponse(Result<MoviePage, NetworkClientError>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchMovies:
                return .run { send in
                    do {
                        let moviePage = try await self.movieRepository.nowPlayingMovies()
                        await send(.movieResponse(.success(moviePage)))
                    } catch let error as NetworkClientError {
                        await send(.movieResponse(.failure(error)))
                    } catch {
                        await send(.movieResponse(.failure(NetworkClientError.unknown)))
                    }
                }
            case .movieResponse(.success(let moviePage)):
                state.movies = moviePage.movies
                state.hasMorePages = moviePage.hasNextPage
                state.currentPage = moviePage.page
                return .none
            case .movieResponse(.failure(let error)):
                state.movieError = error
                return .none
            case .searchQueryChanged(let searchQuery):
                state.searchQuery = searchQuery
                state.hasMorePages = false
                state.currentPage = 1
                return .none
            case .searchDebounced:
                return .run { [searchQuery = state.searchQuery] send in
                    do {
                        let moviePage: MoviePage
                        
                        if searchQuery.isEmpty {
                            moviePage = try await self.movieRepository.nowPlayingMovies()
                        } else {
                            moviePage = try await self.movieRepository.searchMovies(query: searchQuery)
                        }
                        await send(.movieResponse(.success(moviePage)))
                    } catch let error as NetworkClientError {
                        await send(.movieResponse(.failure(error)))
                    } catch {
                        await send(.movieResponse(.failure(NetworkClientError.unknown)))
                    }
                }
            case .loadNextPage:
                return .run { [currentPage = state.currentPage] send in
                    do {
                        let moviePage = try await self.movieRepository.nowPlayingMovies(page: currentPage + 1)
                        await send(.nextPageResponse(.success(moviePage)))
                    } catch let error as NetworkClientError {
                        await send(.nextPageResponse(.failure(error)))
                    } catch {
                        await send(.nextPageResponse(.failure(NetworkClientError.unknown)))
                    }
                }
            case .nextPageResponse(.success(let moviePage)):
                state.movies.append(contentsOf: moviePage.movies)
                state.hasMorePages = moviePage.hasNextPage
                state.currentPage = moviePage.page
                return .none
                
            case .nextPageResponse(.failure(let error)):
                state.movieError = error
                return .none
            }
        }
    }
}
