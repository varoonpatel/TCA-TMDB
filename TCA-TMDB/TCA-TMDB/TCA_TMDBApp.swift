//
//  TCA_TMDBApp.swift
//  TCA-TMDB
//
//  Created by Varun on 2026-09-30.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_TMDBApp: App {
    let apiKey: String
    
    init() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String, !apiKey.isEmpty else {
            fatalError("Please add a value for the key 'API_KEY' in the Info.plist")
        }
        self.apiKey = apiKey
    }
    
    var body: some Scene {
        WindowGroup {
            MovieListView(
                store: Store(
                    initialState: MovieListStore.State(),
                    reducer: {
                        MovieListStore(
                            movieRepository: TMDBMovieRepository(
                                configuration: TMDBConfiguration(
                                    accessToken: apiKey
                                )
                            )
                        )
                    }
                )
            )
        }
    }
}
