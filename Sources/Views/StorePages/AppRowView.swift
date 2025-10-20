//
//  AppRowView.swift
//  SeebaroUI
//
//  Created by Armin on 10/15/25.
//

import NukeUI
import SwiftUI

public struct AppRowView: View {
    public init(
        title: String,
        subtitlte: String,
        icon: String,
        actionTitle: LocalizedStringResource = "Install",
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitlte = subtitlte
        self.icon = icon
        self.actionTitle = actionTitle
        self.action = action
    }
    
    let title: String
    let subtitlte: String
    let icon: String
    let actionTitle: LocalizedStringResource
    let action: () -> Void
    
    public var body: some View {
        HStack(spacing: 15) {
            LazyImage(url: URL(string: icon)) { state in
                if let image = state.image {
                    image.resizable()
                } else {
                    Color.gray
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .clipShape(.rect(cornerRadius: 12))
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(subtitlte)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: action) {
                Text(actionTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .controlSize(.regular)
            .apply {
                if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, *) {
                    $0
                      .tint(.accentColor)
                      .buttonStyle(.glass)
                } else {
                    $0.buttonStyle(.bordered)
                }
            }
        }
    }
}

#Preview {
    List {
        AppRowView(
            title: "Seebaro",
            subtitlte: "The Store",
            icon: "https://seebaro.ir/apple-touch-icon.png",
            action: {}
        )
        AppRowView(
            title: "Archived App",
            subtitlte: "Unavailable",
            icon: "",
            action: {}
        )
    }
}
