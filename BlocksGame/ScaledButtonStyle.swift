//
//  ScaledButtonStyle.swift
//  BlocksGame
//
//  Created by Amine Arous on 30/03/2023.
//

import SwiftUI

 struct ScaledButtonStyle: ButtonStyle {

   private enum Constants {
     enum Scale {
       static let identity: CGFloat = 1.0
       static let buttonPressed: CGFloat = 0.9
     }
   }
   @State private var scale: CGFloat = Constants.Scale.identity
   func makeBody(configuration: Configuration) -> some View {
     configuration.label
       .scaleEffect(scale)
       .onChange(of: configuration.isPressed) { newValue in
         scale = newValue ? Constants.Scale.buttonPressed : Constants.Scale.identity
       }
   }
 }

struct NeumorphicButtonStyle: ButtonStyle {
  private enum Constants {
    enum Scale {
      static let identity: CGFloat = 1.0
      static let buttonPressed: CGFloat = 0.95
    }
  }
  @State private var scale: CGFloat = Constants.Scale.identity
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            //.padding(20)
        .minimumScaleFactor(0.6)
            .background(
              ZStack {
                RoundedRectangle(cornerRadius: 20)
                  .fill(Color.white)
//                  .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 5, y: 5)
//                  .shadow(color: Color.white.opacity(0.7), radius: 5, x: -5, y: -5)
                RoundedRectangle(cornerRadius: 20)
                  .fill(Color(hex: "FFA07A"))
                  .padding(2)
              }
            )
            .scaleEffect(scale)
            .onChange(of: configuration.isPressed) { newValue in
              scale = newValue ? Constants.Scale.buttonPressed : Constants.Scale.identity
            }
    }
}

struct CapsuleButtonStyle: ButtonStyle {
  private enum Constants {
    enum Scale {
      static let identity: CGFloat = 1.0
      static let buttonPressed: CGFloat = 0.95
    }
  }
  @State private var scale: CGFloat = Constants.Scale.identity
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            //.padding(20)
        .minimumScaleFactor(0.6)
            .background(
                ZStack {
                    Capsule()
                        .fill(Color.white)
//                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 5, y: 5)
//                        .shadow(color: Color.white.opacity(0.7), radius: 5, x: -5, y: -5)
                    Capsule()
                        .fill(Color(hex: "FF69B4"))
                        .padding(2)
                }
            )
            .scaleEffect(scale)
            .onChange(of: configuration.isPressed) { newValue in
              scale = newValue ? Constants.Scale.buttonPressed : Constants.Scale.identity
            }
    }
}
