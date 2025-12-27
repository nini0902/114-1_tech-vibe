# Tech Vibe - 一日時間視覺化工具

一個 Flutter Web 應用，幫助使用者以「時間容量」的概念規劃一天的任務。

## 核心特色

- **時間容量視覺化**：任務不是列表，而是有「體積」的區塊
- **拖曳規劃**：直覺的拖曳互動，快速調整任務安排
- **本地儲存**：資料保存到瀏覽器，無需伺服器
- **跨平台支援**：可部署到 Web、iOS、Android（未來）

## 快速開始

### 前置需求
- Flutter SDK ≥ 3.0.0
- Chrome、Firefox、Safari 或 Edge 等現代瀏覽器

### 本地開發

```bash
# 1. 克隆或下載此專案
cd tech-vibe

# 2. 安裝依賴
flutter pub get

# 3. 啟動開發伺服器
flutter run -d chrome

# 4. 開啟瀏覽器訪問 http://localhost:xxxxx
```

### 部署到 GitHub Pages

```bash
# 1. 構建發佈版本
flutter build web --release

# 2. 部署
# 使用 GitHub Actions（自動）或手動上傳 build/web 到 gh-pages 分支
```

## 使用說明

1. **新增任務**：輸入任務名稱和預估時長，點擊「新增」
2. **拖曳到今日**：從左側待放置區拖曳任務到右側「今日規劃」
3. **觀察容量**：一眼看出今日時間安排是否合理
4. **調整**：拖曳移除或刪除不需要的任務
5. **自動保存**：所有資料自動保存到瀏覽器

## 技術棧

- **框架**：Flutter Web (Dart)
- **狀態管理**：Provider
- **本地儲存**：shared_preferences
- **拖曳功能**：Flutter 原生 Draggable + DragTarget
- **部署**：GitHub Pages

## 專案結構

```
tech-vibe/
├── lib/
│   ├── main.dart                 # 應用入口
│   ├── models/
│   │   ├── task_model.dart       # Task 數據模型
│   │   └── app_state.dart        # 全局應用狀態
│   ├── providers/
│   │   └── task_provider.dart    # 任務狀態管理
│   ├── screens/
│   │   └── home_screen.dart      # 主畫面
│   ├── widgets/
│   │   ├── task_creation.dart    # 任務建立區
│   │   ├── task_pool.dart        # 待放置任務池
│   │   ├── day_container.dart    # 一日容器
│   │   ├── task_block.dart       # 任務區塊
│   │   └── reference_lines.dart  # 參考線
│   └── utils/
│       ├── constants.dart        # 常數和工具函數
│       └── storage.dart          # 本地儲存服務
├── web/                          # Web 特定資源
├── pubspec.yaml                  # 依賴管理
└── README.md                     # 本文件
```

## 開發計畫

參考 `plan.md` 和 `tasks.md` 了解詳細的開發階段和任務清單。

## MVP 功能清單

- ✅ 任務建立與視覺化
- ✅ 拖曳到容器
- ✅ 本地儲存
- ✅ 刪除任務
- ✅ 參考線顯示

## 未來擴展

- [ ] 多天視圖（週規劃）
- [ ] 任務分類和標籤
- [ ] 匯出功能
- [ ] iOS/Android 原生應用
- [ ] 深色模式

## 許可

MIT License

## 聯絡方式

有任何問題或建議，歡迎提交 Issue。
