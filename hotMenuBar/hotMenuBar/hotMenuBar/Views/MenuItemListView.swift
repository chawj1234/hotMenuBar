//
//  MenuItemListView.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI

struct MenuItemListView: View {
    let items: [MenuItem]
    let onItemTap: (MenuItem) -> Void
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(items) { item in
                    if item.type == .separator {
                        Divider()
                            .padding(.horizontal)
                    } else {
                        MenuItemRowView(
                            item: item,
                            onTap: {
                                onItemTap(item)
                            }
                        )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    let sampleItems = [
        MenuItem(
            title: "새로 만들기",
            shortcut: "⌘N",
            type: .action,
            isEnabled: true,
            action: { print("새로 만들기") }
        ),
        MenuItem(
            title: "열기...",
            shortcut: "⌘O",
            type: .action,
            isEnabled: true,
            action: { print("열기") }
        ),
        MenuItem.separator,
        MenuItem(
            title: "저장",
            shortcut: "⌘S",
            type: .action,
            isEnabled: false,
            action: { print("저장") }
        )
    ]
    
    MenuItemListView(
        items: sampleItems,
        onItemTap: { item in
            print("Tapped: \(item.title)")
        }
    )
    .frame(width: 400, height: 300)
} 