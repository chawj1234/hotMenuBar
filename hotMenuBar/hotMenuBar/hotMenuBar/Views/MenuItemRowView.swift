//
//  MenuItemRowView.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI

struct MenuItemRowView: View {
    let item: MenuItem
    let onTap: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            if item.isEnabled {
                onTap()
            }
        }) {
            HStack(spacing: 12) {
                // 메뉴 아이템 제목
                Text(item.title)
                    .font(.system(size: 13))
                    .foregroundColor(item.isEnabled ? .primary : .secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                // 단축키 표시
                if let shortcut = item.shortcut {
                    Text(shortcut)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                
                // 체크 표시 (토글 아이템용)
                if item.type == .toggle, let isChecked = item.isChecked {
                    Image(systemName: isChecked ? "checkmark" : "")
                        .font(.system(size: 11))
                        .foregroundColor(.accentColor)
                        .frame(width: 12)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Rectangle()
                    .fill(isHovered && item.isEnabled ? Color.accentColor.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!item.isEnabled)
        .onHover { hovering in
            isHovered = hovering
        }
        .animation(.easeInOut(duration: 0.1), value: isHovered)
    }
}

#Preview {
    VStack(spacing: 0) {
        MenuItemRowView(
            item: MenuItem(
                title: "새로 만들기",
                shortcut: "⌘N",
                type: .action,
                isEnabled: true,
                action: { print("새로 만들기") }
            ),
            onTap: { print("새로 만들기 탭") }
        )
        
        MenuItemRowView(
            item: MenuItem(
                title: "저장",
                shortcut: "⌘S",
                type: .action,
                isEnabled: false,
                action: { print("저장") }
            ),
            onTap: { print("저장 탭") }
        )
        
        MenuItemRowView(
            item: MenuItem(
                title: "굵게",
                shortcut: "⌘B",
                type: .toggle,
                isEnabled: true,
                isChecked: true,
                action: { print("굵게") }
            ),
            onTap: { print("굵게 탭") }
        )
    }
    .frame(width: 300)
} 