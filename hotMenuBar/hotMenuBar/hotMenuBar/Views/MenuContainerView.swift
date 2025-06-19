//
//  MenuContainerView.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI

struct MenuContainerView: View {
    @EnvironmentObject var menuDataService: MenuDataService
    @EnvironmentObject var keyboardManager: KeyboardShortcutManager
    @State private var selectedGroupIndex = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // 메뉴 그룹 헤더
            MenuGroupHeaderView(selectedIndex: $selectedGroupIndex)
            
            Divider()
            
            // 메뉴 아이템 리스트
            if selectedGroupIndex < menuDataService.menuGroups.count {
                MenuItemListView(
                    items: menuDataService.menuGroups[selectedGroupIndex].items,
                    onItemTap: handleItemTap
                )
            } else {
                Spacer()
            }
        }
    }
    
    private func handleItemTap(_ item: MenuItem) {
        // 실제 메뉴 아이템 실행
        item.action?()
        
        // 메뉴 닫기
        keyboardManager.hideMenu()
    }
}

#Preview {
    MenuContainerView()
        .environmentObject(MenuDataService())
        .environmentObject(KeyboardShortcutManager())
        .frame(width: 700, height: 500)
} 