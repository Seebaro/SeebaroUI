//
//  AppInfo.swift
//  SeebaroUI
//
//  Created by Armin on 10/18/24.
//
import SwiftUI

public struct AppInfo: Identifiable {
    public init(
        id: UUID = UUID(),
        icon: String,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
    }
    
    public var id: UUID = UUID()
    public var icon: String
    public var title: LocalizedStringKey
    public var subtitle: LocalizedStringKey
}
