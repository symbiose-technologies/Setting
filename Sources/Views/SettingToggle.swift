//
//  SettingToggle.swift
//  Setting
//
//  Created by A. Zheng (github.com/aheze) on 2/21/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

/**
 A simple toggle.
 */
public struct SettingToggle: View, Setting {
    public var id: AnyHashable?
    public var title: String
    @Binding public var isOn: Bool
    public var horizontalSpacing = CGFloat(12)
    public var verticalPadding = CGFloat(14)
    public var horizontalPadding = CGFloat(16)
    public var icon: SettingIcon?

    public init(
        id: AnyHashable? = nil,
        title: String,
        isOn: Binding<Bool>,
        horizontalSpacing: CGFloat = CGFloat(12),
        verticalPadding: CGFloat = CGFloat(14),
        horizontalPadding: CGFloat = CGFloat(16),
        icon: SettingIcon? = nil
    ) {
        self.id = id
        self.title = title
        self._isOn = isOn
        self.horizontalSpacing = horizontalSpacing
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.icon = icon
    }

    public var body: some View {
        SettingToggleView(
            title: title,
            isOn: $isOn,
            horizontalSpacing: horizontalSpacing,
            verticalPadding: verticalPadding,
            horizontalPadding: horizontalPadding,
            icon: icon
        )
    }
}

struct SettingToggleView: View {
    let title: String
    @Binding var isOn: Bool

    var horizontalSpacing = CGFloat(12)
    var verticalPadding = CGFloat(14)
    var horizontalPadding = CGFloat(16)
    var icon: SettingIcon? = nil
    
    
    @ViewBuilder
    var body: some View {
        HStack(spacing: horizontalSpacing) {
            if let icon {
                SettingIconView(icon: icon)
            }
            
            
            Text(title)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, verticalPadding)

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, horizontalPadding)
        .accessibilityElement(children: .combine)
    }
}
