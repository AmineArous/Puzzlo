//
//  GameViewModel.swift
//  BlocksGame
//
//  Created by Amine Arous on 29/03/2023.
//

import Foundation
import SwiftUI
import GoogleMobileAds
import GameKit
import StoreKit
import AVFoundation

class GameViewModel: ObservableObject {

//  @available(iOS 16.0, *)
//  @Environment(\.requestReview) var requestReview

  @Published var gameArray: [[Item]]
  @Published var currentBlock: Block = .init(value: 0, position: .zero, color: .white)
  @Published var nextBlock: Block = .init(value: 0, position: .zero, color: .white)
  @Published var disabledTile: Bool = false

  @Binding var displayContent: DisplayMode
  @Published var displayPurchaseView: Bool = false
  @Published var displayMoreGamesView: Bool = false

  @Published var score: Int = 0
  var nbCombo: Int = 0
  @Published var playComboCounter: Bool = false
  @Published var tileColor = "EBEBEB"
  @Published var gameState: GameState
  private static let boundsSize = UIScreen.main.bounds.size

  private var bestShapeReached: Int = 4
  private let adMobService: AdMobServiceProtocol
  private var avPlayer: AVAudioPlayer?

  var sizeItem: CGFloat
  private let adHeight = GameModel.removeAdsPurchase == false ? GADAdSizeBanner.size.height : 0

  var bestScore: Int {
    UserDefaultHelper.get(for: Int.self, key: .bestScore)
  }

  init(displayContent: Binding<GameViewModel.DisplayMode>, adMobService: AdMobServiceProtocol = AdMobService()) {
    self._displayContent = displayContent
    self.adMobService = adMobService
    self.gameState = .play
    self.score = 0
    
    let window = UIApplication.shared.keyWindow
    let topPadding = window?.safeAreaInsets.top ?? 0
    let bottomPadding = window?.safeAreaInsets.bottom ?? 0

    sizeItem = (GameViewModel.boundsSize.width - ((CGFloat(Constant.columNumber - 1)) * Constant.spacing) - (Constant.horizontalPadding * 2)) / CGFloat(Constant.columNumber)

    let availableHeight = GameViewModel.boundsSize.height - Constant.topPadding - 20 - sizeItem - adHeight - topPadding - bottomPadding
    while ((sizeItem * CGFloat(Constant.numerItemsInColumn)) + (Constant.spacing * (CGFloat(Constant.numerItemsInColumn - 1)))) > availableHeight {
      Constant.numerItemsInColumn -= 1
    }

    gameArray = Array(repeating: Array(repeating: .empty, count: Constant.numerItemsInColumn), count: Constant.columNumber)
    let randomShape = GameViewModel.getRandomValueForBloc()
    self.currentBlock = Block(value: randomShape.rawValue,
                              position: CGPoint(x: xCurrentShape,
                                                y: yCurrentShape),
                              color: randomShape.color)
    let randomNextShape = GameViewModel.getRandomValueForBloc()
    nextBlock = Block(value: randomNextShape.rawValue,
                      position: CGPoint(x: xCurrentShape + sizeItem,
                                        y: yCurrentShape),
                      color: randomNextShape.color)
    Task {
      adMobService.prepareInterstitualPub()
    }
  }
}

extension GameViewModel {
  enum Constant {
    static let spacing = 5.0
    static let columNumber = 5
    static var numerItemsInColumn = 8
    static let topPadding = 60.0
    static var horizontalPadding = 20.0
    static let values: [Shape] = [._4, ._8, ._16, ._32, ._64]
  }

  enum DisplayMode {
    case menu
    case game
  }

  enum GameState {
    case play
    case over
  }

  enum Shape: Int, CaseIterable {
    case _4  = 4
    case _8  = 8
    case _16 = 16
    case _32 = 32
    case _64 = 64
    case _128 = 128
    case _256 = 256
    case _512 = 512
    case _1024 = 1024
    case _2048 = 2048
    case _4096 = 4096

    var color: Color {
      switch self {
      case ._4:
        return Color(hex: "00BFFF") //Color(hex: "FFE082") //.yellow
      case ._8:
        return Color(hex: "FF5733") //.green
      case ._16:
        return Color(hex: "FFD700") //.blue
      case ._32:
        return Color(hex: "B0E0E6") //.red
      case ._64:
        return Color(hex: "009688") //Color(hex: "581845") //.purple
      case ._128:
        return Color(hex: "FFA000") //.cyan
      case ._256:
        return Color(hex: "FFB6C1") //.pink
      case ._512:
        return Color(hex: "191970") //.orange
      case ._1024:
        return Color(hex: "32CD32") //.black
      case ._2048:
        return Color(hex: "E6BE8A") //.black
      case ._4096:
        return Color(hex: "2B2B2B") //.black
      }
    }
  }

  var sizeTile: CGSize {
    CGSize(width: (sizeItem * CGFloat(Constant.columNumber)) + (Constant.spacing * (CGFloat(Constant.columNumber - 1))),
           height: (sizeItem * CGFloat(Constant.numerItemsInColumn)) + (Constant.spacing * (CGFloat(Constant.numerItemsInColumn - 1))))
  }

  var xCurrentShape: CGFloat {
    (GameViewModel.boundsSize.width / 2)
  }
  var yCurrentShape: CGFloat {
    Constant.topPadding + sizeTile.height + (sizeItem/2) + 10
  }

  var xTile: CGFloat {
    (sizeTile.width / 2) + Constant.horizontalPadding
  }

  var yTile: CGFloat {
    Constant.topPadding + (sizeTile.height / 2)
  }

  enum Item: Equatable {
    case empty
    case block(Block)

    var block: Block? {
      switch self {
      case .empty:
        return nil
      case .block(let block):
        return block
      }
    }
  }

  struct Block: Equatable {
    var value: Int
    var position: CGPoint
    var color: Color
    var scale: CGFloat = 1.0
  }
}

extension GameViewModel {
  enum Action {
    case startPlay
    case tapOnColumn(indice: Int)
    case reportScore
    case reportAchievement(id: Int)
    case requestReview
  }

  func handle(action: Action) {
    switch action {
    case .startPlay:

      adMobService.showInterstitialPub()

      gameState = .play
      score = 0
      gameArray = Array(repeating: Array(repeating: .empty, count: Constant.numerItemsInColumn), count: Constant.columNumber)
      let randomShape = GameViewModel.getRandomValueForBloc()
      self.currentBlock = Block(value: randomShape.rawValue,
                                position: CGPoint(x: xCurrentShape,
                                                  y: yCurrentShape),
                                color: randomShape.color)
      let randomNextShape = GameViewModel.getRandomValueForBloc()
      nextBlock = Block(value: randomNextShape.rawValue,
                        position: CGPoint(x: xCurrentShape + sizeItem,
                                          y: yCurrentShape),
                        color: randomNextShape.color)

    case .tapOnColumn(let indice):
      self.playComboCounter = false
      self.nbCombo = 0
      var yDestination: CGFloat? = nil
      var indexDestination = 0
      for (index, item) in gameArray[indice].enumerated() {
        if item == Item.empty {
          yDestination = Constant.topPadding + (sizeItem/2) + (CGFloat(index) * sizeItem) + (CGFloat(index) * Constant.spacing)
          indexDestination = index
          break
        }
      }

      guard let yDestination else { return }

      self.disabledTile = true

      let x = Constant.horizontalPadding + (sizeItem/2) + (sizeItem * CGFloat(indice)) + (Constant.spacing * CGFloat(indice))
      let y = Constant.topPadding + sizeTile.height - (sizeItem/2)
      currentBlock.position = CGPoint(x: x, y: y)

      //let duration = ((CGFloat(Constant.numerItemsInColumn) - CGFloat(indexDestination)) * 0.12)
      withAnimation(.linear(duration: 0.2).delay(0.2)) {
        currentBlock.position = CGPoint(x: x, y: yDestination)
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {

        self.gameArray[indice][indexDestination] = .block(self.currentBlock)

        self.currentBlock = Block(value: self.nextBlock.value, position: CGPoint(x: self.xCurrentShape, y: self.yCurrentShape), color: self.nextBlock.color)
        let randomShape = GameViewModel.getRandomValueForBloc()
        self.nextBlock = Block(value: randomShape.rawValue, position: CGPoint(x: self.xCurrentShape + self.sizeItem, y: self.yCurrentShape), color: randomShape.color)

        self.updateTile(indexDestination: indexDestination, coloumn: indice, completion: { [weak self] in
          guard let self else { return }
          DispatchQueue.main.async {
            self.bestShapeReached = self.gameArray.flatMap { $0 }.map { $0.block }.compactMap { $0 }.map { $0.value }.max() ?? 0

            if self.bestShapeReached == 512 {
              self.handle(action: .reportAchievement(id: 512))
              self.tileColor = "FFFACD" //Jaune citron
            }
            else if self.bestShapeReached == 1024 {
              self.handle(action: .reportAchievement(id: 1024))
              self.adMobService.prepareAndShowInterstitualPub()
              self.tileColor = "E6E6FA" // Lavande
            }
            else if self.bestShapeReached == 2048 {
              self.handle(action: .reportAchievement(id: 2048))
              self.handle(action: .requestReview)
              self.adMobService.prepareAndShowInterstitualPub()
              self.tileColor = "CFECEC" // Bleu-gris doux
            }
            else if self.bestShapeReached == 4096 {
              self.handle(action: .reportAchievement(id: 4096))
             // self.adMobService.prepareAndShowInterstitualPub()
              self.tileColor = "FFFFE0"
            }

            self.disabledTile = false
            if self.nbCombo > 1 { self.playComboCounter = true }

            self.playSound(sound: self.nbCombo == 0 ? .nothing : .match)

            if self.bestShapeReached == 4096 {
              self.playSound(sound: .gameOver)
              self.gameState = .over
              if self.score > self.bestShapeReached {
                self.handle(action: .reportScore)
              }
            }
          }
        })

      }
    case .reportScore:
      UserDefaultHelper.save(value: score, key: .bestScore)
      GKLeaderboard.submitScore(
        score,
        context: 0,
        player: GKLocalPlayer.local,
        leaderboardIDs: ["general"]
      ) { error in
        print(error)
      }

    case .reportAchievement(let id):

      let achievement = GKAchievement(identifier: "\(id)")
      achievement.percentComplete = 100
      achievement.showsCompletionBanner = true
      GKAchievement.report([achievement]) { error in
          if let error = error {
              print("Erreur lors du rapport de réalisation: \(error.localizedDescription)")
          } else {
              print("Réalisation envoyée à Game Center!")
          }
      }

    case .requestReview:
      guard #available(iOS 16, *) else { return }
      DispatchQueue.main.async {
        self.requestReviewStore()
      }
    }
  }

  @MainActor @available(iOS 16, *)
  private func requestReviewStore() {
    StoreKitReview().requestReviewAction()
  }

  private func updateTile(indexDestination: Int, coloumn: Int, completion: @escaping () -> Void) {

    var updateTop = false
    var updateLeft = false
    var updateRight = false

    guard let block = self.gameArray[coloumn][indexDestination].block else { return }

    if indexDestination - 1 >= 0,
       self.gameArray[coloumn][indexDestination - 1].block?.value == block.value {
      updateTop = true

    }

    if coloumn - 1 >= 0,
       self.gameArray[coloumn - 1][indexDestination].block?.value == block.value {
      updateLeft = true

    }

    if coloumn + 1 < Constant.columNumber,
       self.gameArray[coloumn + 1][indexDestination].block?.value == block.value {
      updateRight = true

    }

    if updateLeft || updateRight || updateTop {


      withAnimation(.linear(duration: 0.2)) {
        self.gameArray[coloumn][indexDestination] = .block(Block(value: block.value,
                                                                 position: block.position,
                                                                 color: block.color,
                                                                 scale: 1.3))
      }

      withAnimation(.linear(duration: 0.2).delay(0.1)) {
        self.gameArray[coloumn][indexDestination] = .block(Block(value: block.value,
                                                                 position: block.position,
                                                                 color: block.color,
                                                                 scale: 1.0))
      }


      self.nbCombo += 1

      if updateLeft, let leftBlock = self.gameArray[coloumn - 1][indexDestination].block {

          self.score += block.value * 2
          withAnimation(.linear(duration: 0.2).delay(0.3)) {
            self.gameArray[coloumn - 1][indexDestination] = .block(Block(value: leftBlock.value,
                                                                         position: CGPoint(x: leftBlock.position.x + sizeItem, y: leftBlock.position.y),
                                                                         color: leftBlock.color,
                                                                         scale: 0.5))

            self.gameArray[coloumn][indexDestination] = .block(Block(value: block.value * 2,
                                                                     position: block.position,
                                                                     color: GameViewModel.colorForValue(value: block.value * 2)))
          }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 + 0.3) {
          self.gameArray[coloumn - 1][indexDestination] = .empty
        }
      //  withAnimation(.linear(duration: 0.2).delay(0.2)) {

         // updateTileColumn(coloumn: coloumn - 1)
      //  }
      }

      if updateRight, let rightBlock = self.gameArray[coloumn + 1][indexDestination].block {


          self.score += block.value * 2
          withAnimation(.linear(duration: 0.2).delay(0.3)) {

            self.gameArray[coloumn + 1][indexDestination] = .block(Block(value: rightBlock.value,
                                                                         position: CGPoint(x: rightBlock.position.x - sizeItem, y: rightBlock.position.y),
                                                                         color: rightBlock.color,
                                                                         scale: 0.5))

            self.gameArray[coloumn][indexDestination] = .block(Block(value: block.value * 2,
                                                                     position: block.position,
                                                                     color: GameViewModel.colorForValue(value: block.value * 2)))
          }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 + 0.3) {
          self.gameArray[coloumn + 1][indexDestination] = .empty
        }

      //  withAnimation(.linear(duration: 0.2).delay(0.2)) {

//          updateTileColumn(coloumn: coloumn + 1)
      //  }
      }

      if updateTop, let topBlock = self.gameArray[coloumn][indexDestination - 1].block {


          self.score += block.value * 2

          withAnimation(.linear(duration: 0.2).delay(0.3)) {
            self.gameArray[coloumn][indexDestination - 1] = .block(Block(value: topBlock.value,
                                                                         position: CGPoint(x: topBlock.position.x, y: topBlock.position.y + sizeItem),
                                                                         color: topBlock.color,
                                                                         scale: 0.5))

            self.gameArray[coloumn][indexDestination] = .block(Block(value: block.value * 2,
                                                                     position: block.position,
                                                                     color: GameViewModel.colorForValue(value: block.value * 2)))
          }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 + 0.3) {
          self.gameArray[coloumn][indexDestination - 1] = .empty
        }

      //  withAnimation(.linear(duration: 0.2).delay(0.2)) {

//          updateTileColumn(coloumn: coloumn)
      //  }
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 + 0.3 + 0.1) {
        if updateTop {
          self.updateTileColumn(coloumn: coloumn, completion: completion)
        }
        if updateLeft {
          self.updateTileColumn(coloumn: coloumn - 1, completion: completion)
        }
        if updateRight {
          self.updateTileColumn(coloumn: coloumn + 1, completion: completion)
        }

        self.updateTile(indexDestination: indexDestination, coloumn: coloumn, completion: completion)

      }

    }
    else {
      completion()
      let stillHaveEmptyBlock = gameArray.flatMap { $0 }.first { $0 == .empty }

      if stillHaveEmptyBlock == nil {
        print("🔥 Game Over")
        self.playSound(sound: .gameOver)
        self.gameState = .over
        if score > bestScore {
          handle(action: .reportScore)
        }
      }
    }
  }

  private func updateTileColumn(coloumn: Int, completion: @escaping () -> Void) {

    for (index, item) in gameArray[coloumn].enumerated() {
      if self.gameArray[coloumn][index] == Item.empty {
        if index+1 < Constant.numerItemsInColumn, let block = gameArray[coloumn][index+1].block {

         // withAnimation(.linear(duration: 0.2)) {
            self.gameArray[coloumn][index] = .block(Block(value: block.value,
                                                          position: CGPoint(x: block.position.x,
                                                                            y: block.position.y - sizeItem - Constant.spacing),
                                                          color: block.color))
            self.gameArray[coloumn][index+1] = .empty
            updateTile(indexDestination: index, coloumn: coloumn, completion: completion)
          //}

         // if leftRight { updateTile(indexDestination: index, coloumn: coloumn) }
         // }
        }
      }
//      withAnimation(.linear(duration: 0.2).delay(0.2)) {
//        updateTile(indexDestination: index, coloumn: coloumn)
//      }
    }
   //
  }

  private static func getRandomValueForBloc() -> Shape {
    let indice = Int.random(in: 0..<Constant.values.count)
    return Constant.values[indice]
  }

  private static func colorForValue(value: Int) -> Color {
    return Shape.allCases.first{ $0.rawValue == value }?.color ?? .blue
  }

  func playSound(sound: GameModel.Sound) {
    guard UserDefaultHelper.get(for: Int.self, key: .sound) == 1,
          let url = Bundle.main.url(forResource: sound.name, withExtension: "mp3")
    else { return }

    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)

      avPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
      guard let avPlayer = avPlayer else { return }
      avPlayer.play()

    } catch let error {
      print(error.localizedDescription)
    }
  }
}

//struct GameViewModel_Previews: PreviewProvider {
//  static var previews: some View {
//    VStack {
//      GameView(viewModel: GameViewModel(displayContent: .constant(.game)))
//    }
//  }
//}


@available(iOS 16, *)
struct StoreKitReview {
  @Environment(\.requestReview) var requestReview

  @MainActor func requestReviewAction() {
    requestReview()
  }
}
