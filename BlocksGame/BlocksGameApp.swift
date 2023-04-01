//
//  BlocksGameApp.swift
//  BlocksGame
//
//  Created by Amine Arous on 29/03/2023.
//

import SwiftUI
import GoogleMobileAds

@main
struct BlocksGameApp: App {

  init() {
    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID, "d079f3732ca00d24d75f29ac3e362d4f" ]
  }
  var body: some Scene {
    WindowGroup {
      ContentView(viewModel: ContentViewModel())
    }
  }
}
