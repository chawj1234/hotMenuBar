//
//  ContentView.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var menuDataService = MenuDataService()
    @StateObject private var keyboardManager = KeyboardShortcutManager()
    
    var body: some View {
        ZStack {
            // Main Content
            mainContentView
            
            // Menu Overlay
            if keyboardManager.isMenuOverlayPresented {
                MenuOverlayView(
                    menuDataService: menuDataService,
                    isPresented: $keyboardManager.isMenuOverlayPresented
                )
                .zIndex(1000)
            }
        }
        .onAppear {
            setupApp()
        }
    }
    
    // MARK: - Main Content
    private var mainContentView: some View {
        VStack(spacing: 20) {
            // Header
            headerView
            
            // Content
            contentView
            
            // Footer
            footerView
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(
            gradient: Gradient(colors: [.blue.opacity(0.1), .purple.opacity(0.1)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "menubar.rectangle")
                .font(.system(size: 60, weight: .ultraLight))
                .foregroundStyle(.blue)
            
            Text("hotMenuBar")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            Text("macOS 메뉴바 오버레이 앱")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 16) {
            // Quick Start Guide
            quickStartGuide
            
            // App State Display
            appStateDisplay
            
            // Action Buttons
            actionButtons
        }
        .padding(24)
        .background(Material.ultraThin, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var quickStartGuide: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundColor(.yellow)
                Text("빠른 시작 가이드")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("⌘M")
                        .font(.system(.caption, design: .monospaced))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.blue.opacity(0.2), in: Capsule())
                    Text("메뉴 오버레이 열기/닫기")
                        .font(.caption)
                }
                
                HStack {
                    Text("ESC")
                        .font(.system(.caption, design: .monospaced))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.red.opacity(0.2), in: Capsule())
                    Text("메뉴 오버레이 닫기")
                        .font(.caption)
                }
                
                HStack {
                    Text("클릭")
                        .font(.system(.caption, design: .monospaced))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.green.opacity(0.2), in: Capsule())
                    Text("메뉴 그룹 선택 및 항목 실행")
                        .font(.caption)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var appStateDisplay: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                Text("현재 앱 상태")
                    .font(.headline)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                stateItem("문서", value: menuDataService.appState.hasDocument ? "있음" : "없음")
                stateItem("선택", value: menuDataService.appState.hasSelection ? "있음" : "없음")
                stateItem("실행취소", value: menuDataService.appState.canUndo ? "가능" : "불가능")
                stateItem("다시실행", value: menuDataService.appState.canRedo ? "가능" : "불가능")
                stateItem("도구막대", value: menuDataService.appState.isToolbarVisible ? "표시" : "숨김")
                stateItem("사이드바", value: menuDataService.appState.isSidebarVisible ? "표시" : "숨김")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func stateItem(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption2)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
    }
    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button("메뉴 테스트") {
                keyboardManager.toggleMenuOverlay()
            }
            .buttonStyle(.borderedProminent)
            
            Button("상태 초기화") {
                resetAppState()
            }
            .buttonStyle(.bordered)
        }
    }
    
    private var footerView: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "keyboard")
                    .foregroundStyle(.secondary)
                Text("⌘M을 눌러 메뉴 오버레이를 시작해보세요!")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text("macOS의 익숙한 메뉴바 경험을 앱 내에서 재현합니다")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Helper Methods
    private func setupApp() {
        // 앱 초기 설정
        print("hotMenuBar 앱이 시작되었습니다.")
    }
    
    private func resetAppState() {
        menuDataService.appState = AppState()
        menuDataService.loadMenuData()
    }
}

#Preview {
    ContentView()
}
