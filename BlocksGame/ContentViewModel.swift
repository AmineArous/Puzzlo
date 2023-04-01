//
//  ContentViewModel.swift
//  BlocksGame
//
//  Created by Amine Arous on 31/03/2023.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
  private let adMobService: AdMobServiceProtocol

  init(adMobService: AdMobServiceProtocol = AdMobService()) {
    self.adMobService = adMobService
    Task {
      self.adMobService.prepareInterstitualPub()
    }
  }

  func getAdbannerView() -> AnyView {
    adMobService.getAdbannerView()
  }

  func showInterstitialPub() {
    adMobService.showInterstitialPub()
  }
}
