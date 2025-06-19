//
//  MenuOverlayView.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI

struct MenuOverlayView: View {
    @EnvironmentObject var menuDataService: MenuDataService
    @EnvironmentObject var keyboardManager: KeyboardShortcutManager
    @State private var selectedGroupIndex = 0
    
    var body: some View {
        ZStack {
            // 배경 오버레이
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    keyboardManager.hideMenu()
                }
            
            // 메뉴 콘텐츠
            VStack(spacing: 0) {
                MenuHeader()
                MenuContent()
            }
            .background(.regularMaterial)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            .frame(width: 700, height: 500)
            .onKeyDown(key: .escape) {
                keyboardManager.hideMenu()
            }
        }
    }
}

// MARK: - 메뉴 헤더
struct MenuHeader: View {
    @EnvironmentObject var menuDataService: MenuDataService
    @EnvironmentObject var keyboardManager: KeyboardShortcutManager
    
    var body: some View {
        HStack {
            // 앱 정보
            HStack(spacing: 8) {
                Image(systemName: "app.fill")
                    .foregroundColor(.accentColor)
                
                if menuDataService.currentAppName.isEmpty {
                    Text("메뉴 로딩 중...")
                        .font(.headline)
                        .foregroundColor(.secondary)
                } else {
                    Text(menuDataService.currentAppName)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            
            Spacer()
            
            // 닫기 버튼
            Button(action: {
                keyboardManager.hideMenu()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
            .keyboardShortcut(.escape, modifiers: [])
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.thinMaterial)
    }
}

// MARK: - 메뉴 콘텐츠
struct MenuContent: View {
    @EnvironmentObject var menuDataService: MenuDataService
    
    var body: some View {
        if menuDataService.isLoading {
            LoadingView()
        } else if let error = menuDataService.error {
            ErrorView(error: error)
        } else if menuDataService.menuGroups.isEmpty {
            EmptyView()
        } else {
            MenuContainerView()
        }
    }
}

// MARK: - 로딩 뷰
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("메뉴를 불러오는 중...")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("잠시만 기다려주세요")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - 에러 뷰
struct ErrorView: View {
    let error: String
    @EnvironmentObject var menuDataService: MenuDataService
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("오류 발생")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(error)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if error.contains("접근성 권한") {
                VStack(spacing: 12) {
                    Button(action: {
                        openAccessibilityPreferences()
                    }) {
                        HStack {
                            Image(systemName: "gear")
                            Text("접근성 설정 열기")
                        }
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("hotMenuBar를 접근성 목록에 추가하고 체크해주세요")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Button(action: {
                    menuDataService.loadActiveAppMenu()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("다시 시도")
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private func openAccessibilityPreferences() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }
}

// MARK: - 빈 뷰
struct EmptyView: View {
    @EnvironmentObject var menuDataService: MenuDataService
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "menubar.rectangle")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("메뉴를 찾을 수 없습니다")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("이 앱에는 접근 가능한 메뉴가 없거나\n메뉴를 읽을 수 없습니다")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                menuDataService.loadActiveAppMenu()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("다시 시도")
                }
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - 키보드 입력 처리 확장
extension View {
    func onKeyDown(key: KeyEquivalent, action: @escaping () -> Void) -> some View {
        self.background(
            KeyboardInputView(key: key, action: action)
        )
    }
}

struct KeyboardInputView: NSViewRepresentable {
    let key: KeyEquivalent
    let action: () -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = KeyInputView()
        view.keyDownHandler = { event in
            if event.keyCode == 53 { // ESC 키
                action()
                return true
            }
            return false
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

class KeyInputView: NSView {
    var keyDownHandler: ((NSEvent) -> Bool)?
    
    override var acceptsFirstResponder: Bool { true }
    
    override func keyDown(with event: NSEvent) {
        if keyDownHandler?(event) != true {
            super.keyDown(with: event)
        }
    }
}

// MARK: - 프리뷰
#Preview {
    MenuOverlayView()
        .environmentObject(MenuDataService())
        .environmentObject(KeyboardShortcutManager())
} 
