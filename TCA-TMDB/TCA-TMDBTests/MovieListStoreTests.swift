//
//  MovieListStoreTests.swift
//  TCA-TMDBTests
//
//  Created by Varun on 2026-09-30.
//
import ComposableArchitecture
import Testing
@testable import TCA_TMDB

@MainActor
struct MovieListStoreTests {
    private func makeStore(repository: any MovieRepository = MockMovieRepository()) -> TestStoreOf<MovieListStore> {
        TestStore(initialState: MovieListStore.State()) {
            MovieListStore()
        } withDependencies: {
            $0.movieRepository = repository
        }
    }

    @Test func successfullyFetchMovies() async throws {
        let store = makeStore()
        
        await store.send(.fetchMovies)
        await store.receive(\.movieResponse.success) {
            let moviePage = MoviePage.makeMoviePage(page: 1, movieTitle: "Test 1")
            $0.movies = moviePage.movies
            $0.hasMorePages = moviePage.hasNextPage
        }
    }
    
    @Test func failedToFetchMovies() async throws {
        let repository = MockMovieRepository(error: .unknown)
        
        let store = makeStore(repository: repository)
        
        await store.send(.fetchMovies)
        await store.receive(\.movieResponse.failure) {
            $0.movieError = .unknown
        }
    }
    
    @Test func successfullyLoadMoreMovies() async throws {
        let firstMoviePage = MoviePage.makeMoviePage(page: 1, movieTitle: "Test 1")
        let secondMoviePage = MoviePage.makeMoviePage(page: 2, movieTitle: "Test 2")
        
        let mockMovieRepository = MockMovieRepository(moviePage: secondMoviePage)

        let store =  TestStore(
            initialState: MovieListStore.State(
                movies: firstMoviePage.movies,
                hasMorePages: true,
                currentPage: firstMoviePage.page
            )
        ) {
            MovieListStore()
        } withDependencies: {
            $0.movieRepository = mockMovieRepository
        }
        
        
        await store.send(.loadNextPage)
        await store.receive(\.nextPageResponse.success) {
            $0.movies.append(contentsOf: secondMoviePage.movies)
            $0.hasMorePages = secondMoviePage.hasNextPage
            $0.currentPage = secondMoviePage.page
        }
    }
    
    @Test func failedToLoadMoreMovies() async throws {
        let firstMoviePage = MoviePage.makeMoviePage(page: 1, movieTitle: "Test 1")
        
        let mockMovieRepository = MockMovieRepository(error: .unknown)

        let store =  TestStore(
            initialState: MovieListStore.State(
                movies: firstMoviePage.movies,
                hasMorePages: true,
                currentPage: firstMoviePage.page
            )
        ) {
            MovieListStore()
        } withDependencies: {
            $0.movieRepository = mockMovieRepository
        }
        
        
        await store.send(.loadNextPage)
        await store.receive(\.nextPageResponse.failure) {
            $0.movieError = .unknown
            $0.movies = firstMoviePage.movies
            $0.hasMorePages = firstMoviePage.hasNextPage
            $0.currentPage = firstMoviePage.page
        }
    }
    
    @Test func successfullySearchMovies() async throws {
        let store = makeStore()
        
        await store.send(.searchQueryChanged("T")) {
            $0.searchQuery = "T"
            $0.hasMorePages = false
            $0.currentPage = 1
        }
        await store.send(.searchDebounced)
        await store.receive(\.movieResponse.success) {
            let moviePage = MoviePage.makeMoviePage(page: 1, movieTitle: "Test 1")
            $0.movies = moviePage.movies
            $0.hasMorePages = moviePage.hasNextPage
        }
    }
    
    @Test func failedToSearchMovies() async throws {
        let repository = MockMovieRepository(error: .unknown)
        
        let store = makeStore(repository: repository)
        
        await store.send(.searchQueryChanged("T")) {
            $0.searchQuery = "T"
            $0.hasMorePages = false
            $0.currentPage = 1
        }
        await store.send(.searchDebounced)
        
        await store.receive(\.movieResponse.failure) {
            $0.movieError = .unknown
        }
    }
}
