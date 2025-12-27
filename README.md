# Tech Vibe - 一日時間視覺化工具

一個 **Flutter Web** 應用，幫助使用者以「時間容量」的概念規劃一天的任務。直觀的拖曳互動、深色沉穩主題、AI 任務分解輔助。

![Status](https://img.shields.io/badge/Status-Ready-brightgreen) 
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue) 
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ 核心特色

### 📊 時間容量視覺化
- 任務不是文字清單，而是有「體積」的區塊
- 直觀看出一天的時間負荷
- 每個任務高度反映時長（0.5 小時為單位）

### 🎯 拖曳規劃
- **拖曳進出**：任務池 ↔ 今日時間表
- **調整時長**：拖曳任務下邊緣調整時長（0.5 小時為單位）
- **視覺反饋**：拖曳把手、半透明提示

### 📝 完整任務管理
- ✅ 新增任務（名稱 + 時長 + 備註）
- ✅ 編輯任務（點擊打開對話框）
- ✅ 標記完成（Checklist 功能 + 慶祝動畫）
- ✅ 刪除任務

### ⏰ 倒數計時
- 重大事件倒數卡片（左上方）
- 自動計算剩餘時間（天/小時/分鐘）
- 快速刪除（右上角 X）

### 🤖 AI 任務分解
- **✨ AI 按鈕**：任務建立區右上角
- **智能分解**：輸入複雜任務，AI 幫你拆解成子任務
- **時間估算**：AI 還會估算每個子任務的時間
- **後端整合**：Hugging Face Inference API

### 🎨 深色沉穩主題
- 深灰藍背景（#1a1a2e）
- 紫色 + 青藍強調色
- 6 種多彩任務顏色
- 高對比度易讀文本

### 💾 數據持久化
- 本地存儲（無需伺服器）
- 自動保存任務、倒數、完成狀態
- 刷新頁面後數據保留

## 🚀 快速開始

### 前置需求
- **Flutter SDK** ≥ 3.0
- **Node.js** ≥ 14（如需 AI 功能）
- **Hugging Face API Token**（如需 AI 功能）
- 現代瀏覽器（Chrome、Firefox、Safari）

### 步驟 1：啟動後端（可選，但 AI 功能需要）

```bash
cd backend

# 複製環境配置
cp .env.example .env

# 編輯 .env，填入 Hugging Face Token
# HUGGING_FACE_API_TOKEN=hf_xxxxx
# 從 https://huggingface.co/settings/tokens 獲取

# 安裝依賴
npm install

# 啟動伺服器
npm run dev
# 伺服器在 http://localhost:3000
```

### 步驟 2：啟動前端

在另一個終端窗口：

```bash
# 回到項目根目錄
cd ..

# 安裝依賴
flutter pub get

# 啟動開發伺服器
flutter run -d chrome
# 應該會自動打開 Chrome，訪問 http://localhost:8080
```

### 步驟 3：開始使用！

1. 在上方「新增任務」區輸入任務
2. 拖曳任務到右側「今日規劃」
3. 點擊任務編輯，或拖曳下邊緣調整時長
4. 點擊複選框標記完成 ✅
5. 所有數據自動保存 💾

更多詳細說明見 **[QUICK_START.md](QUICK_START.md)**

## 📚 文檔

| 文檔 | 說明 |
|------|------|
| [QUICK_START.md](QUICK_START.md) | ⭐ 快速開始和使用說明 |
| [SPEC.md](SPEC.md) | 功能規格書 |
| [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) | 架構和實現細節 |
| [CHANGELOG_IMPLEMENTATION.md](CHANGELOG_IMPLEMENTATION.md) | 完整更新日誌 |
| [FEATURE_CHECKLIST.md](FEATURE_CHECKLIST.md) | 功能清單和完成度 |
| [backend/README.md](backend/README.md) | 後端 API 文檔 |

## 🎯 功能清單

### 核心功能
- [x] 新增任務（名稱、時長、備註）
- [x] 編輯任務（打開對話框）
- [x] 刪除任務
- [x] 拖曳進出時間表
- [x] 本地儲存

### 進階功能
- [x] 拖曳下邊緣調整時長（0.5hr 單位）
- [x] 任務完成標記（Checklist）
- [x] 完成慶祝動畫（🎉）
- [x] 倒數計時系統
- [x] AI 任務分解（Hugging Face）

### UI/UX
- [x] 深色沉穩主題
- [x] 多彩任務顏色
- [x] 參考線（8、16、24 小時）
- [x] 拖曳視覺反饋
- [x] 錯誤和成功提示

**完成度：✅ 100%** - 所有計劃功能已實現

詳見 [FEATURE_CHECKLIST.md](FEATURE_CHECKLIST.md)

## 🏗️ 技術棧

### 前端
- **框架**：Flutter 3.0+ (Dart)
- **狀態管理**：Provider
- **本地儲存**：shared_preferences
- **拖曳**：Draggable + DragTarget
- **主題**：Material Design 深色主題

### 後端
- **伺服器**：Node.js + Express
- **AI 模型**：Hugging Face Inference API (flan-t5-base)
- **配置**：dotenv

### 部署
- **前端**：GitHub Pages
- **後端**：可部署到 Heroku、Railway、AWS 等

## 📁 專案結構

```
tech-vibe/
├── lib/                              # Flutter 前端代碼
│   ├── main.dart                     # 應用入口（深色主題）
│   ├── models/
│   │   ├── task_model.dart           # Task 模型
│   │   ├── countdown_model.dart      # Countdown 模型（新）
│   │   └── app_state.dart            # 全局狀態
│   ├── providers/
│   │   └── task_provider.dart        # 狀態管理（新方法）
│   ├── screens/
│   │   └── home_screen.dart          # 主畫面（新增倒數區）
│   ├── widgets/
│   │   ├── task_creation.dart        # 任務建立（新增備註、AI 按鈕）
│   │   ├── task_block.dart           # 任務區塊（完全重寫）
│   │   ├── task_pool.dart            # 待放置任務池（深色主題）
│   │   ├── day_container.dart        # 一日容器（深色主題）
│   │   ├── reference_lines.dart      # 參考線（深色主題）
│   │   ├── task_edit_dialog.dart     # 編輯對話框（新）
│   │   ├── countdowns_section.dart   # 倒數區塊（新）
│   │   └── task_decompose_dialog.dart # AI 分解（新）
│   └── utils/
│       ├── constants.dart            # 常數（深色色系）
│       ├── storage.dart              # 本地儲存
│       └── ai_service.dart           # AI API 客戶端（新）
├── backend/                          # Node.js 後端
│   ├── server.js                     # Express 伺服器
│   ├── package.json                  # 依賴管理
│   ├── .env.example                  # 環境變數範本
│   └── README.md                     # 後端文檔
├── web/                              # Web 特定資源
├── pubspec.yaml                      # Flutter 依賴
├── SPEC.md                           # 功能規格
├── plan.md                           # 開發計畫
├── IMPLEMENTATION_GUIDE.md           # 實裝指南
├── QUICK_START.md                    # 快速開始
└── README.md                         # 本文件
```

## 🎨 設計亮點

### 深色配色
```
背景：#1a1a2e（深灰藍）
卡片：#16213e（更深藍）
文本：#e0e0e0（淺灰）
強調：#9d4edd（紫色）+ #3a86ff（青藍）
```

### 任務顏色
6 種多彩顏色基於任務 ID 自動分配，保證一致性。

## 🔧 開發

### 本地開發
```bash
# 啟動 Flutter 開發伺服器（支援熱重載）
flutter run -d chrome

# 啟動後端開發伺服器
cd backend && npm run dev
```

### 構建生產版本
```bash
# 前端
flutter build web --release
# 輸出在 build/web/

# 後端（使用 npm start）
npm start
```

### 代碼檢查
```bash
# Flutter lint
flutter analyze
```

## 🚀 部署

### 前端部署（GitHub Pages）
```bash
flutter build web --release
# 上傳 build/web/ 到 gh-pages 分支
# 或配置 GitHub Actions 自動部署
```

### 後端部署
```bash
# 部署到 Heroku
git push heroku main

# 或部署到其他平台
# 確保設定環境變數 HUGGING_FACE_API_TOKEN
```

## 📊 性能

- ⚡ 快速載入（首次 ~3-5MB，使用 release 模式優化）
- 🔄 熱重載開發（< 1 秒）
- 📱 響應式設計
- 💾 本地存儲無延遲

## 🔐 安全性

- ✅ Hugging Face Token 存儲在後端環境變數
- ✅ 前端不暴露敏感信息
- ✅ CORS 正確配置
- ✅ 輸入驗證

## 🐛 故障排除

### 後端無法連接
```bash
# 檢查伺服器
curl http://localhost:3000/health
```

### AI 功能不工作
- 檢查 `.env` 中的 Token 是否正確
- 確認 Token 未過期（https://huggingface.co/settings/tokens）

### 任務不保存
- 檢查瀏覽器本地存儲是否啟用
- 查看 Chrome DevTools → Application → Local Storage

詳見 [QUICK_START.md](QUICK_START.md) 的故障排除部分。

## 💡 下一步

- [ ] 月曆日期選擇
- [ ] 任務分類/標籤
- [ ] 統計面板
- [ ] 主題切換（深色/亮色）
- [ ] 更多 AI 模型支持
- [ ] 移動端原生應用

## 📄 許可

MIT License - 自由使用和修改

## 👤 作者

由 GitHub Copilot 協助開發

## 🙏 感謝

- Flutter Team（框架）
- Hugging Face（AI 模型）
- 所有貢獻者和使用者

---

**準備好了嗎？** 👉 [QUICK_START.md](QUICK_START.md)

**有問題？** 👉 查看文檔或提交 Issue

**想了解更多？** 👉 [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)

🎉 **祝你使用愉快！**

