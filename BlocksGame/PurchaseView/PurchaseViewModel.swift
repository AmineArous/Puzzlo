//
//  PurchaseViewModel.swift
//  CoolStory
//
//  Created by AmineArous on 13/05/2021.
//  Copyright © 2021 AmineArous. All rights reserved.
//

import StoreKit

final class PurchaseViewModel: NSObject, ObservableObject {

  struct AlertIdentifier: Identifiable {
    enum Choice {
      case restoreFailed, restoreSuccess, cantMakePayments
    }
    var id: Choice
  }

  let productID = "com.mds.puzzlo.removeads"
  private let privacyLink = URL(string: "https://aminearous.github.io/puzzlolandingpage/privacypolicy/")!

  @Published private(set) var userDidPurshaseProduct: Bool = false
  @Published var alertIdentifier: AlertIdentifier? = nil
  @Published private(set) var productPrice: String = ""

  private var product: SKProduct? = nil

  enum Action {
    case setupPayementIAPIfNeeded
    case purchase
    case restore
    case userDidPurshaseProduct
    case userCantPurshaseProduct
    case openPrivacyWeb
  }

  enum RestoreState {
    case success
    case failure
  }

  func handle(action: Action) {
    switch action {

    case .setupPayementIAPIfNeeded:

      if SKPaymentQueue.canMakePayments() == false {
        self.alertIdentifier = AlertIdentifier(id: .cantMakePayments)
        return
      }

      if GameModel.removeAdsPurchase == false {
        SKPaymentQueue.default().add(self)
        self.fetchProducts()
      }

    case .purchase:
      guard let product = self.product else { return }
      self.buyProduct(product: product)

    case .restore:
      if SKPaymentQueue.canMakePayments() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
      }

    case .userDidPurshaseProduct:
      UserDefaultHelper.save(value: 1, key: .removeAds)
      UserDefaults.standard.synchronize()
      self.userDidPurshaseProduct = true

     // self.viewController.dismiss(animated: true, completion: nil)

    case .userCantPurshaseProduct:
      //self.viewController.dismiss(animated: true, completion: nil)
      break
    case .openPrivacyWeb:
      UIApplication.shared.open(privacyLink)
    }
  }

  private func fetchProducts() {
    if (SKPaymentQueue.canMakePayments()) {
      let productID: NSSet = NSSet(array: [productID])
      let productsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
      productsRequest.delegate = self
      productsRequest.start()
      print("Fetching Products")
    } else {
      print("can't make purchases")
      self.alertIdentifier = AlertIdentifier(id: .cantMakePayments)
    }
  }

  private func buyProduct(product: SKProduct) {
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }
}

//MARK: - SKProductsRequestDelegate

extension PurchaseViewModel: SKProductsRequestDelegate {

  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    let count : Int = response.products.count
    if (count>0) {
      let validProduct: SKProduct = response.products[0] as SKProduct
      if (validProduct.productIdentifier == productID as String) {
        self.product = validProduct
        DispatchQueue.main.async {
          let formatter = NumberFormatter()
          formatter.numberStyle = .currency
          formatter.locale = validProduct.priceLocale
          if let price = formatter.string(from: validProduct.price) {
            self.productPrice = price
          }
        }
      } else {
        print(validProduct.productIdentifier)
      }
    } else {
      print("nothing")
    }
  }

  func requestDidFinish(_ request: SKRequest) {
    print("requestDidFinish")
  }


  func request(_ request: SKRequest, didFailWithError error: Error) {
    print("didFailWithError \(error)")
  }
}

//MARK: - SKPaymentTransactionObserver

extension PurchaseViewModel: SKPaymentTransactionObserver {

  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction: AnyObject in transactions {
      if let trans: SKPaymentTransaction = transaction as? SKPaymentTransaction{
        switch trans.transactionState {
        case .purchased:
          self.handle(action: .userDidPurshaseProduct)
          //Do unlocking etc stuff here in case of new purchase
          SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
        case .failed:
          SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
        case .restored:
          self.alertIdentifier = AlertIdentifier(id: .restoreSuccess)
          SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
        default:
          break
        }
      }
    }
  }

  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    print("success")
  }

  func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
    print("error \(error)")
    self.alertIdentifier = AlertIdentifier(id: .restoreFailed)
  }

  func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
    return true
  }
}
