//
//  CounterView.swift
//  TicTacToe
//
//  Created by Amine Arous on 09/03/2023.
//

import Foundation
import SwiftUI

struct ComboCounterView: View {

  static let animationDuration: Double = 0.75
  var toColor: Color = .white.opacity(0.8)
  var fromColor: Color = .white.opacity(0.8)
  @State private var outerTrimEnd: CGFloat = 0
  @State private var strokeColor = Color.black
  @State private var scale = 1.0
  @State private var stopAnimate = false
  @Binding var isPresented: Bool

  private let comboNumer: Int

  init(comboNumer: Int, isPresented: Binding<Bool>) {
    self.comboNumer = comboNumer
    self._isPresented = isPresented
  }

  var body: some View {
    Text("\(comboNumer) combos")
      .font(.custom("FarelComic", fixedSize: 30))
      .frame(width: 300, height: 100)
      .foregroundColor(.white)
      .shadow(color: .black, radius: 10)
      .scaleEffect(scale)
      .onAppear {
        startAnimate()
      }
  }

  func startAnimate() {
    stopAnimate = false
    scale = 0.0
    animate()
  }

  private func animate() {
    guard stopAnimate == false else { return }
    
    withAnimation(.linear(duration: ComboCounterView.animationDuration)) {
      scale = 2.0
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + ComboCounterView.animationDuration) {
      stopAnimate = true
      self.isPresented = false
    }
  }
}

struct ComboCounterView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      ComboCounterView(comboNumer: 2, isPresented: .constant(true))
        .background {
          Color.blue
        }
    }
  }
}
