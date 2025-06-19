//
//  MenuItem.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import Foundation
import SwiftUI

// MARK: - Menu Item Types
enum MenuItemType {
    case action
    case separator
    case submenu
    case toggle
}

// MARK: - Menu Item Model
struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let type: MenuItemType
    let action: (() -> Void)?
    let keyEquivalent: String?
    let keyModifiers: EventModifiers?
    var isEnabled: Bool
    var isChecked: Bool
    var icon: String?
    var submenu: [MenuItem]?
    
    init(
        title: String,
        type: MenuItemType = .action,
        action: (() -> Void)? = nil,
        keyEquivalent: String? = nil,
        keyModifiers: EventModifiers? = nil,
        isEnabled: Bool = true,
        isChecked: Bool = false,
        icon: String? = nil,
        submenu: [MenuItem]? = nil
    ) {
        self.title = title
        self.type = type
        self.action = action
        self.keyEquivalent = keyEquivalent
        self.keyModifiers = keyModifiers
        self.isEnabled = isEnabled
        self.isChecked = isChecked
        self.icon = icon
        self.submenu = submenu
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        lhs.id == rhs.id
    }
    
    // Separator 생성 편의 메서드
    static var separator: MenuItem {
        MenuItem(title: "", type: .separator)
    }
}

// MARK: - Menu Group Model
struct MenuGroup: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let items: [MenuItem]
    
    init(title: String, items: [MenuItem]) {
        self.title = title
        self.items = items
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MenuGroup, rhs: MenuGroup) -> Bool {
        lhs.id == rhs.id
    }
} 