//
//  String+Extension.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 01.12.2020.
//

import Foundation

extension StringProtocol {
        var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
        var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
    }
