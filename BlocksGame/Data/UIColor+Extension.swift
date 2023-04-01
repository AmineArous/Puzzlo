//
//  UIColor+Extension.swift
//  CoolStory
//
//  Created by AmineArous on 10/05/2021.
//  Copyright © 2021 AmineArous. All rights reserved.
//

import UIKit

extension UIColor {
  static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
    guard #available(iOS 13.0, *) else { return light }
    return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
  }
}

extension UIColor {
  static let background: UIColor = dynamicColor(light: .white, dark: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))

  static let tintTabBar: UIColor = dynamicColor(light: .black, dark: .white)
  static let tintButton: UIColor = dynamicColor(light: .black, dark: .white)
  static let tintNavigationBar: UIColor = dynamicColor(light: .black, dark: .white)

  static let tintActivityIndicatorView: UIColor = dynamicColor(light: .black, dark: .white)

  static let tintLabel: UIColor = dynamicColor(light: .black, dark: .white)

  static let backgroundPurchase: UIColor = dynamicColor(light: .lightGray, dark: .lightGray)

  static let labelPurchase: UIColor = dynamicColor(light: .black, dark: .white)

  static let borderPurchase: UIColor = dynamicColor(light: .black, dark: .white)
}
