//
//  hotMenuBarApp.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI

@main
struct hotMenuBarApp: App {
    @StateObject private var menuDataService = MenuDataService()
    @StateObject private var keyboardManager = KeyboardShortcutManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(menuDataService)
                .environmentObject(keyboardManager)
                .onAppear {
                    // 앱이 시작될 때 KeyboardShortcutManager에 MenuDataService 설정
                    keyboardManager.setMenuDataService(menuDataService)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            // 메뉴바에서 Quit 명령 제거 (백그라운드 앱으로 동작)
            CommandGroup(replacing: .appTermination) { }
        }
    }
} 
