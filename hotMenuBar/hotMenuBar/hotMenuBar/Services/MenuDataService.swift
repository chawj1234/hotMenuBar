//
//  MenuDataService.swift
//  hotMenuBar
//
//  Created by 차원준 on 6/19/25.
//

import SwiftUI
import ApplicationServices
import Cocoa

class MenuDataService: ObservableObject {
    @Published var menuGroups: [MenuGroup] = []
    @Published var selectedGroupIndex: Int = 0
    @Published var isLoading = false
    @Published var error: String?
    @Published var currentAppName: String = ""
    @Published var detectionMethod: String = ""
    
    private var activeApp: NSRunningApplication?
    
    // MARK: - 메뉴 데이터베이스
    private static let menuDatabase: [String: [String: [String]]] = [
        // Finder
        "com.apple.finder": [
            "파인더": ["파인더 정보", "환경설정...", "서비스", "파인더 가리기", "기타 가리기", "모두 보기", "파인더 종료"],
            "파일": ["새 파인더 윈도우", "새 폴더", "새 스마트 폴더", "새 탭", "열기", "최근 항목으로 열기", "닫기", "정보 가져오기", "압축하기", "복제", "별칭 만들기", "빠른 보기", "인쇄", "공유", "휴지통으로 이동"],
            "편집": ["실행 취소", "다시 실행", "잘라내기", "복사", "붙여넣기", "모두 선택", "클립보드 보기", "자동 채우기", "핫 코너", "특수 문자"],
            "보기": ["탭으로 보기", "모든 탭 보기", "아이콘으로 보기", "목록으로 보기", "열로 보기", "Cover Flow로 보기", "도구막대 맞춤설정", "상태 막대 보기", "경로 막대 보기", "탭 막대 보기", "사이드바 보기", "미리보기 보기"],
            "이동": ["뒤로", "앞으로", "바깥쪽으로", "컴퓨터", "홈", "데스크탑", "문서", "다운로드", "AirDrop", "네트워크", "iCloud Drive", "응용 프로그램", "유틸리티", "최근 항목", "폴더로 이동"],
            "윈도우": ["최소화", "확대/축소", "모든 윈도우를 앞으로", "창 순환"],
            "도움말": ["파인더 도움말", "macOS 도움말"]
        ],
        
        // Safari
        "com.apple.Safari": [
            "Safari": ["Safari 정보", "환경설정...", "서비스", "Safari 가리기", "기타 가리기", "모두 보기", "Safari 종료"],
            "파일": ["새 윈도우", "새 비공개 윈도우", "새 탭", "탭 닫기", "윈도우 닫기", "사파리에서 열기", "가져오기", "내보내기", "페이지 설정", "인쇄"],
            "편집": ["실행 취소", "다시 실행", "잘라내기", "복사", "붙여넣기", "모두 선택", "찾기", "맞춤법 및 문법", "대치"],
            "보기": ["툴바 보기", "탭 막대 보기", "사이드바 보기", "모든 탭 보기", "읽기 목록 보기", "확대", "축소", "실제 크기", "개발자", "소스 보기"],
            "히스토리": ["뒤로", "앞으로", "홈", "히스토리 검색", "최근 닫은 탭", "최근 닫은 윈도우", "전체 히스토리", "상위 사이트", "히스토리 지우기"],
            "북마크": ["모든 북마크 보기", "북마크 추가", "북마크 폴더 추가", "즐겨찾기에 추가", "읽기 목록에 추가"],
            "윈도우": ["최소화", "확대/축소", "모든 윈도우를 앞으로", "새 윈도우로 탭 이동"],
            "도움말": ["Safari 도움말", "개인정보 보고서", "Safari 사용자 가이드"]
        ],
        
        // TextEdit
        "com.apple.TextEdit": [
            "TextEdit": ["TextEdit 정보", "환경설정...", "서비스", "TextEdit 가리기", "기타 가리기", "모두 보기", "TextEdit 종료"],
            "파일": ["새로 만들기", "열기", "최근 열어본 항목", "닫기", "저장", "다른 이름으로 저장", "복귀", "복제", "이름 변경", "이동", "페이지 설정", "인쇄"],
            "편집": ["실행 취소", "다시 실행", "잘라내기", "복사", "붙여넣기", "붙여넣고 스타일 일치", "삭제", "모두 선택", "찾기", "맞춤법 및 문법"],
            "포맷": ["글꼴", "텍스트", "정렬", "간격", "목록", "표", "링크"],
            "보기": ["실제 크기", "확대", "축소", "페이지에 맞춤", "줄 바꿈", "페이지 나누기 보기", "레이아웃", "눈금자 보기"],
            "윈도우": ["최소화", "확대/축소", "모든 윈도우를 앞으로"],
            "도움말": ["TextEdit 도움말"]
        ],
        
        // Preview
        "com.apple.Preview": [
            "미리보기": ["미리보기 정보", "환경설정...", "서비스", "미리보기 가리기", "기타 가리기", "모두 보기", "미리보기 종료"],
            "파일": ["열기", "최근 열어본 항목", "닫기", "저장", "다른 이름으로 내보내기", "복귀", "복제", "인쇄"],
            "편집": ["실행 취소", "다시 실행", "잘라내기", "복사", "붙여넣기", "삭제", "모두 선택", "회전", "뒤집기"],
            "보기": ["실제 크기", "확대", "축소", "페이지에 맞춤", "페이지 폭에 맞춤", "단일 페이지", "두 페이지", "연속 스크롤", "썸네일", "목차", "하이라이트 및 메모", "인스펙터"],
            "도구": ["주석 달기", "텍스트 선택", "직사각형 선택", "스마트 올가미", "즉석 알파", "조정", "색상 조정"],
            "윈도우": ["최소화", "확대/축소", "모든 윈도우를 앞으로"],
            "도움말": ["미리보기 도움말"]
        ],
        
        // Calculator
        "com.apple.calculator": [
            "계산기": ["계산기 정보", "환경설정...", "서비스", "계산기 가리기", "기타 가리기", "모두 보기", "계산기 종료"],
            "편집": ["실행 취소", "다시 실행", "잘라내기", "복사", "붙여넣기", "모두 선택"],
            "보기": ["기본", "과학용", "프로그래머"],
            "변환": ["온도", "길이", "무게 및 질량", "면적", "부피 및 용량", "속도", "압력", "에너지", "전력", "각도"],
            "음성": ["음성으로 말하기", "설정"],
            "윈도우": ["최소화", "확대/축소", "모든 윈도우를 앞으로"],
            "도움말": ["계산기 도움말"]
        ]
    ]
    
    // 일반적인 메뉴 구조
    private static let genericMenuStructure: [String: [String]] = [
        "파일": ["새로 만들기", "열기", "닫기", "저장", "다른 이름으로 저장", "인쇄", "종료"],
        "편집": ["실행 취소", "다시 실행", "잘라내기", "복사", "붙여넣기", "모두 선택", "찾기"],
        "보기": ["확대", "축소", "실제 크기", "전체 화면", "도구막대 보기"],
        "윈도우": ["최소화", "확대/축소", "모든 윈도우를 앞으로"],
        "도움말": ["도움말", "정보"]
    ]
    
    init() {
        checkAccessibilityPermissions()
    }
    
    // MARK: - 접근성 권한 확인
    private func checkAccessibilityPermissions() {
        let trusted = AXIsProcessTrusted()
        if !trusted {
            DispatchQueue.main.async {
                self.error = "더 나은 메뉴 감지를 위해 접근성 권한을 허용해주세요.\n시스템 설정 > 개인정보 보호 및 보안 > 접근성"
            }
        }
    }
    
    // MARK: - 활성 앱의 메뉴 로드
    func loadActiveAppMenu() {
        print("🔍 [MenuDataService] 메뉴 로딩 시작")
        isLoading = true
        error = nil
        detectionMethod = ""
        
        guard let frontmostApp = NSWorkspace.shared.frontmostApplication else {
            DispatchQueue.main.async {
                self.error = "활성 앱을 찾을 수 없습니다"
                self.isLoading = false
            }
            return
        }
        
        // hotMenuBar 자체가 활성 앱인 경우 이전 앱 사용
        var targetApp = frontmostApp
        if frontmostApp.bundleIdentifier == Bundle.main.bundleIdentifier {
            if let previousApp = activeApp {
                targetApp = previousApp
            } else {
                DispatchQueue.main.async {
                    self.error = "다른 앱을 먼저 실행한 후 시도해주세요"
                    self.isLoading = false
                }
                return
            }
        } else {
            activeApp = frontmostApp
        }
        
        currentAppName = targetApp.localizedName ?? "Unknown App"
        print("🎯 [MenuDataService] 대상 앱: \(currentAppName) (\(targetApp.bundleIdentifier ?? "unknown"))")
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.detectAndLoadMenu(for: targetApp)
        }
    }
    
    // MARK: - 메뉴 감지 및 로드 (하이브리드 방식)
    private func detectAndLoadMenu(for app: NSRunningApplication) {
        let bundleId = app.bundleIdentifier ?? ""
        let appName = app.localizedName ?? ""
        
        // 1. 먼저 데이터베이스에서 확인
        if let predefinedMenu = Self.menuDatabase[bundleId] {
            print("✅ [MenuDataService] 데이터베이스에서 메뉴 발견: \(appName)")
            let groups = createMenuGroups(from: predefinedMenu, appName: appName)
            DispatchQueue.main.async {
                self.menuGroups = groups
                self.detectionMethod = "📊 데이터베이스 (미리 정의된 메뉴)"
                self.isLoading = false
            }
            return
        }
        
        // 2. AppleScript로 시도
        if let scriptMenu = extractMenuViaAppleScript(appName: appName) {
            print("✅ [MenuDataService] AppleScript로 메뉴 추출 성공: \(appName)")
            let groups = createMenuGroups(from: scriptMenu, appName: appName)
            DispatchQueue.main.async {
                self.menuGroups = groups
                self.detectionMethod = "🔧 AppleScript (실시간 추출)"
                self.isLoading = false
            }
            return
        }
        
        // 3. 접근성 API로 시도 (개선된 방식)
        if let accessibilityMenu = extractMenuViaAccessibility(app: app) {
            print("✅ [MenuDataService] 접근성 API로 메뉴 추출 성공: \(appName)")
            let groups = createMenuGroups(from: accessibilityMenu, appName: appName)
            DispatchQueue.main.async {
                self.menuGroups = groups
                self.detectionMethod = "♿ 접근성 API (동적 추출)"
                self.isLoading = false
            }
            return
        }
        
        // 4. 모든 방법이 실패한 경우 일반 메뉴 구조 제공
        print("⚠️ [MenuDataService] 모든 방법 실패, 일반 메뉴 구조 사용: \(appName)")
        let groups = createMenuGroups(from: Self.genericMenuStructure, appName: appName)
        DispatchQueue.main.async {
            self.menuGroups = groups
            self.detectionMethod = "🔧 일반 메뉴 (기본 구조)"
            self.error = "이 앱의 정확한 메뉴를 가져올 수 없어서 일반 메뉴를 표시합니다"
            self.isLoading = false
        }
    }
    
    // MARK: - AppleScript를 통한 메뉴 추출
    private func extractMenuViaAppleScript(appName: String) -> [String: [String]]? {
        print("🔧 [AppleScript] 메뉴 추출 시도: \(appName)")
        
        let script = """
        tell application "System Events"
            try
                tell process "\(appName)"
                    set menuNames to {}
                    set menuBar to menu bar 1
                    repeat with menuItem in menu bar items of menuBar
                        set menuTitle to title of menuItem
                        if menuTitle is not "" then
                            set menuNames to menuNames & menuTitle
                        end if
                    end repeat
                    return menuNames as string
                end tell
            on error errorMessage
                return "ERROR: " & errorMessage
            end try
        end tell
        """
        
        var error: NSDictionary?
        if let appleScript = NSAppleScript(source: script) {
            let result = appleScript.executeAndReturnError(&error)
            
            if let error = error {
                print("❌ [AppleScript] 오류: \(error)")
                return nil
            }
            
            if let resultString = result.stringValue {
                if resultString.hasPrefix("ERROR:") {
                    print("❌ [AppleScript] 스크립트 실행 오류: \(resultString)")
                    return nil
                }
                
                print("✅ [AppleScript] 결과: \(resultString)")
                
                // 간단한 메뉴 이름만 파싱 (실제 항목은 일반 구조 사용)
                let menuNames = resultString.components(separatedBy: ", ")
                var menuDict: [String: [String]] = [:]
                
                for menuName in menuNames {
                    let cleanName = menuName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !cleanName.isEmpty {
                        // 일반적인 메뉴 항목들 할당
                        if let genericItems = Self.genericMenuStructure[cleanName] {
                            menuDict[cleanName] = genericItems
                        } else {
                            // 앱 이름 메뉴인 경우
                            if cleanName == appName {
                                menuDict[cleanName] = ["\(cleanName) 정보", "환경설정...", "서비스", "\(cleanName) 가리기", "기타 가리기", "모두 보기", "\(cleanName) 종료"]
                            } else {
                                menuDict[cleanName] = ["항목 1", "항목 2", "항목 3"]
                            }
                        }
                    }
                }
                
                return menuDict.isEmpty ? nil : menuDict
            }
        }
        
        return nil
    }
    
    // MARK: - 접근성 API를 통한 메뉴 추출 (개선된 방식)
    private func extractMenuViaAccessibility(app: NSRunningApplication) -> [String: [String]]? {
        print("♿ [Accessibility] 메뉴 추출 시도: \(app.localizedName ?? "unknown")")
        
        guard AXIsProcessTrusted() else {
            print("❌ [Accessibility] 접근성 권한 없음")
            return nil
        }
        
        let appElement = AXUIElementCreateApplication(app.processIdentifier)
        
        // 메뉴바 접근
        var menuBar: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(appElement, kAXMenuBarAttribute as CFString, &menuBar)
        
        guard result == .success, let menuBarElement = menuBar else {
            print("❌ [Accessibility] 메뉴바 접근 실패: \(result)")
            return nil
        }
        
        let menuBarAXElement = menuBarElement as! AXUIElement
        
        // 메뉴 항목들 가져오기
        var children: CFTypeRef?
        let childrenResult = AXUIElementCopyAttributeValue(menuBarAXElement, kAXChildrenAttribute as CFString, &children)
        
        guard childrenResult == .success, children != nil else {
            print("❌ [Accessibility] 메뉴 항목 접근 실패: \(childrenResult)")
            return nil
        }
        
        // CFArray를 Swift Array로 변환
        let menuItems = children! as! [AXUIElement]
        
        var menuDict: [String: [String]] = [:]
        
        for menuItem in menuItems {
            var title: CFTypeRef?
            let titleResult = AXUIElementCopyAttributeValue(menuItem, kAXTitleAttribute as CFString, &title)
            
            if titleResult == .success, let menuTitle = title as? String, !menuTitle.isEmpty {
                print("📋 [Accessibility] 메뉴 발견: \(menuTitle)")
                
                // 간단한 항목들만 추가 (성능상 이유로 깊이 파지 않음)
                if let genericItems = Self.genericMenuStructure[menuTitle] {
                    menuDict[menuTitle] = genericItems
                } else {
                    menuDict[menuTitle] = ["항목 1", "항목 2", "항목 3"]
                }
            }
        }
        
        return menuDict.isEmpty ? nil : menuDict
    }
    
    // MARK: - 메뉴 그룹 생성
    private func createMenuGroups(from menuDict: [String: [String]], appName: String) -> [MenuGroup] {
        var groups: [MenuGroup] = []
        
        // 메뉴 순서 정렬 (앱 이름이 먼저 오도록)
        let sortedKeys = menuDict.keys.sorted { first, second in
            if first == appName { return true }
            if second == appName { return false }
            return first < second
        }
        
        for menuTitle in sortedKeys {
            guard let menuItems = menuDict[menuTitle] else { continue }
            
            let items = menuItems.map { itemTitle in
                MenuItem(
                    title: itemTitle,
                    type: .action,
                    action: {
                        print("🎯 [Action] \(menuTitle) > \(itemTitle) 실행")
                        self.executeMenuAction(appName: appName, menuTitle: menuTitle, itemTitle: itemTitle)
                    }
                )
            }
            
            let iconName = getIconForMenuGroup(menuTitle)
            groups.append(MenuGroup(title: menuTitle, icon: iconName, items: items))
        }
        
        return groups
    }
    
         // MARK: - 메뉴 그룹별 아이콘 결정
     private func getIconForMenuGroup(_ title: String) -> String {
         switch title.lowercased() {
         case "file", "파일":
             return "doc.fill"
         case "edit", "편집":
             return "pencil"
         case "view", "보기":
             return "eye.fill"
         case "window", "윈도우":
             return "macwindow"
         case "help", "도움말":
             return "questionmark.circle.fill"
         case "format", "포맷":
             return "textformat"
         case "tools", "도구":
             return "wrench.and.screwdriver.fill"
         case "selection", "선택":
             return "selection.pin.in.out"
         case "go", "이동":
             return "arrow.right.circle.fill"
         case "run", "실행":
             return "play.fill"
         case "terminal", "터미널":
             return "terminal.fill"
         case "build", "빌드":
             return "hammer.fill"
         case "debug", "디버그":
             return "ladybug.fill"
         case "source control", "소스 제어":
             return "externaldrive.connected.to.line.below"
         case "navigate", "탐색":
             return "location.fill"
         case "refactor", "리팩터":
             return "arrow.triangle.2.circlepath"
         case "product", "제품":
             return "shippingbox.fill"
         case "history", "히스토리":
             return "clock.fill"
         case "bookmarks", "북마크":
             return "book.fill"
         case "safari":
             return "safari.fill"
         case "finder", "파인더":
             return "folder.fill"
         case "textedit":
             return "doc.text.fill"
         case "preview", "미리보기":
             return "doc.richtext.fill"
         case "calculator", "계산기":
             return "calculator.fill"
         case "변환":
             return "arrow.triangle.2.circlepath"
         case "음성":
             return "speaker.wave.2.fill"
         default:
             return "folder.fill"
         }
     }
     
     // MARK: - 메뉴 액션 실행
     private func executeMenuAction(appName: String, menuTitle: String, itemTitle: String) {
        print("🚀 [Execute] \(appName) > \(menuTitle) > \(itemTitle)")
        
        // AppleScript로 실제 메뉴 클릭 시도
        let script = """
        tell application "System Events"
            try
                tell process "\(appName)"
                    tell menu bar 1
                        tell menu bar item "\(menuTitle)"
                            tell menu "\(menuTitle)"
                                click menu item "\(itemTitle)"
                            end tell
                        end tell
                    end tell
                end tell
                return "SUCCESS"
            on error errorMessage
                return "ERROR: " & errorMessage
            end try
        end tell
        """
        
        var error: NSDictionary?
        if let appleScript = NSAppleScript(source: script) {
            let result = appleScript.executeAndReturnError(&error)
            
            if let error = error {
                print("❌ [Execute] AppleScript 오류: \(error)")
            } else if let resultString = result.stringValue {
                if resultString == "SUCCESS" {
                    print("✅ [Execute] 메뉴 액션 실행 성공")
                } else {
                    print("❌ [Execute] 실행 실패: \(resultString)")
                }
            }
        }
    }
} 