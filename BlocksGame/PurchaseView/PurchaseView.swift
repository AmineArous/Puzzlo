//
//  PurchaseViewController.swift
//  CoolStory
//
//  Created by AmineArous on 13/05/2021.
//  Copyright © 2021 AmineArous. All rights reserved.
//

import SwiftUI

struct PurchaseView: View {

  //MARK: - Private properties
  @ObservedObject private var viewModel: PurchaseViewModel

  init(viewModel: PurchaseViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {

    //NavigationView {

      ZStack {

//        Image("BoyHappy2")
//          .resizable()
//          .aspectRatio(contentMode: .fit)
//          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
//          .edgesIgnoringSafeArea(.all)

        VStack {
          Spacer()
          HStack() {
            VStack(alignment: .leading) {
              Text("kRemoveAdsTitle".localized())
                .foregroundColor(Color(UIColor.yellow))
                .font(.custom("FarelComic", fixedSize: 20))
              Text("kRemoveAdsDescription".localized())
                .foregroundColor(Color(UIColor.white))
                .font(.custom("FarelComic", fixedSize: 12))
            }
            Spacer()
            if GameModel.removeAdsPurchase {
              Text("kPurchased".localized())
                .foregroundColor(.green)
                .font(.custom("FarelComic", fixedSize: 20))
            } else {
              Button(action: {
                self.viewModel.handle(action: .purchase)
              }) {
                if self.viewModel.productPrice.isEmpty == false {
                  Text("kPrice".localized() + " " + self.viewModel.productPrice)
                    .font(.custom("FarelComic", fixedSize: 25))
                } else {
                  ActivityIndicator(isAnimating: .constant(true), style: .medium)
                }
              }
              .buttonStyle(GradientButtonStyle())
            }
          }
          .padding(16)

          .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(UIColor.borderPurchase), lineWidth: 1))
          .background(content: {
            Color.black
              .opacity(0.7)
          })
          .cornerRadius(8)
          .padding(32)
          Spacer()
          Button {
            self.viewModel.handle(action: .openPrivacyWeb)
          } label: {
            Text("kTermsOfUse".localized())
              .font(.custom("FarelComic", fixedSize: 20))
              .foregroundColor(.white)
              .padding(.top, 10)
              .padding(.horizontal, 10)
              .background(content: {
                Color.black
                  .opacity(0.5)
              })
              .cornerRadius(20)
          }
        }
        .padding(.bottom, 70)
        .onAppear {
          self.viewModel.handle(action: .setupPayementIAPIfNeeded)
        }
      }

      //.background(Color(.white))
      .alert(item: self.$viewModel.alertIdentifier) { alert in
                  switch alert.id {
                  case .restoreFailed:
                    return Alert(title: Text("🤷‍♂️"), message: Text("kFailPurchase".localized()), dismissButton: .cancel(Text("kClose".localized())))
                  case .restoreSuccess:
                    return Alert(title: Text("🥳"),
                          message: Text("kRestoredPurchase".localized()),
                          dismissButton: .cancel(Text("kClose".localized()), action: {
                            self.viewModel.handle(action: .userDidPurshaseProduct)
                          })
                    )
                  case .cantMakePayments:
                    return Alert(title: Text("😱"),
                          message: Text("kCantMakePayments".localized()),
                          dismissButton: .cancel(Text("kClose".localized()), action: {
                            self.viewModel.handle(action: .userCantPurshaseProduct)
                          })
                    )
                  }
              }
      .navigationBarItems(trailing:
                            Button(action: { self.viewModel.handle(action: .restore) },
                                   label: {
        Text("kRestore".localized())
          .font(.custom("FarelComic", fixedSize: 20))
          .foregroundColor(.white)
          .padding(.top, 10)
          .padding(.horizontal, 10)
          .background(content: {
            Color.black
              .opacity(0.5)
          })
          .cornerRadius(10)
          .padding(.top, 30)
      })
      )
//    }
//    .navigationViewStyle(StackNavigationViewStyle())

  }
}

struct GradientButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .foregroundColor(Color.white)
      .padding()
      .background(Color.blue)
      .cornerRadius(8.0)
  }
}

struct PurchaseView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      PurchaseView(viewModel: PurchaseViewModel())
    }
  }
}
