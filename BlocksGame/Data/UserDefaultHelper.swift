//
//  UserDefaultHelper.swift
//  Puzzle
//
//  Created by Amine Arous on 10/02/2023.
//

import Foundation

public enum UserDefaultType: String {
    case removeAds
    case bestScore
    case activeAppCount
    case sound

  var defaultValue: Int {
    switch self {
    case .removeAds:
      return 0
    case .bestScore:
      return 0
    case .activeAppCount:
      return 0
    case .sound:
      return 1
    }
  }
}

final class UserDefaultHelper {
    private static let gameArrayKey = "gameArrayKey"
    private static let wordsPlacedKey = "wordsPlacedKey"

    static func save<T>(value:T, key: UserDefaultType) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    static func get<T>(for type:T.Type, key: UserDefaultType) -> T {

        if let value = UserDefaults.standard.value(forKey: key.rawValue) as? T {
            return value
        }

        return key.defaultValue as! T
    }

//  static func saveGameStateData(_ data: ContentViewModel.GameStateData) {
//    UserDefaults.standard.set(try? PropertyListEncoder().encode(data.gameArray), forKey: gameArrayKey)
//    UserDefaults.standard.set(try? PropertyListEncoder().encode(data.wordsPlaced), forKey: wordsPlacedKey)
//    UserDefaults.standard.synchronize()
//  }
//
//  static func getGameStateData() -> ContentViewModel.GameStateData? {
//    guard let dataGameArray = UserDefaults.standard.value(forKey: gameArrayKey) as? Data,
//          let dataWordsPlaced = UserDefaults.standard.value(forKey: wordsPlacedKey) as? Data,
//          let gameArray = try? PropertyListDecoder().decode([[ContentViewModel.TileItem]].self, from: dataGameArray),
//          let wordsPlaced = try? PropertyListDecoder().decode([ContentViewModel.PlayerWord].self, from: dataWordsPlaced)
//    else { return nil }
//    return ContentViewModel.GameStateData(gameArray: gameArray, wordsPlaced: wordsPlaced)
//  }
}
