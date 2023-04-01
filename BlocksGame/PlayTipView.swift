//
//  PlayTipView.swift
//  PuzzledWords
//
//  Created by Amine Arous on 19/03/2023.
//

import SwiftUI


struct PlayTipView: View {

  let message: String

  var body: some View {
    VStack {
      HStack(spacing: 0) {
        Spacer()
        Text(message)
          .font(.custom("FarelComic", fixedSize: 25))
          .multilineTextAlignment(.center)
          .foregroundColor(.white)
          .padding(.top, 10)
          .padding(.horizontal, 10)
          .background(content: {
            Color(hex: "87CEFA").opacity(0.8)
          })
          .cornerRadius(20)
        Spacer()
      }
    }
    .padding(.horizontal, 16)
  }
}

struct PlayTipView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      PlayTipView(message: "Tap on columns to play")
    }
  }
}
