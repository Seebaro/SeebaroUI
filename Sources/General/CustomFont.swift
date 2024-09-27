//
//  CustomFont.swift
//  SeebaroUI
//
//  Created by Armin on 9/27/24.
//

import SwiftUI

extension UXFont {
    static func custom(name: String, style: UXFont.TextStyle) -> UXFont {
        return UXFont(
            name: name,
            size: UXFont.preferredFont(forTextStyle: style).pointSize
        )!
    }
}

extension Font {
    static func customFont(
        name: String,
        style: UXFont.TextStyle,
        weight: Font.Weight = .regular
    ) -> Font {
        return Font
            .custom(
                name,
                size: UXFont.preferredFont(forTextStyle: style).pointSize
            )
            .weight(weight)
    }
}
