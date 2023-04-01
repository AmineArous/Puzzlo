//
//  AdMobService.swift
//  TicTacToe
//
//  Created by Amine Arous on 08/03/2023.


import Foundation
import GoogleMobileAds
import SwiftUI

protocol AdMobServiceProtocol {
  func getAdbannerView() -> AnyView

  func isAdMobPubEnabled() -> Bool

  func showInterstitialPub()
  func prepareInterstitualPub()
  func prepareAndShowInterstitualPub()

  func prepareRewardedInterstitialAd(failure: @escaping () -> Void)
  func prepareAndShowRewardedInterstitialAd(completion: @escaping () -> Void, failure: @escaping () -> Void)
  func showRewardedInterstitialAd(completion: @escaping () -> Void)

  func handleActiveAppMode()
}

class AdMobService: AdMobServiceProtocol {

  private var interstitial: GADInterstitialAd?
  private var rewardedInterstitialAd: GADRewardedAd?

  private static let bannerUnitID = "ca-app-pub-8207888206645541/2845796168"
  private static let interstitialAdUnitID = "ca-app-pub-8207888206645541/4697099738"
  private static let rewardedInterstitialAdUnitID = "ca-app-pub-8207888206645541/6401897799"

  var adMobPubIsEnabled = false

  func isAdMobPubEnabled() -> Bool {
    return adMobPubIsEnabled
  }

  func getAdbannerView() -> AnyView {
    AnyView(
      GeometryReader { proxy in
        ZStack {
          VStack {
            Spacer()
            GADBannerViewController()
              .frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
          }
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
      }
    )
  }

  func showInterstitialPub() {
    guard GameModel.removeAdsPurchase == false, let interstitial, let rootViewController = NavigationUtil.getRootViewController() else { return }
    DispatchQueue.main.async {
      interstitial.present(fromRootViewController: rootViewController)
    }
  }

  func showRewardedInterstitialAd(completion: @escaping () -> Void) {
    guard let rewardedInterstitialAd, let rootViewController = NavigationUtil.getRootViewController() else { return }
    DispatchQueue.main.async {
      rewardedInterstitialAd.present(fromRootViewController: rootViewController, userDidEarnRewardHandler: {
        completion()
      })
    }
  }

  func prepareInterstitualPub() {
    guard GameModel.removeAdsPurchase == false else { return }
    let request = GADRequest()
    DispatchQueue.main.async {
      request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    DispatchQueue.global(qos: .userInitiated).async {
      GADInterstitialAd.load(withAdUnitID: AdMobService.interstitialAdUnitID,
                             request: request,
                             completionHandler: { [self] ad, error in
        if let error = error {
          print("Failed to load interstitial ad with error: \(error.localizedDescription)")
          return
        }
        self.interstitial = ad
      })
    }
  }

  func prepareRewardedInterstitialAd(failure: @escaping () -> Void) {
    guard GameModel.removeAdsPurchase == false else { return }
    let request = GADRequest()
    DispatchQueue.main.async {
      request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    DispatchQueue.global(qos: .userInitiated).async {

      GADRewardedAd.load(withAdUnitID: AdMobService.rewardedInterstitialAdUnitID,
                                     request: request,
                                     completionHandler: { [self] ad, error in
        if let error = error {
          self.adMobPubIsEnabled = false
          failure()
          print("Failed to load interstitial ad with error: \(error.localizedDescription)")
          return
        }
        self.adMobPubIsEnabled = true
        self.rewardedInterstitialAd = ad
      })
    }
  }

  func prepareAndShowInterstitualPub() {
    guard GameModel.removeAdsPurchase == false else { return }
    let request = GADRequest()
    DispatchQueue.main.async {
      request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    DispatchQueue.global(qos: .userInitiated).async {
      GADInterstitialAd.load(withAdUnitID: AdMobService.interstitialAdUnitID,
                             request: request,
                             completionHandler: { [self] ad, error in
        if let error = error {
          print("Failed to load interstitial ad with error: \(error.localizedDescription)")
          return
        }
        self.interstitial = ad
        DispatchQueue.main.async {
          self.showInterstitialPub()
        }
      })
    }
  }

  func prepareAndShowRewardedInterstitialAd(completion: @escaping () -> Void, failure: @escaping () -> Void) {
    let request = GADRequest()
    DispatchQueue.main.async {
      request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    DispatchQueue.global(qos: .userInitiated).async {

      GADRewardedAd.load(withAdUnitID: AdMobService.rewardedInterstitialAdUnitID,
                                     request: request,
                                     completionHandler: { [self] ad, error in
        if let error = error {
          self.adMobPubIsEnabled = false
          failure()
          print("Failed to load interstitial ad with error: \(error.localizedDescription)")
          return
        }
        self.adMobPubIsEnabled = true
        self.rewardedInterstitialAd = ad
        DispatchQueue.main.async {
          self.showRewardedInterstitialAd(completion: completion)
        }
      })
    }
  }

  func handleActiveAppMode() {
    if GameModel.activeAppCount == 2 {
      AdMobService().prepareAndShowInterstitualPub()
      GameModel.resetActiveAppCount()
    } else {
      GameModel.incrementActiveAppCount()
    }
  }
}

extension AdMobService {
  struct GADBannerViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
      let view = GADBannerView(adSize: GADAdSizeBanner)
      let viewController = BannerViewController()
      view.adUnitID = AdMobService.bannerUnitID

      view.delegate = viewController
      let request = GADRequest()
     // DispatchQueue.main.async {
        view.rootViewController = viewController
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
      //}
      DispatchQueue.global(qos: .userInitiated).async {
        view.load(request)
      }
      return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
  }

  class BannerViewController: UIViewController, GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
  }
}
