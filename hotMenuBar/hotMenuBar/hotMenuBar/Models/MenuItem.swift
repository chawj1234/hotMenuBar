//
//  MenuItem.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI
import ApplicationServices

// MARK: - 메뉴 아이템 타입
enum MenuItemType {
    case action
    case toggle
    case separator
}

// MARK: - 메뉴 아이템 모델
struct MenuItem: Identifiable {
    let id: UUID
    let title: String
    let shortcut: String?
    let type: MenuItemType
    var isEnabled: Bool
    var isChecked: Bool?
    let axElement: AXUIElement?
    let action: (() -> Void)?
    
    init(
        id: UUID = UUID(),
        title: String,
        shortcut: String? = nil,
        type: MenuItemType = .action,
        isEnabled: Bool = true,
        isChecked: Bool? = nil,
        axElement: AXUIElement? = nil,
        action: (() -> Void)? = nil
    ) {
        self.id = id
        self.title = title
        self.shortcut = shortcut
        self.type = type
        self.isEnabled = isEnabled
        self.isChecked = isChecked
        self.axElement = axElement
        self.action = action
    }
    
    // 구분선 생성자
    static var separator: MenuItem {
        MenuItem(
            title: "",
            type: .separator,
            isEnabled: false
        )
    }
}

// MARK: - 메뉴 그룹 모델
struct MenuGroup: Identifiable {
    let id: UUID
    let title: String
    let icon: String
    let items: [MenuItem]
    
    init(
        id: UUID = UUID(),
        title: String,
        icon: String,
        items: [MenuItem]
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.items = items
    }
} 