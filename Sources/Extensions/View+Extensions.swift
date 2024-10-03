//
//  View+Extensions.swift
//  SeebaroUI
//
//  Created by Armin on 10/3/24.
//

import SwiftUI

extension View {
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
}
