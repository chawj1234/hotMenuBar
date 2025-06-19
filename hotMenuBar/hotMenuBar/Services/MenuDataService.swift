//
//  MenuDataService.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import Foundation
import SwiftUI

class MenuDataService: ObservableObject {
    @Published var menuGroups: [MenuGroup] = []
    @Published var appState = AppState()
    
    init() {
        loadMenuData()
    }
    
    // MARK: - Menu Data Loading
    func loadMenuData() {
        menuGroups = [
            createFileMenu(),
            createEditMenu(),
            createFormatMenu(),
            createViewMenu(),
            createWindowMenu(),
            createHelpMenu()
        ]
    }
    
    // MARK: - File Menu
    private func createFileMenu() -> MenuGroup {
        MenuGroup(title: "파일", items: [
            MenuItem(
                title: "새로 만들기",
                action: { self.newDocument() },
                keyEquivalent: "n",
                keyModifiers: .command,
                icon: "doc.badge.plus"
            ),
            MenuItem(
                title: "열기...",
                action: { self.openDocument() },
                keyEquivalent: "o",
                keyModifiers: .command,
                icon: "folder"
            ),
            MenuItem.separator,
            MenuItem(
                title: "저장",
                action: { self.saveDocument() },
                keyEquivalent: "s",
                keyModifiers: .command,
                isEnabled: appState.hasDocument,
                icon: "square.and.arrow.down"
            ),
            MenuItem(
                title: "다른 이름으로 저장...",
                action: { self.saveAsDocument() },
                keyEquivalent: "s",
                keyModifiers: [.command, .shift],
                isEnabled: appState.hasDocument,
                icon: "square.and.arrow.down.on.square"
            ),
            MenuItem.separator,
            MenuItem(
                title: "인쇄...",
                action: { self.printDocument() },
                keyEquivalent: "p",
                keyModifiers: .command,
                isEnabled: appState.hasDocument,
                icon: "printer"
            )
        ])
    }
    
    // MARK: - Edit Menu
    private func createEditMenu() -> MenuGroup {
        MenuGroup(title: "편집", items: [
            MenuItem(
                title: "실행 취소",
                action: { self.undo() },
                keyEquivalent: "z",
                keyModifiers: .command,
                isEnabled: appState.canUndo,
                icon: "arrow.uturn.backward"
            ),
            MenuItem(
                title: "다시 실행",
                action: { self.redo() },
                keyEquivalent: "z",
                keyModifiers: [.command, .shift],
                isEnabled: appState.canRedo,
                icon: "arrow.uturn.forward"
            ),
            MenuItem.separator,
            MenuItem(
                title: "잘라내기",
                action: { self.cut() },
                keyEquivalent: "x",
                keyModifiers: .command,
                isEnabled: appState.hasSelection,
                icon: "scissors"
            ),
            MenuItem(
                title: "복사",
                action: { self.copy() },
                keyEquivalent: "c",
                keyModifiers: .command,
                isEnabled: appState.hasSelection,
                icon: "doc.on.doc"
            ),
            MenuItem(
                title: "붙여넣기",
                action: { self.paste() },
                keyEquivalent: "v",
                keyModifiers: .command,
                isEnabled: appState.canPaste,
                icon: "doc.on.clipboard"
            ),
            MenuItem.separator,
            MenuItem(
                title: "모두 선택",
                action: { self.selectAll() },
                keyEquivalent: "a",
                keyModifiers: .command,
                isEnabled: appState.hasDocument,
                icon: "selection.pin.in.out"
            )
        ])
    }
    
    // MARK: - Format Menu
    private func createFormatMenu() -> MenuGroup {
        MenuGroup(title: "포맷", items: [
            MenuItem(
                title: "굵게",
                action: { self.toggleBold() },
                keyEquivalent: "b",
                keyModifiers: .command,
                isEnabled: appState.hasSelection,
                isChecked: appState.isBold,
                icon: "bold"
            ),
            MenuItem(
                title: "기울임꼴",
                action: { self.toggleItalic() },
                keyEquivalent: "i",
                keyModifiers: .command,
                isEnabled: appState.hasSelection,
                isChecked: appState.isItalic,
                icon: "italic"
            ),
            MenuItem(
                title: "밑줄",
                action: { self.toggleUnderline() },
                keyEquivalent: "u",
                keyModifiers: .command,
                isEnabled: appState.hasSelection,
                isChecked: appState.isUnderlined,
                icon: "underline"
            ),
            MenuItem.separator,
            MenuItem(
                title: "글꼴...",
                action: { self.showFontPanel() },
                keyEquivalent: "t",
                keyModifiers: .command,
                icon: "textformat"
            )
        ])
    }
    
    // MARK: - View Menu
    private func createViewMenu() -> MenuGroup {
        MenuGroup(title: "보기", items: [
            MenuItem(
                title: "도구 막대 보기",
                action: { self.toggleToolbar() },
                isChecked: appState.isToolbarVisible,
                icon: "hammer"
            ),
            MenuItem(
                title: "사이드바 보기",
                action: { self.toggleSidebar() },
                isChecked: appState.isSidebarVisible,
                icon: "sidebar.left"
            ),
            MenuItem.separator,
            MenuItem(
                title: "확대",
                action: { self.zoomIn() },
                keyEquivalent: "+",
                keyModifiers: .command,
                icon: "plus.magnifyingglass"
            ),
            MenuItem(
                title: "축소",
                action: { self.zoomOut() },
                keyEquivalent: "-",
                keyModifiers: .command,
                icon: "minus.magnifyingglass"
            ),
            MenuItem(
                title: "실제 크기",
                action: { self.actualSize() },
                keyEquivalent: "0",
                keyModifiers: .command,
                icon: "1.magnifyingglass"
            )
        ])
    }
    
    // MARK: - Window Menu
    private func createWindowMenu() -> MenuGroup {
        MenuGroup(title: "윈도우", items: [
            MenuItem(
                title: "최소화",
                action: { self.minimizeWindow() },
                keyEquivalent: "m",
                keyModifiers: .command,
                icon: "minus.rectangle"
            ),
            MenuItem(
                title: "확대/축소",
                action: { self.zoomWindow() },
                icon: "arrow.up.left.and.arrow.down.right"
            ),
            MenuItem.separator,
            MenuItem(
                title: "앞으로 가져오기",
                action: { self.bringAllToFront() },
                icon: "rectangle.stack"
            )
        ])
    }
    
    // MARK: - Help Menu
    private func createHelpMenu() -> MenuGroup {
        MenuGroup(title: "도움말", items: [
            MenuItem(
                title: "hotMenuBar 도움말",
                action: { self.showHelp() },
                icon: "questionmark.circle"
            ),
            MenuItem.separator,
            MenuItem(
                title: "hotMenuBar 정보",
                action: { self.showAbout() },
                icon: "info.circle"
            )
        ])
    }
}

// MARK: - App State
struct AppState {
    var hasDocument = false
    var hasSelection = false
    var canUndo = false
    var canRedo = false
    var canPaste = true
    var isBold = false
    var isItalic = false
    var isUnderlined = false
    var isToolbarVisible = true
    var isSidebarVisible = true
}

// MARK: - Menu Actions
extension MenuDataService {
    // File actions
    private func newDocument() {
        print("새 문서 생성")
        appState.hasDocument = true
        objectWillChange.send()
    }
    
    private func openDocument() {
        print("문서 열기")
        appState.hasDocument = true
        objectWillChange.send()
    }
    
    private func saveDocument() {
        print("문서 저장")
    }
    
    private func saveAsDocument() {
        print("다른 이름으로 저장")
    }
    
    private func printDocument() {
        print("문서 인쇄")
    }
    
    // Edit actions
    private func undo() {
        print("실행 취소")
        appState.canRedo = true
        appState.canUndo = false
        objectWillChange.send()
    }
    
    private func redo() {
        print("다시 실행")
        appState.canUndo = true
        appState.canRedo = false
        objectWillChange.send()
    }
    
    private func cut() {
        print("잘라내기")
        appState.canPaste = true
        appState.hasSelection = false
        objectWillChange.send()
    }
    
    private func copy() {
        print("복사")
        appState.canPaste = true
        objectWillChange.send()
    }
    
    private func paste() {
        print("붙여넣기")
        appState.hasSelection = true
        appState.canUndo = true
        objectWillChange.send()
    }
    
    private func selectAll() {
        print("모두 선택")
        appState.hasSelection = true
        objectWillChange.send()
    }
    
    // Format actions
    private func toggleBold() {
        appState.isBold.toggle()
        objectWillChange.send()
        print("굵게: \(appState.isBold)")
    }
    
    private func toggleItalic() {
        appState.isItalic.toggle()
        objectWillChange.send()
        print("기울임꼴: \(appState.isItalic)")
    }
    
    private func toggleUnderline() {
        appState.isUnderlined.toggle()
        objectWillChange.send()
        print("밑줄: \(appState.isUnderlined)")
    }
    
    private func showFontPanel() {
        print("글꼴 패널 표시")
    }
    
    // View actions
    private func toggleToolbar() {
        appState.isToolbarVisible.toggle()
        objectWillChange.send()
        print("도구 막대: \(appState.isToolbarVisible)")
    }
    
    private func toggleSidebar() {
        appState.isSidebarVisible.toggle()
        objectWillChange.send()
        print("사이드바: \(appState.isSidebarVisible)")
    }
    
    private func zoomIn() {
        print("확대")
    }
    
    private func zoomOut() {
        print("축소")
    }
    
    private func actualSize() {
        print("실제 크기")
    }
    
    // Window actions
    private func minimizeWindow() {
        print("창 최소화")
    }
    
    private func zoomWindow() {
        print("창 확대/축소")
    }
    
    private func bringAllToFront() {
        print("모든 창 앞으로 가져오기")
    }
    
    // Help actions
    private func showHelp() {
        print("도움말 표시")
    }
    
    private func showAbout() {
        print("정보 표시")
    }
} 