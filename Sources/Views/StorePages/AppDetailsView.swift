//
//  AppDetailsView.swift
//  SeebaroUI
//
//  Created by Armin on 10/3/24.
//

import NukeUI
import SwiftUI

struct AppDetailsView {
    public init(
        icon: String,
        name: String,
        subtitle: String,
        description: String,
        details: [AppInfo],
        detailsSectionTitle: LocalizedStringKey = "Details",
        screenshots: [URL],
        screenshotAspectRatio: CGFloat?,
        screenshotsSectionTitle: LocalizedStringKey = "Screenshots",
        installTitle: LocalizedStringKey,
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
    public var detailsSectionTitle: LocalizedStringKey
    public var screenshots: [URL]
    public var screenshotAspectRatio: CGFloat
    public var screenshotsSectionTitle: LocalizedStringKey
    public var installTitle: LocalizedStringKey
    public var installAction: () -> Void
}

extension AppDetailsView {
    private var iconSize: CGFloat {
        #if os(watchOS)
        return 64
        #else
        return 125
        #endif
    }
    
    private var iconShape: some Shape {
        #if os(watchOS) || os(visionOS)
        return Circle()
        #else
        return RoundedRectangle(cornerRadius: 27)
        #endif
    }
    
    private var screenshotHeight: CGFloat {
        #if os(watchOS)
        return 150
        #else
        return 250
        #endif
    }
}

extension AppDetailsView: View {
    public var body: some View {
        List {
            appInfoSection
            appDetailsSection
            if !screenshots.isEmpty { screenshotsSection }
            detailsSection
        }
    }
    
    @MainActor
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
        .listRowBackground(Color.clear)
        #if os(macOS)
        .padding(.bottom)
        #endif
    }
    
    @MainActor
    private var appDetailsSection: some View {
        Section {
            appInfoView
                .listRowInsets(.init())
        }
    }
    
    @MainActor
    private var screenshotsSection: some View {
        Section(screenshotsSectionTitle) {
            screenshotsView
                .listRowInsets(.init())
                .listRowBackground(Color.clear)
        }
        .headerProminence(.increased)
    }
    
    private var detailsSection: some View {
        Section(detailsSectionTitle) {
            Text(description)
        }
        .headerProminence(.increased)
    }
}

extension AppDetailsView {
    @MainActor
    var iconImage: some View {
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
    
    var nameText: some View {
        Text(name)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var subtitleText: some View {
        Text(subtitle)
            .font(.callout)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @MainActor
    var installButton: some View {
        Button(action: installAction) {
            Text(installTitle)
                .frame(minWidth: 60)
                .font(.body.weight(.semibold))
                #if os(macOS)
                .padding(.vertical, 5)
                #endif
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle)
        #if os(macOS)
        .apply {
            if #available(macOS 14.0, *) {
                $0.clipShape(.capsule)
            } else {
                $0
            }
        }
        #else
        .clipShape(.capsule)
        .controlSize(.mini)
        #endif
    }
    
    @MainActor
    var appInfoView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(details) { detail in
                    VStack {
                        Label(detail.title, systemImage: detail.icon)
                                .font(.caption)
                            
                            Text(detail.subtitle)
                                .font(.body)
                                .fontWeight(.bold)
                    }
                    .lineLimit(1)
                    .padding(.horizontal)
                    
                    if detail != details.last {
                        Divider()
                    }
                }
            }
            .foregroundStyle(.secondary)
            .padding()
        }
        .apply {
            if #available(iOS 17.0, macOS 14.0, *) {
                $0.scrollTargetBehavior(.viewAligned)
            } else { $0 }
        }
    }
    
    @MainActor
    var screenshotsView: some View {
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
        .apply {
            if #available(iOS 17.0, macOS 14.0, *) {
                $0.scrollTargetBehavior(.paging)
            } else { $0 }
        }
    }
}

@available(iOS 16.0, macOS 13.0, *)
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
            installTitle: "Get",
            installAction: {}
        )
        .navigationTitle("Details")
    }
}
