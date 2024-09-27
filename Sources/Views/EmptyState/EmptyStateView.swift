//
//  EmptyStateView.swift
//  SeebaroUI
//
//  Created by Armin on 9/27/24.
//

import SwiftUI

struct EmptyStateView: View {
    
    var icon: String
    var title: LocalizedStringKey
    var description: LocalizedStringKey
    
    var showAction: Bool = true
    var actionTitle: LocalizedStringKey? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        Group {
            if #available(iOS 17.0, macOS 14.0, visionOS 1.0, watchOS 10.0, *) {
                ContentUnavailableView {
                    Label(title, systemImage: icon)
                        #if os(watchOS)
                        .font(.title3)
                        #else
                        .font(.largeTitle)
                        #endif
                } description: {
                    Text(description)
                        #if os(watchOS)
                        .font(.body)
                        #else
                        .font(.headline)
                        #endif
                } actions: {
                    if let actionTitle, let action, showAction {
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
            } else {
                backwardView
            }
        }
    }
    
    var backwardView: some View {
        VStack {
            Image(systemName: icon)
                #if os(iOS)
                .font(.largeTitle)
                .dynamicTypeSize(.accessibility2)
                .foregroundStyle(.secondary)
                #else
                .font(.system(size: 36))
                .foregroundStyle(.tertiary)
                #endif
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.all, 12)
                #if os(iOS)
                .foregroundStyle(.primary)
                #else
                .foregroundStyle(.secondary)
                #endif
        }
    }
}

#Preview {
    EmptyStateView(
        icon: "swift",
        title: "Header title",
        description: "Some description for the empty state",
        showAction: true,
        actionTitle: "An action title",
        action: {}
    )
}
