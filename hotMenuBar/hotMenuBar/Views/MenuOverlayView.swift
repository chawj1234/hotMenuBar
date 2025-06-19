//
//  MenuOverlayView.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI

struct MenuOverlayView: View {
    @ObservedObject var menuDataService: MenuDataService
    @Binding var isPresented: Bool
    @State private var selectedGroupIndex: Int? = nil
    @State private var hoveredMenuItemID: UUID? = nil
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .onTapGesture {
                    closeMenu()
                }
            
            // Menu container
            VStack(spacing: 0) {
                menuBar
                
                if let selectedIndex = selectedGroupIndex {
                    submenuView(for: selectedIndex)
                }
            }
            .background(Material.bar, in: RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .scaleEffect(isPresented ? 1.0 : 0.8)
            .opacity(isPresented ? 1.0 : 0.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
        }
        .onKeyPress(.escape) {
            closeMenu()
            return .handled
        }
    }
    
    // MARK: - Menu Bar

    private var menuBar: some View {
        HStack(spacing: 0) {
            ForEach(Array(menuDataService.menuGroups.enumerated()), id: \.element.id) { index, group in
                menuGroupButton(group: group, index: index)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
    
    private func menuGroupButton(group: MenuGroup, index: Int) -> some View {
        Button(action: {
            if selectedGroupIndex == index {
                selectedGroupIndex = nil
            } else {
                selectedGroupIndex = index
            }
        }) {
            Text(group.title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(selectedGroupIndex == index ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(selectedGroupIndex == index ? Color.accentColor : Color.clear)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { isHovered in
            if isHovered && selectedGroupIndex != nil {
                selectedGroupIndex = index
            }
        }
    }
    
    // MARK: - Submenu View

    private func submenuView(for groupIndex: Int) -> some View {
        let group = menuDataService.menuGroups[groupIndex]
        
        return VStack(alignment: .leading, spacing: 0) {
            Divider()
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(group.items, id: \.id) { item in
                        menuItemView(item: item)
                    }
                }
            }
            .frame(maxHeight: 300)
        }
        .frame(minWidth: 200)
        .background(Material.bar)
    }
    
    private func menuItemView(item: MenuItem) -> some View {
        Group {
            if item.type == .separator {
                Divider()
                    .padding(.vertical, 4)
            } else {
                menuItemButton(item: item)
            }
        }
    }
    
    private func menuItemButton(item: MenuItem) -> some View {
        Button(action: {
            if item.isEnabled {
                item.action?()
                closeMenu()
            }
        }) {
            HStack(spacing: 8) {
                // Icon
                if let iconName = item.icon {
                    Image(systemName: iconName)
                        .font(.system(size: 12))
                        .frame(width: 16)
                        .foregroundColor(item.isEnabled ? .primary : .secondary)
                }
                
                // Title
                Text(item.title)
                    .font(.system(size: 13))
                    .foregroundColor(item.isEnabled ? .primary : .secondary)
                
                Spacer()
                
                // Check mark for toggle items
                if item.type == .toggle && item.isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.accentColor)
                }
                
                // Keyboard shortcut
                if let keyEquivalent = item.keyEquivalent,
                   let modifiers = item.keyModifiers
                {
                    keyboardShortcutView(key: keyEquivalent, modifiers: modifiers)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(hoveredMenuItemID == item.id ? Color.accentColor.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!item.isEnabled)
        .onHover { isHovered in
            hoveredMenuItemID = isHovered ? item.id : nil
        }
    }
    
    private func keyboardShortcutView(key: String, modifiers: EventModifiers) -> some View {
        HStack(spacing: 2) {
            if modifiers.contains(.command) {
                Text("⌘")
            }
            if modifiers.contains(.shift) {
                Text("⇧")
            }
            if modifiers.contains(.option) {
                Text("⌥")
            }
            if modifiers.contains(.control) {
                Text("⌃")
            }
            Text(key.uppercased())
        }
        .font(.system(size: 11, design: .monospaced)).foregroundColor(.secondary)
    }
    
    // MARK: - Helper Methods

    private func closeMenu() {
        selectedGroupIndex = nil
        withAnimation(.easeOut(duration: 0.2)) {
            isPresented = false
        }
    }
}

#Preview {
    MenuOverlayView(
        menuDataService: MenuDataService(),
        isPresented: .constant(true)
    )
}
