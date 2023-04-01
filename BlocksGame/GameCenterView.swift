//
//  GameCenterView.swift
//  BrainQuizMaster
//
//  Created by Amine Arous on 15/03/2023.
//

import SwiftUI
import GameKit

public struct GameCenterView: UIViewControllerRepresentable {
  let viewController: GKGameCenterViewController

  public init(leaderboardID : String?) {
    if leaderboardID != nil {
      self.viewController = GKGameCenterViewController(leaderboardID: leaderboardID!, playerScope: GKLeaderboard.PlayerScope.global, timeScope: GKLeaderboard.TimeScope.allTime)
    }
    else{
      self.viewController = GKGameCenterViewController(state: GKGameCenterViewControllerState.leaderboards)
    }
  }

  public func makeUIViewController(context: Context) -> GKGameCenterViewController {
    let gkVC = viewController
    gkVC.gameCenterDelegate = context.coordinator
    return gkVC
  }

  public func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {
    return
  }

  public func makeCoordinator() -> GKCoordinator {
    return GKCoordinator(self)
  }
}

public class GKCoordinator: NSObject, GKGameCenterControllerDelegate {
  var view: GameCenterView

  init(_ gkView: GameCenterView) {
    self.view = gkView
  }

  public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismiss(animated: true, completion: nil)
  }
}

enum Authenticate
{
  static func user() {

    let localPlayer = GKLocalPlayer.local
    localPlayer.authenticateHandler = { _, error in
      guard error == nil else {
        print(error?.localizedDescription ?? "")
        return
      }
      if UserDefaultHelper.get(for: Int.self, key: .bestScore) == 0 {
        getHighScoreFromLeadboard(leaderboard: ["general"])
      }
      GKAccessPoint.shared.isActive = false
    }
  }

  // Function that takes information and saves it to UserDefault
  static func getHighScoreFromLeadboard(leaderboard: [String]) ->Void {
    // Check if the user is authenticated
    if (GKLocalPlayer.local.isAuthenticated) {
      // Load the leaderboards that will be accessed
      GKLeaderboard.loadLeaderboards(
        IDs: leaderboard          // Leaderboards'id  that will be accessed
      ) { leaderboards, _ in          // completionHandler 01: .loadLeaderboards

        leaderboards?.forEach({ leaderboard in
          leaderboard.loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime) { player, _, _ in
            if let score = player?.score {
              let type: UserDefaultType = .bestScore
              print("Score game center \(score) for type \(type)")
              UserDefaultHelper.save(value: score, key: type)
            }
          }
        })
      }
    }
  }
}

