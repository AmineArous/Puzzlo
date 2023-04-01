//
//  GameBackgroundView.swift
//  TicTacToe
//
//  Created by Amine Arous on 07/03/2023.
//

import SwiftUI

struct GameBackgroundView: View {

  var body: some View {
    GeometryReader { proxy in
      ZStack {
        Image("Background")
          .resizable()
        .aspectRatio(contentMode: .fill)
        .edgesIgnoringSafeArea(.all)
      }
      .frame(width: proxy.size.width, height: proxy.size.height)
    }
    .edgesIgnoringSafeArea(.all)
  }
}

struct GameBackgroundView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      GameBackgroundView()
    }
  }
}
