//
//  GameModel.swift
//  TicTacToe
//
//  Created by Amine Arous on 07/03/2023.
//

import Foundation
import SwiftUI

enum GameModel {

  static var removeAdsPurchase: Bool {
    //return true
    UserDefaultHelper.get(for: Int.self, key: .removeAds) == 1
  }

  static var activeAppCount: Int {
    UserDefaultHelper.get(for: Int.self, key: .activeAppCount)
  }

  static func incrementActiveAppCount() {
    UserDefaultHelper.save(value: GameModel.activeAppCount + 1, key: .activeAppCount)
  }

  static func resetActiveAppCount() {
    UserDefaultHelper.save(value: 0, key: .activeAppCount)
  }

  enum Sound {
    case nothing
    case match
    case gameOver
    case win

    var name: String {
      switch self {
      case .nothing:
        return "nothing"
      case .match:
        return "match"
      case .gameOver:
        return "match"
      case .win:
        return "win"
      }
    }
  }
}
