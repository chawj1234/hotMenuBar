//
//  MenuGroupHeaderView.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI

struct MenuGroupHeaderView: View {
    @EnvironmentObject var menuDataService: MenuDataService
    @Binding var selectedIndex: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(menuDataService.menuGroups.indices, id: \.self) { index in
                    MenuGroupTab(
                        group: menuDataService.menuGroups[index],
                        isSelected: index == selectedIndex,
                        onTap: {
                            selectedIndex = index
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 50)
        .background(.thickMaterial)
    }
}

// MARK: - 메뉴 그룹 탭
struct MenuGroupTab: View {
    let group: MenuGroup
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: group.icon)
                    .font(.system(size: 14, weight: .medium))
                
                Text(group.title)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.accentColor : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    @Previewable @State var selectedIndex = 0
    
    MenuGroupHeaderView(selectedIndex: $selectedIndex)
        .environmentObject(MenuDataService())
} 