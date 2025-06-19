//
//  ContentView.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var menuDataService: MenuDataService
    @EnvironmentObject var keyboardManager: KeyboardShortcutManager
    
    var body: some View {
        ZStack {
            // 메인 앱 화면
            VStack(spacing: 20) {
                AppHeader()
                AppStatus()
                DebugSection(menuService: menuDataService)
                InstructionsView()
                Spacer()
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.windowBackgroundColor))
            
            // 메뉴 오버레이
            if keyboardManager.isMenuVisible {
                MenuOverlayView()
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(100)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: keyboardManager.isMenuVisible)
    }
}

// MARK: - 앱 헤더
struct AppHeader: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "menubar.rectangle")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.accentColor)
            
            Text("hotMenuBar")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("macOS 메뉴바에 빠르게 접근하기")
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - 앱 상태
struct AppStatus: View {
    @EnvironmentObject var menuDataService: MenuDataService
    
    var body: some View {
        VStack(spacing: 16) {
            StatusCard(
                icon: "hand.raised.fill",
                title: "접근성 권한",
                status: menuDataService.error == nil ? "허용됨" : "필요함",
                isGood: menuDataService.error == nil
            )
            
            if !menuDataService.currentAppName.isEmpty {
                StatusCard(
                    icon: "app.fill",
                    title: "감지된 앱",
                    status: menuDataService.currentAppName,
                    isGood: true
                )
            }
            
            StatusCard(
                icon: "keyboard",
                title: "단축키",
                status: "⌘⇧M 으로 메뉴 열기",
                isGood: true
            )
        }
    }
}

// MARK: - 디버그 섹션
struct DebugSection: View {
    @ObservedObject var menuService: MenuDataService
    
    var body: some View {
        GroupBox("🔍 디버깅 정보") {
            VStack(alignment: .leading, spacing: 8) {
                // 활성 앱 정보
                Group {
                    Text("📱 활성 앱")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text("이름:")
                            .foregroundColor(.secondary)
                        Text(menuService.currentAppName.isEmpty ? "없음" : menuService.currentAppName)
                            .fontWeight(.medium)
                        Spacer()
                    }
                }
                
                Divider()
                
                // 메뉴 감지 방법
                Group {
                    Text("🔧 메뉴 감지 방법")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(menuService.detectionMethod.isEmpty ? "없음" : menuService.detectionMethod)
                            .foregroundColor(menuService.detectionMethod.isEmpty ? .secondary : .green)
                            .fontWeight(.medium)
                        Spacer()
                    }
                }
                
                Divider()
                
                // 메뉴 정보
                Group {
                    Text("📋 메뉴 정보")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text("로딩 상태:")
                            .foregroundColor(.secondary)
                        Text(menuService.isLoading ? "로딩 중..." : "대기 중")
                            .foregroundColor(menuService.isLoading ? .orange : .primary)
                        Spacer()
                    }
                    
                    HStack {
                        Text("메뉴 그룹:")
                            .foregroundColor(.secondary)
                        Text("\(menuService.menuGroups.count)개")
                            .fontWeight(.medium)
                        Spacer()
                    }
                    
                    HStack {
                        Text("총 아이템:")
                            .foregroundColor(.secondary)
                        Text("\(menuService.menuGroups.reduce(0) { $0 + $1.items.count })개")
                            .fontWeight(.medium)
                        Spacer()
                    }
                }
                
                Divider()
                
                // 권한 상태
                Group {
                    Text("🔒 권한 상태")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text("접근성 권한:")
                            .foregroundColor(.secondary)
                        Text(AXIsProcessTrusted() ? "✅ 허용됨" : "❌ 거부됨")
                            .foregroundColor(AXIsProcessTrusted() ? .green : .red)
                        Spacer()
                    }
                }
                
                Divider()
                
                // 지원되는 앱 목록
                Group {
                    Text("✅ 완전 지원 앱")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    Text("• Finder, TextEdit, Preview, Calculator")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("⚠️ 제한적 지원")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Text("• Safari, Chrome, VS Code 등")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // 테스트 버튼
                Button("🔄 앱 정보 새로고침") {
                    menuService.loadActiveAppMenu()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - 디버그 정보 카드
struct DebugInfoCard: View {
    let title: String
    let icon: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            Text(content)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(Color(.textBackgroundColor))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.separatorColor), lineWidth: 1)
        )
    }
}

// MARK: - 상태 카드
struct StatusCard: View {
    let icon: String
    let title: String
    let status: String
    let isGood: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isGood ? .green : .orange)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                
                Text(status)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: isGood ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundColor(isGood ? .green : .orange)
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(12)
    }
}

// MARK: - 사용 방법
struct InstructionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("사용 방법")
                .font(.headline)
            
            InstructionStep(
                number: "1",
                text: "다른 앱을 실행하고 활성화하세요"
            )
            
            InstructionStep(
                number: "2", 
                text: "⌘⇧M 키를 눌러 메뉴를 엽니다"
            )
            
            InstructionStep(
                number: "3",
                text: "원하는 메뉴 항목을 클릭하세요"
            )
            
            Divider()
                .padding(.vertical, 8)
            
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                
                Text("팁: ESC 키나 바깥 영역을 클릭하면 메뉴가 닫힙니다")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(12)
    }
}

// MARK: - 사용 방법 단계
struct InstructionStep: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(number)
                .font(.system(.caption, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Color.accentColor)
                .clipShape(Circle())
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

// MARK: - 프리뷰
#Preview {
    ContentView()
        .environmentObject(MenuDataService())
        .environmentObject(KeyboardShortcutManager())
} 
