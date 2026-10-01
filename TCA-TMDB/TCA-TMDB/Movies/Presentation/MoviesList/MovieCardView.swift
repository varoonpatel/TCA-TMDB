import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ZStack {
                    MovieColors.secondaryText.opacity(0.1)
                    Image(systemName: "movieclapper")
                        .font(.system(size: 40))
                        .foregroundStyle(MovieColors.secondaryText.opacity(0.3))
                }
            }
            .frame(height: 240)
            .frame(maxWidth: .infinity)
            .clipped()

            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .lineLimit(1)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(MovieColors.text)

                HStack(spacing: 5) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(MovieColors.warning)
                    Text("\(movie.voteAverage, specifier: "%.1f / 10")")
                        .font(.callout)
                        .foregroundStyle(MovieColors.secondaryText)
                }
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 12)
            .padding(.top, 10)
        }
        .background(MovieColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: MovieColors.shadow, radius: 8, x: 0, y: 4)
    }
}
