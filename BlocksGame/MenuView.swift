//
//  MenuView.swift
//  BlocksGame
//
//  Created by Amine Arous on 31/03/2023.
//

import SwiftUI

struct MenuView: View {


  @State private var displayMoreGamesView = false
  @State private var displayPurchaseView = false
  @State private var isShowingMenu: Bool = false
  @State var openRankingView: Bool = false

  @State var backgroundColor: Color = .blue

  @Binding private var displayContent: GameViewModel.DisplayMode
  @Binding private var animateBackgroundMoreGames: Bool

  init(displayContent: Binding<GameViewModel.DisplayMode>, animateBackgroundMoreGames: Binding<Bool>) {
    self._displayContent = displayContent
    self._animateBackgroundMoreGames = animateBackgroundMoreGames
  }

  var body: some View {
    VStack(spacing: 30) {

      if isShowingMenu {
        Button {
          isShowingMenu = false
          displayContent = .game
        } label: {
          Text("menu.button.play".localized())
            .font(.custom("FarelComic", fixedSize: 35))
            .foregroundColor(Color(hex: "FFFFFF"))
            .frame(width: 250, height: 60)
            .padding(.top, 10)
            .padding(.horizontal, 20)
//            .background {
//              Color(hex: "9575CD")
//            }
//            .cornerRadius(20)
//            .shadow(color: Color(hex: "1F4D7E"), radius: 2)
        }
        //.transition(AnyTransition.move(edge: .top).combined(with: .scale).combined(with: .opacity))
        //.transition(AnyTransition.asymmetric(insertion: .scale, removal: .slide))
        .transition(.move(edge: .leading).combined(with: .scale))
        .buttonStyle(NeumorphicButtonStyle())
        //.buttonStyle(ScaledButtonStyle())


        Button {
          openRankingView = true
        } label: {
          Text("menu.button.ranking".localized())
            .font(.custom("FarelComic", fixedSize: 35))
            .foregroundColor(Color(hex: "FFFFFF"))
            .frame(width: 250, height: 60)
            .padding(.top, 10)
            .padding(.horizontal, 20)
//            .background {
//              Color(hex: "FFB74D")
//            }
//            .cornerRadius(20)
//            .shadow(color: Color(hex: "1F4D7E"), radius: 2)
        }
        //.transition(AnyTransition.move(edge: .top).combined(with: .scale).combined(with: .opacity))
        .transition(.move(edge: .trailing).combined(with: .scale))
        .buttonStyle(NeumorphicButtonStyle())
        //.buttonStyle(ScaledButtonStyle())

        Button {
          withAnimation(.linear(duration: 0.3)) {
            animateBackgroundMoreGames = true
            isShowingMenu = false
          }
          withAnimation(.linear(duration: 0.3).delay(0.3)) {
            displayMoreGamesView = true
          }
        } label: {
          Text("menu.button.moreGames".localized())
            .font(.custom("FarelComic", fixedSize: 35))
            .foregroundColor(Color(hex: "FFFFFF"))
            .frame(width: 250, height: 60)
            .padding(.top, 10)
            .padding(.horizontal, 20)
//            .background {
//              Color(hex: "AED581")
//            }
//            .cornerRadius(20)
//            .shadow(color: Color(hex: "1F4D7E"), radius: 2)
        }
        //.transition(AnyTransition.move(edge: .top).combined(with: .scale).combined(with: .opacity))
        .buttonStyle(NeumorphicButtonStyle())
        //.buttonStyle(CapsuleButtonStyle())
        .transition(.move(edge: .leading).combined(with: .scale))


        if GameModel.removeAdsPurchase == false {
          Button {
            withAnimation(.linear(duration: 0.3)) {
              animateBackgroundMoreGames = true
              isShowingMenu = false
            }
            withAnimation(.linear(duration: 0.3).delay(0.3)) {
              displayPurchaseView = true
            }
          } label: {
            Text("menu.button.removeAds".localized())
              .font(.custom("FarelComic", fixedSize: 35))
              .foregroundColor(Color(hex: "FFFFFF"))
              .frame(width: 250, height: 60)
              .padding(.top, 10)
              .padding(.horizontal, 20)

//              .background {
//                Color(hex: "FF8A80")
//              }
             // .cornerRadius(20)
              //.shadow(color: Color(hex: "1F4D7E"), radius: 2)
          }
          //.transition(AnyTransition.move(edge: .top).combined(with: .scale).combined(with: .opacity))
          .transition(.move(edge: .trailing).combined(with: .scale))
          //.buttonStyle(ScaledButtonStyle())
          .buttonStyle(CapsuleButtonStyle())
        }

      }

      else {
        if displayMoreGamesView {
          ZStack {
            MoreGamesView()

            VStack {
              HStack {

                Button {
                  withAnimation(.linear(duration: 0.3)) {
                    displayMoreGamesView = false
                    isShowingMenu = true
                  }

                  withAnimation(.linear(duration: 0.3).delay(0.3)) {
                    animateBackgroundMoreGames = false
                  }
                } label: {
                  Text("🔙")
                    .foregroundColor(.white)
                    .font(.custom("FarelComic", fixedSize: 20))
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    .background(Color(hex: "FFD54F"))
                    .clipShape(Capsule())
                }
                .buttonStyle(ScaledButtonStyle())
                .padding(.leading, 20)
                Spacer()
              }
              Spacer()
            }
          }
        } else if displayPurchaseView {
          ZStack {
            PurchaseView(viewModel: PurchaseViewModel())
            VStack {
              HStack {
                  Button {
                    withAnimation(.linear(duration: 0.3)) {
                      displayPurchaseView = false
                      isShowingMenu = true
                    }

                    withAnimation(.linear(duration: 0.3).delay(0.3)) {
                      animateBackgroundMoreGames = false

                    }
                } label: {
                  Text("🔙")
                    .foregroundColor(.white)
                    .font(.custom("FarelComic", fixedSize: 20))
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    .background(Color(hex: "FFD54F"))
                    .clipShape(Capsule())
                }
                .buttonStyle(ScaledButtonStyle())
                .padding(.leading, 20)
                Spacer()
              }
              Spacer()
            }
          }

        }
      }
    }
    .task {
      try? await Task.sleep(nanoseconds: 1_000_000_000)
      withAnimation(.spring()) {
        isShowingMenu = true
      }
    }
    .onAppear() {
      Task {
        Authenticate.user()
      }
    }
//    .sheet(isPresented: $displayPurchaseView) {
//      PurchaseView(viewModel: PurchaseViewModel())
//    }
//    .sheet(isPresented: $displayMoreGamesView) {
//      MoreGamesView()
//    }
    .sheet(isPresented: $openRankingView, content: {
      GameCenterView(leaderboardID: "general")
    })
  }
}

struct MenuView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      MenuView(displayContent: .constant(.menu), animateBackgroundMoreGames: .constant(true))
    }
  }
}

struct TriangleView: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 100, y: 100))
            path.addLine(to: CGPoint(x: 50, y: 0))
        }
        .fill(Color.blue)
    }
}
