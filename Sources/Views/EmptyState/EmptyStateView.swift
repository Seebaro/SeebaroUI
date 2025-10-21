//
//  EmptyStateView.swift
//  SeebaroUI
//
//  Created by Armin on 9/27/24.
//

import SwiftUI

public struct EmptyStateView: View {
    public init(
        icon: String,
        title: LocalizedStringResource,
        description: LocalizedStringResource,
        actionTitle: LocalizedStringResource? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.action = action
    }
    
    let icon: String
    let title: LocalizedStringResource
    let description: LocalizedStringResource
    
    let actionTitle: LocalizedStringResource?
    let action: (() -> Void)?
    
    public var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: icon)
                #if os(watchOS)
                .font(.title3)
                #else
                .font(.largeTitle)
                #endif
                .symbolRenderingMode(.multicolor)
                .apply {
                    if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, *) {
                        $0.symbolColorRenderingMode(.gradient)
                    }
                }
        } description: {
            Text(description)
                #if os(watchOS)
                .font(.body)
                #else
                .font(.headline)
                #endif
        } actions: {
            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.body)
                        #if os(watchOS)
                        .padding(.horizontal)
                        #endif
                }
                #if os(watchOS)
                .tint(.accentColor)
                .buttonStyle(.bordered)
                #endif
            }
        }
    }
}

#Preview {
    EmptyStateView(
        icon: "swift",
        title: "Header title",
        description: "Some description for the empty state",
        actionTitle: "An action title",
        action: {}
    )
}
