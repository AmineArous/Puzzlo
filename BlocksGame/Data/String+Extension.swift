//
//  String+Extension.swift
//  CoolStory
//
//  Created by AmineArous on 13/05/2021.
//  Copyright © 2021 AmineArous. All rights reserved.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}

