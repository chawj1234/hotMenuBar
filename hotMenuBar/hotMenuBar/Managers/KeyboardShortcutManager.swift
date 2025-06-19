//
//  KeyboardShortcutManager.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI
import AppKit

class KeyboardShortcutManager: ObservableObject {
    @Published var isMenuOverlayPresented = false
    private var globalEventMonitor: Any?
    
    init() {
        setupGlobalKeyboardShortcut()
    }
    
    deinit {
        removeGlobalKeyboardShortcut()
    }
    
    // MARK: - Global Keyboard Shortcut Setup
    private func setupGlobalKeyboardShortcut() {
        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.keyDown],
            handler: { [weak self] event in
                self?.handleGlobalKeyEvent(event)
            }
        )
    }
    
    private func removeGlobalKeyboardShortcut() {
        if let monitor = globalEventMonitor {
            NSEvent.removeMonitor(monitor)
            globalEventMonitor = nil
        }
    }
    
    private func handleGlobalKeyEvent(_ event: NSEvent) {
        // ⌘M 단축키 감지
        if event.modifierFlags.contains(.command) &&
           event.keyCode == 46 { // M key
            DispatchQueue.main.async {
                self.toggleMenuOverlay()
            }
        }
    }
    
    // MARK: - Menu Toggle
    func toggleMenuOverlay() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            isMenuOverlayPresented.toggle()
        }
    }
    
    func hideMenuOverlay() {
        withAnimation(.easeOut(duration: 0.2)) {
            isMenuOverlayPresented = false
        }
    }
}

// MARK: - Focus Management
extension KeyboardShortcutManager {
    func handleWindowFocusChange() {
        // 윈도우 포커스가 변경될 때 메뉴 오버레이 숨기기
        if isMenuOverlayPresented {
            hideMenuOverlay()
        }
    }
} 