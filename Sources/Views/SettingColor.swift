//
//  File.swift
//  
//
//  Created by Ryan Mckinney on 5/5/23.
//

import Foundation
import SwiftUI

public struct SettingColor: View, Setting {
    public var id: AnyHashable?
    public var icon: SettingIcon?
    public var title: String
    @Binding public var selectedColor: Color
    public var foregroundColor: Color?
    public var horizontalSpacing = CGFloat(12)
    public var verticalPadding = CGFloat(14)
    public var horizontalPadding = CGFloat(16)

    public init(
        id: AnyHashable? = nil,
        icon: SettingIcon? = nil,
        title: String,
        selectedColor: Binding<Color>,
        foregroundColor: Color? = nil,
        horizontalSpacing: CGFloat = CGFloat(12),
        verticalPadding: CGFloat = CGFloat(14),
        horizontalPadding: CGFloat = CGFloat(16)
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self._selectedColor = selectedColor
        self.foregroundColor = foregroundColor
        self.horizontalSpacing = horizontalSpacing
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }

    public var body: some View {
        SettingColorView(
            icon: icon,
            title: title,
            selectedColor: $selectedColor,
            foregroundColor: foregroundColor,
            horizontalSpacing: horizontalSpacing,
            verticalPadding: verticalPadding,
            horizontalPadding: horizontalPadding
        )
    }
}

struct SettingColorView: View {
    @Environment(\.colorScheme) var colorScheme
    var icon: SettingIcon?
    let title: String
    @Binding var selectedColor: Color
    var foregroundColor: Color?
    var horizontalSpacing = CGFloat(12)
    var verticalPadding = CGFloat(14)
    var horizontalPadding = CGFloat(16)

    var body: some View {
        HStack(spacing: horizontalSpacing) {
            if let icon = icon {
                SettingIconView(icon: icon)
            }

            Text(title)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, verticalPadding)

            RoundedRectangle(cornerRadius: 6)
                .fill(selectedColor)
                .frame(width: 24, height: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 1)
                )

            Image(systemName: "chevron.forward")
                .foregroundColor(foregroundColor ?? .secondary)

            ColorPicker("", selection: $selectedColor)
                .frame(width: 0, height: 0)
                .opacity(0)
        }
        .padding(.horizontal, horizontalPadding)


    }
}
