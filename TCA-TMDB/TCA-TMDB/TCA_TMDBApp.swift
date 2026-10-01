//
//  TCA_TMDBApp.swift
//  TCA-TMDB
//
//  Created by Varun on 2026-09-30.
//

import SwiftUI
import ComposableArchitecture
import XCTestDynamicOverlay

@main
struct TCA_TMDBApp: App {
    var body: some Scene {
        WindowGroup {
            if _XCTIsTesting {
                EmptyView()
            } else {
                MovieListView(
                    store: Store(
                        initialState: MovieListStore.State(),
                        reducer: { MovieListStore() }
                    )
                )
            }
        }
    }
}
