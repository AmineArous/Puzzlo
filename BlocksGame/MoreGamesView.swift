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
    let image: String
    let idAppStore: String
  }

  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State var pages = [Game(name: "CrossWord Mix", image: "CrossWordGame", idAppStore: "6446602766"),
                      Game(name: "BrainQuiz Master", image: "BrainQuizGame", idAppStore: "6446297886"),
                      Game(name: "Tic Tac Toe", image: "TicTacToeGame", idAppStore: "382936587"),
                      Game(name: "Battle Ship", image: "BattleShipGame", idAppStore: "6446063559"),
                      Game(name: "Goal", image: "GoalGame", idAppStore: "1669709630"),
                      Game(name: "Puzzle", image: "PuzzleGame", idAppStore: "6445866276")]


  var body: some View {
   // NavigationView {

      ZStack {
//        Color.yellow
//          .edgesIgnoringSafeArea(.all)
        TabView {
          ForEach(pages) { page in
            ZStack {
              if let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/id\(page.idAppStore)") {
                Link(destination: url) {
                    VStack {
                      Text(page.name)
                        .font(.custom("FarelComic", fixedSize: 30))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.4)

                        .padding(.top, 7)
                        .padding(.horizontal, 32)
                        .background {
                          Color.black.opacity(0.5)
                        }
                        .cornerRadius(30)

                      Image(page.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(30)

                      Image("ButtonAppStore")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 400, minHeight: 100, maxHeight: 200, alignment: .center)
                    }
                    .padding(40)
                    .background {
                      Color(hex: "F2F2F2").opacity(0.6)
                    }

                }
                .buttonStyle(FlatLinkStyle())
              }
            }
          }
          .cornerRadius(30)
          .padding(20)
        }
        .padding(.top, 50)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .edgesIgnoringSafeArea(.all)
      }
//    }
//    .navigationViewStyle(StackNavigationViewStyle())
//    .navigationBarBackButtonHidden(true)
  }
}

struct MoreGames_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      MoreGamesView()
    }
  }
}

