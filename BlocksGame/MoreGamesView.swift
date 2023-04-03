//
//  MoreGames.swift
//  TicTacToe
//
//  Created by Amine Arous on 07/03/2023.
//

import SwiftUI

struct MoreGamesView: View {

  struct Game: Identifiable {
    var id = UUID()
    let name: String
    let description: String
    let icon: String
    let image: String
    let idAppStore: String
  }

  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State var pages = [Game(name: "CrossWord Mix",
                           description: "iOS CrossWord Mix Game",
                           icon: "CrossWordGameIcon",
                           image: "CrossWordGame",
                           idAppStore: "6446602766"),
                      Game(name: "BrainQuiz Master",
                           description: "iOS Puzzle Game",
                           icon: "BrainQuizGameIcon",
                           image: "BrainQuizGame",
                           idAppStore: "6446297886"),
                      Game(name: "Tic Tac Toe",
                           description: "iOS Tic Tac Toe Game",
                           icon: "TicTacToeGameIcon",
                           image: "TicTacToeGame",
                           idAppStore: "382936587"),
                      Game(name: "Battle Ship",
                           description: "iOS BattleShip Game",
                           icon: "BattleShipGameIcon",
                           image: "BattleShipGame",
                           idAppStore: "6446063559"),
                      Game(name: "Goal",
                           description: "Puzzle game for football fans",
                           icon: "GoalGameIcon",
                           image: "GoalGame",
                           idAppStore: "1669709630"),
                      Game(name: "Puzzle",
                           description: "Funny classic puzzle game",
                           icon: "PuzzleGameIcon",
                           image: "PuzzleGame",
                           idAppStore: "6445866276")]


  var body: some View {
    VStack(spacing: 15) {
      GeometryReader {
        let size = $0.size
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 20) {
            ForEach(pages) { page in
              if let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/id\(page.idAppStore)") {
                Link(destination: url) {
                  GameView(page)
                }
              }
            }
          }
          .padding(.horizontal, 20)
          .padding(.vertical, 20)
          .padding(.bottom, bottomPadding(size))
        }
        .coordinateSpace(name: "ScrollView")
        .padding(.top, 15)
      }
    }

  }

  @ViewBuilder
  func GameView(_ game: Game) -> some View {
    GeometryReader {
      let size = $0.size
      let rect = $0.frame(in: .named("ScrollView"))

      HStack(spacing: -25) {

        VStack(alignment: .center, spacing: 6) {
          Text(game.name)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.4)
            .padding(.top, 7)
            .padding(.horizontal, 10)

          Text(game.description)
            .font(.caption)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.4)
            .padding(.top, 7)
            .padding(.horizontal, 10)

          Spacer()

          Image(game.icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(40)
            .padding(10)

          Image("ButtonAppStore")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(10)
        }
        .frame(width: size.width / 2 + 25, height: size.height * 0.8)
        .background {
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(.white)
            .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
            .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
        }
        .zIndex(1)

        ZStack {
          Image(game.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width / 2, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      .frame(width: size.width)
      .rotation3DEffect(.init(degrees: convertOffsetToRotation(rect)), axis: (x: 1, y: 0, z: 0), anchor: .bottom, anchorZ: 1, perspective: 0.8)
    }
    .frame(height: 420)
  }

  func bottomPadding(_ size: CGSize = .zero) -> CGFloat {
    let cardHeight = 420.0
    let scrollViewHeight = size.height
    return scrollViewHeight - cardHeight - 40
  }

  func convertOffsetToRotation(_ rect: CGRect) -> CGFloat {
    let cardHeight = rect.height + 20
    let minY = rect.minY - 20
    let progress = minY < 0 ? (minY / cardHeight) : 0
    let constrainedProgress = min(-progress, 1.0)
    return constrainedProgress * 90
  }
}

struct MoreGamesView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      MoreGamesView()
    }
  }
}
