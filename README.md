# TCA-TMDB

A small SwiftUI movie browser for practicing [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) with TMDB.

## Features

- Browse TMDB's now-playing movies with pagination.
- Search movies by title.
- Keep networking behind a `NetworkClient` and `MovieRepository` interface.
- Inject the repository into the TCA feature and use a mock in `TestStore` tests.

## Run

1. Open `TCA-TMDB/TCA-TMDB.xcodeproj` in Xcode.
2. Set `API_KEY` in the app's `Info.plist` to a TMDB API Read Access Token.
3. Select the `TCA-TMDB` scheme and run on an iOS simulator or device.

## Tests

In Xcode, select the `TCA-TMDB` scheme and choose **Product → Test**. Store tests use a mock `MovieRepository` and do not need TMDB access.
