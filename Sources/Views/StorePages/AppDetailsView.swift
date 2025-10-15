//
//  AppDetailsView.swift
//  SeebaroUI
//
//  Created by Armin on 10/3/24.
//

import NukeUI
import SwiftUI

struct AppDetailsView: View {
    public init(
        icon: String,
        name: String,
        subtitle: String,
        description: String,
        details: [AppInfo],
        detailsSectionTitle: LocalizedStringResource = "Details",
        screenshots: [URL],
        screenshotAspectRatio: CGFloat?,
        screenshotsSectionTitle: LocalizedStringResource = "Screenshots",
        installTitle: LocalizedStringResource,
        installAction: @escaping () -> Void
    ) {
        self.icon = icon
        self.name = name
        self.subtitle = subtitle
        self.description = description
        self.details = details
        self.detailsSectionTitle = detailsSectionTitle
        self.screenshots = screenshots
        self.screenshotAspectRatio = screenshotAspectRatio ?? 1
        self.screenshotsSectionTitle = screenshotsSectionTitle
        self.installTitle = installTitle
        self.installAction = installAction
    }
    
    public var icon: String
    public var name: String
    public var subtitle: String
    public var description: String
    public var details: [AppInfo]
    public var detailsSectionTitle: LocalizedStringResource
    public var screenshots: [URL]
    public var screenshotAspectRatio: CGFloat
    public var screenshotsSectionTitle: LocalizedStringResource
    public var installTitle: LocalizedStringResource
    public var installAction: () -> Void
    
    private var iconSize: CGFloat {
        #if os(watchOS)
        return 64
        #else
        return 100
        #endif
    }
    
    private var iconShape: some Shape {
        #if os(watchOS) || os(visionOS)
        return Circle()
        #else
        return RoundedRectangle(cornerRadius: 24)
        #endif
    }
    
    private var screenshotHeight: CGFloat {
        #if os(watchOS)
        return 150
        #else
        return 250
        #endif
    }
    
    public var body: some View {
        List {
            appInfoSection
            appDetailsSection
            if !screenshots.isEmpty { screenshotsSection }
            detailsSection
        }
    }
    
    private var appInfoSection: some View {
        Section {
            #if os(watchOS)
            VStack {
                HStack {
                    iconImage
                    
                    Spacer()
                    
                    installButton
                        .frame(maxWidth: 72)
                }
                
                nameText
                subtitleText
            }
            #else
            HStack(spacing: 20) {
                iconImage
                
                VStack(alignment: .leading) {
                    nameText
                    
                    subtitleText
                    
                    Spacer()
                    
                    installButton
                }
            }
            #endif
            
        }
        .listRowInsets(.init())
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        #if os(macOS)
        .padding(.bottom)
        #endif
    }
    
    private var appDetailsSection: some View {
        Section {
            appInfoView
                .listRowInsets(.init())
        }
        .listRowSeparator(.hidden)
    }
    
    private var screenshotsSection: some View {
        Section(screenshotsSectionTitle) {
            screenshotsView
                .listRowBackground(Color.clear)
        }
        .headerProminence(.increased)
        .listRowSeparator(.hidden)
    }
    
    private var detailsSection: some View {
        Section(detailsSectionTitle) {
            Text(description)
        }
        .headerProminence(.increased)
        .listRowSeparator(.hidden)
    }
    
    private var iconImage: some View {
        LazyImage(url: URL(string: icon)) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                .shadow(radius: 2)
            } else {
                Rectangle()
                    .fill(.tertiary.opacity(0.5))
                    .frame(width: iconSize, height: iconSize)
            }
        }
        .frame(maxWidth: iconSize, maxHeight: iconSize)
        .clipShape(iconShape)
    }
    
    private var nameText: some View {
        Text(name)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var subtitleText: some View {
        Text(subtitle)
            .font(.callout)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var installButton: some View {
        Button(action: installAction) {
            Text(installTitle)
                .font(.body)
                .fontWeight(.bold)
        }
        .buttonStyle(.borderedProminent)
        #if os(macOS)
        .controlSize(.large)
        #else
        .controlSize(.regular)
        #endif
    }
    
    private var appInfoView: some View {
        HStack {
            ForEach(details) { detail in
                VStack {
                    HStack {
                        Image(systemName: detail.icon)
                        Text(detail.title)
                            .lineLimit(1)
                            .fixedSize()
                    }
                    .font(.caption)
                    
                    Text(detail.subtitle)
                        .font(.body)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .fixedSize()
                }
                .lineLimit(1)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                
                if detail != details.last {
                    Divider()
                }
            }
        }
        .foregroundStyle(.secondary)
        .padding()
    }
    
    private var screenshotsView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(screenshots, id: \.self) { screenshot in
                    Button {
                        // TODO: Implement expanding screenshots
                    } label: {
                        LazyImage(url: screenshot) { state in
                            if let image = state.image {
                                image
                                    .resizable()
                            } else {
                                Rectangle()
                            }
                        }
                        .aspectRatio(screenshotAspectRatio, contentMode: .fill)
                        .frame(height: screenshotHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AppDetailsView(
            icon: "https://api.seebaro.ir/media/icons/17aa53e4-1f85-4191-bb16-5d4529cd1e8d.png",
            name: "Seebaro",
            subtitle: "Alternative AppStore",
            description: "Seebaro is the alternative AppStore for iOS and macOS that provides a more secure and user-friendly experience. It offers a wide range of apps, including games, music, movies, and more. Seebaro is designed to be easy to use and navigate, with a focus on security and privacy. It also provides a variety of features, such as app recommendations, in-app purchases, and a search bar that allows users to find apps easily. Seebaro is a great choice for anyone who wants to use an alternative AppStore that provides a secure and user-friendly experience. It is also a great choice for anyone who wants to use an alternative AppStore that provides a secure and user-friendly experience. It is also a great choice for anyone who wants to use an alternative AppStore that provides a secure and user-friendly experience.",
            details: [
                .init(
                    icon: "arrow.down.app.dashed",
                    title: "Version",
                    subtitle: "1.0.0"
                ),
                .init(
                    icon: "externaldrive",
                    title: "Size",
                    subtitle: "2.6 MB"
                ),
                .init(
                    icon: "calendar",
                    title: "Updated date",
                    subtitle: "\(Date.now.formatted(date: .abbreviated, time: .omitted))"
                ),
            ],
            screenshots: [
                URL(string: "https://api.seebaro.ir/media/screenshots/82f09899-58cd-49d3-829f-32bda5a75fe0.png")!,
                URL(string: "https://api.seebaro.ir/media/screenshots/920c775d-7961-48d7-a317-75b83db7ed2d.png")!,
                URL(string: "https://api.seebaro.ir/media/screenshots/4d0f7c19-7941-4166-a149-b031a22168c6.png")!,
            ],
            screenshotAspectRatio: 0.4612676056,
            installTitle: "Install",
            installAction: {}
        )
        .navigationTitle("Details")
    }
}
