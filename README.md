# hotMenuBar

> macOS 메뉴바 기반 생산성 앱

## 📖 프로젝트 개요

hotMenuBar는 macOS 메뉴바에서 접근 가능한 생산성 도구입니다. SwiftUI를 기반으로 구축되어 현대적이고 직관적인 사용자 인터페이스를 제공합니다.

## 🚀 주요 기능

### 현재 구현된 기능
- 기본 SwiftUI 앱 구조
- macOS 네이티브 인터페이스

### 계획된 기능
- 메뉴바 통합
- 빠른 접근 도구
- 시스템 모니터링
- 커스터마이징 가능한 위젯

## 🛠 기술 스택

- **언어**: Swift
- **프레임워크**: SwiftUI
- **플랫폼**: macOS
- **아키텍처**: MVVM
- **최소 지원 버전**: macOS 12.0+

## 📁 프로젝트 구조

```
hotMenuBar/
├── hotMenuBar/
│   ├── hotMenuBar/
│   │   ├── hotMenuBarApp.swift      # 앱 진입점
│   │   ├── ContentView.swift        # 메인 화면
│   │   └── Assets.xcassets/         # 앱 에셋
│   ├── hotMenuBarTests/             # 단위 테스트
│   └── hotMenuBarUITests/           # UI 테스트
└── README.md
```

## 🔧 개발 환경 설정

### 요구사항
- macOS 12.0 이상
- Xcode 14.0 이상
- Swift 5.7 이상

### 설치 및 실행
1. 저장소 클론
```bash
git clone [repository-url]
cd hotMenuBar
```

2. Xcode에서 프로젝트 열기
```bash
open hotMenuBar.xcodeproj
```

3. 빌드 및 실행
- `Cmd + R`로 앱 실행
- 또는 Product > Run 메뉴 사용

## 📝 개발 히스토리

### v0.1.0 (2025.06.19)
- 🎉 초기 프로젝트 생성
- ✨ 기본 SwiftUI 앱 구조 구축
- 📝 README.md 초기 버전 작성

## 🔍 코드 구조

### hotMenuBarApp.swift
앱의 메인 진입점으로 SwiftUI의 `@main` 어노테이션을 사용하여 앱 생명주기를 관리합니다.

### ContentView.swift
앱의 주요 사용자 인터페이스를 담당하는 뷰입니다. 현재는 기본 "Hello, world!" 화면을 표시합니다.

## 🎯 로드맵

### 단기 목표 (1-2주)
- [ ] 메뉴바 통합 구현
- [ ] 기본 UI/UX 디자인
- [ ] 설정 화면 추가

### 중기 목표 (1-2개월)
- [ ] 시스템 모니터링 기능
- [ ] 사용자 커스터마이징 옵션
- [ ] 퍼포먼스 최적화

### 장기 목표 (3-6개월)
- [ ] 플러그인 시스템
- [ ] 클라우드 동기화
- [ ] 앱스토어 배포

## 🤝 기여 가이드

### 커밋 메시지 규칙
한국어로 깃허브 컨벤션에 맞춰 작성:
- `feat: 새로운 기능 추가`
- `fix: 버그 수정`
- `docs: 문서 업데이트`
- `style: 코드 스타일 변경`
- `refactor: 코드 리팩토링`
- `test: 테스트 추가/수정`
- `chore: 빌드 프로세스 또는 보조 도구 변경`

### 개발 프로세스
1. 기능 브랜치 생성
2. 개발 및 테스트
3. Pull Request 생성
4. 코드 리뷰 후 병합

## 📊 성능 및 품질

### 테스트
- 단위 테스트: `hotMenuBarTests/`
- UI 테스트: `hotMenuBarUITests/`

### 코드 품질
- SwiftLint 사용 권장
- 코드 커버리지 목표: 80% 이상

## 📞 연락처

프로젝트 관련 문의나 제안사항이 있으시면 이슈를 생성해주세요.

## 📄 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다.

---

*마지막 업데이트: 2025.06.19*
