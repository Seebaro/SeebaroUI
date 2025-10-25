//
//  AppInfo.swift
//  SeebaroUI
//
//  Created by Armin on 10/18/24.
//
import SwiftUI

public struct AppInfo: Identifiable, Equatable {
    public init(
        id: UUID = UUID(),
        icon: String,
        title: LocalizedStringKey,
        subtitle: String
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
    }
    
    public var id: UUID = UUID()
    public var icon: String
    public var title: LocalizedStringKey
    public var subtitle: String
}
