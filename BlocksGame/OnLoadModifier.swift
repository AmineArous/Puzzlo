//
//  OnLoadModifier.swift
//  BlocksGame
//
//  Created by Amine Arous on 01/04/2023.
//

import SwiftUI

struct OnLoadModifier: ViewModifier {
  let perform: () -> Void
  @State private var loaded = false

  func body(content: Content) -> some View {
    content.onAppear {
      if !loaded {
        perform()
        loaded = true
      }
    }
  }
}

public extension View {
  func onLoad(_ perform: @escaping () -> Void) -> some View {
    modifier(OnLoadModifier(perform: perform))
  }
}

