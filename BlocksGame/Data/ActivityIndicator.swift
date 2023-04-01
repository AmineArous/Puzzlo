//
//  ActivityIndicator.swift
//  CoolStory
//
//  Created by Amine on 05/06/2021.
//  Copyright © 2021 AmineArous. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.color = .white
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
