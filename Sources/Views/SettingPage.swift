//
//  SettingPage.swift
//  Setting
//
//  Created by A. Zheng (github.com/aheze) on 2/21/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

/**
 A settings page.
 */
public struct SettingPage: Setting {
    public var id: AnyHashable?
    public var title: String
    public var selectedChoice: String?
    public var spacing = CGFloat(20)
    public var verticalPadding = CGFloat(6)
    public var backgroundColor: Color?
    public var navigationTitleDisplayMode = NavigationTitleDisplayMode.automatic
    public var previewConfiguration = PreviewConfiguration()
    @SettingBuilder public var tuple: SettingTupleView

    public var skipScrollView: Bool
    
    public init(
        id: AnyHashable? = nil,
        title: String,
        selectedChoice: String? = nil,
        spacing: CGFloat = CGFloat(20),
        verticalPadding: CGFloat = CGFloat(6),
        backgroundColor: Color? = nil,
        navigationTitleDisplayMode: SettingPage.NavigationTitleDisplayMode = NavigationTitleDisplayMode.automatic,
        previewConfiguration: SettingPage.PreviewConfiguration = PreviewConfiguration(),
        skipScrollView: Bool = false,
        @SettingBuilder tuple: () -> SettingTupleView
    ) {
        self.id = id
        self.title = title
        self.selectedChoice = selectedChoice
        self.spacing = spacing
        self.verticalPadding = verticalPadding
        self.backgroundColor = backgroundColor
        self.navigationTitleDisplayMode = navigationTitleDisplayMode
        self.previewConfiguration = previewConfiguration
        self.tuple = tuple()
        self.skipScrollView = skipScrollView
    
    }

    public struct PreviewConfiguration {
        public var icon: SettingIcon?
        public var indicator = "chevron.forward"
        public var horizontalSpacing = CGFloat(12)
        public var verticalPadding = CGFloat(14)
        public var horizontalPadding = CGFloat(16)

        public init(
            icon: SettingIcon? = nil,
            indicator: String = "chevron.forward",
            horizontalSpacing: CGFloat = CGFloat(12),
            verticalPadding: CGFloat = CGFloat(14),
            horizontalPadding: CGFloat = CGFloat(16)
        ) {
            self.icon = icon
            self.indicator = indicator
            self.horizontalSpacing = horizontalSpacing
            self.verticalPadding = verticalPadding
            self.horizontalPadding = horizontalPadding
        }
    }

    public enum NavigationTitleDisplayMode {
        case automatic
        case inline
        case large
    }
}

/// Convenience modifiers.
public extension SettingPage {
    func previewIcon(_ icon: String, color: Color = .blue) -> SettingPage {
        var page = self
        page.previewConfiguration.icon = .system(icon: icon, backgroundColor: color)
        return page
    }

    func previewIcon(_ icon: String, foregroundColor: Color = .white, backgroundColor: Color = .blue) -> SettingPage {
        var page = self
        page.previewConfiguration.icon = .system(icon: icon, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
        return page
    }

    func previewIcon(icon: SettingIcon) -> SettingPage {
        var page = self
        page.previewConfiguration.icon = icon
        return page
    }

    func previewIndicator(_ indicator: String) -> SettingPage {
        var page = self
        page.previewConfiguration.indicator = indicator
        return page
    }
}

struct SettingPageView<Content>: View where Content: View {
    @Environment(\.settingBackgroundColor) var settingBackgroundColor

    var title: String
    var spacing = CGFloat(20)
    var verticalPadding = CGFloat(12)
    var backgroundColor: Color?
    var navigationTitleDisplayMode = SettingPage.NavigationTitleDisplayMode.inline
    var isInitialPage = false
    var skipScrollView: Bool = false
    @ViewBuilder var content: Content

    var body: some View {
        #if os(iOS)
        let navigationBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode = {
            switch navigationTitleDisplayMode {
            case .automatic:
                if isInitialPage {
                    return .large
                } else {
                    return .inline
                }
            case .inline:
                return .inline
            case .large:
                return .large
            }
        }()

        main
            .navigationBarTitleDisplayMode(navigationBarTitleDisplayMode)
        #else
        main
        #endif
    }

    @ViewBuilder var main: some View {
        if #available(iOS 16.0, macOS 13.0, *) {
            contentWithConditionalScrollView
                .scrollDismissesKeyboard(.interactively)
                .background(backgroundColor ?? settingBackgroundColor)
                .navigationTitle(title)
        } else {
            contentWithConditionalScrollView
                .background(backgroundColor ?? settingBackgroundColor)
                .navigationTitle(title)
        }
    }
    
    @ViewBuilder
    var contentWithConditionalScrollView: some View {
        if self.skipScrollView {
            coreContent
        } else {
            ScrollView {
                coreContent
            }
        }
    }
    
    @ViewBuilder
    var coreContent: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, verticalPadding)
    }
    
    
    
}

public struct SettingPagePreviewView: View {
    @Environment(\.settingSecondaryColor) var settingSecondaryColor

    let title: String
    var selectedChoice: String?
    var icon: SettingIcon?
    var indicator = "chevron.forward"
    var horizontalSpacing = CGFloat(12)
    var verticalPadding = CGFloat(14)
    var horizontalPadding = CGFloat(16)

    public init(
        title: String,
        selectedChoice: String? = nil,
        icon: SettingIcon? = nil,
        indicator: String = "chevron.forward",
        iconForegroundColor: Color? = nil,
        horizontalSpacing: CGFloat = CGFloat(12),
        verticalPadding: CGFloat = CGFloat(14),
        horizontalPadding: CGFloat = CGFloat(16)
    ) {
        self.title = title
        self.selectedChoice = selectedChoice
        self.icon = icon
        self.indicator = indicator
        self.horizontalSpacing = horizontalSpacing
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }

    public var body: some View {
        HStack(spacing: horizontalSpacing) {
            if let icon {
                SettingIconView(icon: icon)
            }

            Text(title)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, verticalPadding)

            if let selectedChoice {
                Text(selectedChoice)
                    .foregroundColor(settingSecondaryColor)
            }

            Image(systemName: indicator)
                .foregroundColor(settingSecondaryColor)
        }
        .padding(.horizontal, horizontalPadding)
        .accessibilityElement(children: .combine)
    }
}

extension SettingPage {
    /// generate all possibile paths
    func generatePaths() -> [SettingPath] {
        var paths = [SettingPath]()

        for setting in tuple.flattened {
            let initialItemPath = SettingPath(settings: [setting])
            let recursivePaths = generateRecursivePaths(for: initialItemPath)
            paths += recursivePaths
        }

        return paths
    }

    /// `path` - a path of rows whose last element is the row to generate
    func generateRecursivePaths(for path: SettingPath) -> [SettingPath] {
        /// include the current setting as a path
        var paths = [path]

        /// get the last setting, possibly a page
        guard let lastItem = path.settings.last else { return [] }

        /// If the last setting is a page, travel through the page's subpages.
        if let page = lastItem as? SettingPage {
            for setting in page.tuple.flattened {
                /// If it's a subpage, generate paths for it.
                if let page = setting as? SettingPage {
                    let currentPath = SettingPath(settings: path.settings + [page])
                    let recursivePaths = generateRecursivePaths(for: currentPath)
                    paths += recursivePaths
                } else {
                    /// If not, add the setting as an endpoint.
                    let currentPath = SettingPath(settings: path.settings + [setting])
                    paths += [currentPath]
                }
            }
        }

        return paths
    }
}
