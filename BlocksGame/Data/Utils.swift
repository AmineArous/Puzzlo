//
//  Utils.swift
//  Example
//
//  Created by Alisa Mylnikova on 10/06/2021.
//

import SwiftUI

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    var rgbValue: UInt64 = 0
    scanner.scanHexInt64(&rgbValue)

    let r = (rgbValue & 0xff0000) >> 16
    let g = (rgbValue & 0xff00) >> 8
    let b = rgbValue & 0xff

    self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
  }

  static var random: Color {
    return Color(
      red: .random(in: 0.0...1.0),
      green: .random(in: 0.0...1.0),
      blue: .random(in: 0.0...1.0)
    )
  }
}

extension View {

  @ViewBuilder
  func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
    if condition {
      apply(self)
    } else {
      self
    }
  }

  func shadowedStyle() -> some View {
    self
      .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
      .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
  }

  func customButtonStyle(
    foreground: Color = .black,
    background: Color = .white
  ) -> some View {
    self.buttonStyle(
      ExampleButtonStyle(
        foreground: foreground,
        background: background
      )
    )
  }

#if os(iOS)
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
#endif
}

private struct ExampleButtonStyle: ButtonStyle {
  let foreground: Color
  let background: Color

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .opacity(configuration.isPressed ? 0.45 : 1)
      .foregroundColor(configuration.isPressed ? foreground.opacity(0.55) : foreground)
      .background(configuration.isPressed ? background.opacity(0.55) : background)
  }
}

#if os(iOS)
struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}
#endif

extension String {
  func removingWhitespaces() -> String {
    return components(separatedBy: .whitespaces).joined()
  }
}
