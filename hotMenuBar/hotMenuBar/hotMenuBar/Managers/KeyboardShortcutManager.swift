//
//  KeyboardShortcutManager.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI
import AppKit
import Carbon

class KeyboardShortcutManager: ObservableObject {
    @Published var isMenuVisible = false
    
    private var globalMonitor: Any?
    private var localMonitor: Any?
    private weak var menuDataService: MenuDataService?
    
    init() {
        setupKeyboardShortcuts()
    }
    
    deinit {
        removeKeyboardShortcuts()
    }
    
    func setMenuDataService(_ service: MenuDataService) {
        self.menuDataService = service
    }
    
    private func setupKeyboardShortcuts() {
        // 글로벌 키보드 모니터 (다른 앱이 활성화된 상태에서도 동작)
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyEvent(event)
        }
        
        // 로컬 키보드 모니터 (앱이 활성화된 상태에서 동작)
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if self?.handleKeyEvent(event) == true {
                return nil // 이벤트를 소비하여 더 이상 전파되지 않도록 함
            }
            return event
        }
    }
    
    @discardableResult
    private func handleKeyEvent(_ event: NSEvent) -> Bool {
        // ⌘⇧M (Command + Shift + M) 감지
        let isCommandShiftM = event.modifierFlags.contains([.command, .shift]) &&
                             event.keyCode == 46 // M 키의 키코드
        
        if isCommandShiftM {
            DispatchQueue.main.async {
                self.toggleMenu()
            }
            return true
        }
        
        return false
    }
    
    private func toggleMenu() {
        isMenuVisible.toggle()
        
        if isMenuVisible {
            // 메뉴가 열릴 때 현재 활성 앱의 메뉴를 로드
            menuDataService?.loadActiveAppMenu()
        }
    }
    
    func hideMenu() {
        isMenuVisible = false
    }
    
    private func removeKeyboardShortcuts() {
        if let globalMonitor = globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
            self.globalMonitor = nil
        }
        
        if let localMonitor = localMonitor {
            NSEvent.removeMonitor(localMonitor)
            self.localMonitor = nil
        }
    }
} 