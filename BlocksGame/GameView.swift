//
//  GameView.swift
//  BlocksGame
//
//  Created by Amine Arous on 29/03/2023.
//

import SwiftUI
import PopupView

struct GameView: View {

  @ObservedObject var viewModel: GameViewModel
  @State private var isShowingGame: Bool = false
  @State private var showToast: Bool = false
  @State private var soundActivated = UserDefaultHelper.get(for: Int.self, key: .sound)

  init(viewModel: GameViewModel) {
    self.viewModel = viewModel
  }

    func toto() {
        print("🐽")
        if 1 == 1 {
            print("🐽🐽")
            return
        }
    }
    
  var body: some View {
    ZStack {
      VStack {
        if isShowingGame {
          HStack {
            Button {
              viewModel.displayContent = .menu
              isShowingGame = false
            } label: {
              Text("🔙")
                .font(.custom("FarelComic", fixedSize: 25))
                .foregroundColor(.white)
                .padding(.top, 7)
//                .background {
//                  ZStack {
//                    Circle()
//                      .fill(Color.red)
//                      .frame(width: 30, height: 30)
//                    Circle()
//                      .stroke(.white, lineWidth: 2)
//                      .frame(width: 30, height: 30)
//                  }
//                }
                .padding(.leading, 10)
                .padding(.top, -8)
            }
            .buttonStyle(ScaledButtonStyle())
            Spacer()
            Text("\(viewModel.score)")
              .foregroundColor(Color(hex: "1F4D7E"))
              .multilineTextAlignment(.trailing)
              .font(.custom("FarelComic", fixedSize: 30))
            Spacer()
            Text("🏆\(viewModel.bestScore)")
              .foregroundColor(Color(hex: "1F4D7E"))
              .multilineTextAlignment(.trailing)
              .font(.custom("FarelComic", fixedSize: 20))
              .padding(.trailing, 10)
          }
          .transition(.move(edge: .leading))
          .padding(.horizontal, 10)
          .padding(.top, 10)
          .frame(height: 50)
          .background {
            Color(hex: "EBEBEB")
          }
          .cornerRadius(15)
          //.shadow(radius: 1)
          .padding(.horizontal, GameViewModel.Constant.horizontalPadding)
          Spacer()
        }
      }

      ZStack {

        HStack(spacing: GameViewModel.Constant.spacing) {
          ForEach(0..<GameViewModel.Constant.columNumber, id: \.self) { i in
            Button {
              viewModel.handle(action: .tapOnColumn(indice: i))
            } label: {
              if isShowingGame {
                Rectangle()
                  .frame(width: viewModel.sizeItem,
                         height: viewModel.sizeTile.height)
                  .foregroundColor(Color(hex: viewModel.tileColor))
                //.foregroundColor(Color(hex: "ECEFF1"))
                //.foregroundColor(Color(hex: "F8BBD0"))
                  .cornerRadius(25)
                //.shadow(color: .gray, radius: 1)
                  .animation(.linear(duration: 0.2), value: viewModel.tileColor)
                  .transition(.move(edge: .bottom))
                //.transition(AnyTransition.move(edge: .top).combined(with: .scale).combined(with: .opacity))
              }
            }
            .buttonStyle(FlatLinkStyle())
          }
        }
        .disabled(viewModel.disabledTile)
        .position(x: viewModel.xTile, y: viewModel.yTile)


        ZStack {
          ForEach(0..<GameViewModel.Constant.columNumber, id: \.self) { i in
            ForEach(0..<GameViewModel.Constant.numerItemsInColumn, id: \.self) { j in
              if let block = viewModel.gameArray[i][j].block {
                ShapeView(block: block, sizeItem: viewModel.sizeItem)
                  .position(x: block.position.x, y: block.position.y)
              }
            }
          }
        }
        .zIndex(1)
        .transition(.move(edge: .trailing))
      }
      //.transition(AnyTransition.move(edge: .top).combined(with: .scale).combined(with: .opacity))

      if viewModel.playComboCounter {
        ComboCounterView(comboNumer: viewModel.nbCombo, isPresented: $viewModel.playComboCounter)
          .position(x: viewModel.xTile, y: viewModel.yTile)
      }

      if case let .gameOver(gameOverState) = viewModel.gameState {
        GameOverView(gameOverState: gameOverState, score: viewModel.score, actionPlay: {
          viewModel.handle(action: .startPlay)
        }, actionMenu: {
          viewModel.displayContent = .menu
        })
        .zIndex(3)
      }

      if isShowingGame {
        ShapeView(block: viewModel.currentBlock, sizeItem: viewModel.sizeItem)
          .position(x: viewModel.currentBlock.position.x, y: viewModel.currentBlock.position.y)
        //.animation(.linear(duration: 0.5), value: viewModel.currentBlock.position)
          .popup(isPresented: $showToast) {
            PlayTipView(message: "game.toast.howToPlay".localized())
          }
          customize: {
            $0
              .type(.floater())
              .position(.top)
              .animation(.spring())
              .autohideIn(2)
          }
          .gesture(TapGesture().onEnded { _ in
                showToast = true
              }
          )
          .transition(.move(edge: .bottom).combined(with: .scale))

        ShapeView(block: viewModel.nextBlock, sizeItem: viewModel.sizeItem)
          .scaleEffect(0.5)
          .position(x: viewModel.nextBlock.position.x, y: viewModel.nextBlock.position.y)
          .transition(.move(edge: .bottom).combined(with: .scale))
      }

      if isShowingGame {
        ZStack {
          VStack {
            Spacer()
            HStack {
              Button {
                let newValue = soundActivated == 0 ? 1 : 0
                UserDefaultHelper.save(value: newValue, key: .sound)
                soundActivated = newValue
              } label: {
                ZStack {
                  Image(systemName: soundActivated == 1 ? "speaker.wave.2" : "speaker.slash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding(10)
                }
              }
              .padding(.leading, 30)
              .buttonStyle(NeumorphicButtonStyle())
              Spacer()
            }
            .padding(.bottom, GameModel.removeAdsPurchase == false ? 70 : 20)
          }

        }
        .transition(.move(edge: .leading))
      }

    }
    .task {
      try? await Task.sleep(nanoseconds: 0_250_000_000)

      withAnimation(.spring()) {
        isShowingGame = true
      }
    }
  }
}

struct GameView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      GameView(viewModel: GameViewModel(displayContent: .constant(.game)))
    }
  }
}
