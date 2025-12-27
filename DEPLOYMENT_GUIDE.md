# Tech Vibe 部署與使用指南

## 概述

Tech Vibe 是一個 Flutter Web 應用，結合 Hugging Face AI 模型進行任務分解。本指南涵蓋開發、本地測試和部署到 GitHub Pages。

## 架構

```
┌─────────────────────────────────────────────────────────────┐
│  前端：Flutter Web (GitHub Pages)                            │
│  - 任務管理                                                   │
│  - 月曆視圖                                                   │
│  - 倒數計時                                                   │
│  - AI 任務分解功能                                            │
└──────────────────┬──────────────────────────────────────────┘
                   │ HTTP POST
                   ▼
┌──────────────────────────────────────────────────────────────┐
│  後端：Node.js Express Server                                │
│  - /api/decompose - 任務分解 API                            │
│  - /health - 健康檢查                                        │
│  - 調用 Hugging Face Inference API                         │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────────────────┐
│  Hugging Face Inference API                                  │
│  - 模型：google/flan-t5-base                                │
│  - 用途：文字生成（任務分解）                                 │
└──────────────────────────────────────────────────────────────┘
```

---

## 本地開發

### 前置要求

- **Flutter SDK** ≥ 3.0.0（[安裝](https://flutter.dev/docs/get-started/install)）
- **Node.js** ≥ 16（用於後端，[安裝](https://nodejs.org)）
- **Hugging Face API Token**（[獲取](https://huggingface.co/settings/tokens)）

### 步驟 1：設置後端

```bash
cd backend

# 複製環境變數範本
cp .env.example .env

# 編輯 .env，填入你的 Hugging Face Token
# HUGGING_FACE_API_TOKEN=your_token_here

# 安裝依賴
npm install

# 啟動開發伺服器
npm run dev
# 或
npm start
```

伺服器將運行在 `http://localhost:3000`

#### 驗證後端

```bash
curl http://localhost:3000/health
# 應該回傳: {"status":"ok","message":"Tech Vibe Backend is running"}
```

### 步驟 2：運行 Flutter Web

在新的終端：

```bash
# 在項目根目錄
flutter pub get
flutter run -d chrome
```

應用將自動在瀏覽器中打開 `http://localhost:????`（通常 port 會不同）

### 步驟 3：測試 AI 功能

1. 打開應用
2. 點擊「新增任務」區塊右上方的 ✨ 圖標
3. 輸入任務描述（例如：「準備跨年派對」）
4. 點擊「分析」按鈕
5. 等待 AI 分解結果

---

## API 文檔

### POST /api/decompose

**功能**：使用 Hugging Face AI 分解任務為子任務與時間估算

**請求**：

```json
{
  "taskDescription": "準備跨年派對，邀請朋友，佈置場地，準備食物和飲料"
}
```

**回應**（成功）：

```json
{
  "status": "success",
  "data": {
    "input": "準備跨年派對，邀請朋友，佈置場地，準備食物和飲料",
    "output": "1. 邀請朋友 - 預計時間：0.5小時\n2. 佈置場地 - 預計時間：2小時\n..."
  },
  "error": null
}
```

**回應**（失敗）：

```json
{
  "status": "error",
  "data": null,
  "error": "伺服器未設定 Hugging Face API Token"
}
```

**HTTP 狀態碼**：
- `200` - 成功
- `400` - 請求格式錯誤
- `500` - 伺服器錯誤

---

## 部署到 GitHub Pages

### 前置要求

- GitHub 賬戶
- 代碼已推送到 GitHub
- Repository Settings 中已啟用 GitHub Pages

### 自動部署

1. **提交代碼**

```bash
git add .
git commit -m "準備部署"
git push origin main
```

2. **GitHub Actions 自動執行**

GitHub Actions 會自動：
- 檢出代碼
- 安裝 Flutter SDK
- 執行 `flutter pub get`
- 構建生產版本：`flutter build web --release`
- 部署到 GitHub Pages (`gh-pages` 分支)

### 查看部署狀態

1. 進入 Repository 主頁
2. 點擊 **Actions** 標籤
3. 查看最新的 Workflow 運行結果

### 訪問應用

部署完成後，應用可在以下 URL 訪問：

```
https://<your-github-username>.github.io/<repository-name>
```

例如：`https://john-doe.github.io/tech-vibe`

---

## 環境配置

### 本地開發環境

```bash
# 後端 .env
HUGGING_FACE_API_TOKEN=hf_xxxxxxxxxxxx
PORT=3000
NODE_ENV=development
```

### 生產環境

對於 GitHub Pages 上的應用，後端 URL 應設定為實際的後端服務 URL。

**修改位置**：`lib/utils/ai_service.dart`

```dart
static String get _backendUrl {
  // 開發環境
  if (kDebugMode) {
    return 'http://localhost:3000';
  }
  // 生產環境 - 設定實際的後端 URL
  return 'https://your-backend-domain.com';
}
```

**推薦的生產後端部署方案**：

1. **Vercel**（推薦，免費層適合小規模使用）
   - 部署 `backend/` 目錄
   - 設定環境變數 `HUGGING_FACE_API_TOKEN`
   - 獲得 URL（例如 `https://tech-vibe-api.vercel.app`）

2. **Heroku**（付費，但簡單）

3. **AWS Lambda / Google Cloud Run**（按需計費）

4. **自託管 VPS**（完全控制，需要維護）

---

## 常見問題

### Q: 為什麼 AI 分解功能在 GitHub Pages 上不工作？

**A**: GitHub Pages 是靜態網站主機。你需要部署後端服務到其他平台（Vercel、Heroku 等），然後更新 `ai_service.dart` 中的後端 URL。

### Q: 如何測試本地後端？

```bash
# 在後端目錄運行
curl -X POST http://localhost:3000/api/decompose \
  -H "Content-Type: application/json" \
  -d '{"taskDescription":"測試任務"}'
```

### Q: 如何獲得 Hugging Face API Token？

1. 訪問 [huggingface.co/settings/tokens](https://huggingface.co/settings/tokens)
2. 點擊「New token」
3. 選擇 **Read** 權限
4. 複製 token

### Q: 應用無法加載本地存儲的數據？

確保：
- 使用 HTTPS 或 localhost（shared_preferences 在某些環境有限制）
- 檢查瀏覽器開發者工具的 Console 和 Storage 標籤
- 清除瀏覽器緩存並重試

---

## 開發相關

### 項目結構

```
tech-vibe/
├── lib/                          # Flutter 代碼
│   ├── main.dart                 # 應用入口
│   ├── models/                   # 數據模型
│   │   ├── task_model.dart       # 任務模型
│   │   ├── countdown_model.dart  # 倒數計時模型
│   │   └── app_state.dart        # 應用全局狀態
│   ├── providers/                # 狀態管理
│   │   └── task_provider.dart    # 任務 Provider
│   ├── screens/                  # 屏幕
│   │   └── home_screen.dart      # 主屏幕
│   ├── widgets/                  # 組件
│   │   ├── task_block.dart       # 任務區塊（可拖曳）
│   │   ├── task_pool.dart        # 任務池
│   │   ├── day_container.dart    # 一日容器
│   │   ├── task_creation.dart    # 任務建立表單
│   │   ├── task_edit_dialog.dart # 任務編輯對話
│   │   ├── task_decompose_dialog.dart # AI 分解對話
│   │   ├── countdowns_section.dart    # 倒數計時區塊
│   │   └── reference_lines.dart  # 參考線
│   └── utils/                    # 工具
│       ├── constants.dart        # 常數與顏色
│       ├── storage.dart          # 本地存儲
│       └── ai_service.dart       # AI 服務
├── backend/                      # Node.js 後端
│   ├── server.js                 # Express 伺服器
│   ├── package.json              # 依賴
│   ├── .env.example              # 環境變數範本
│   └── README.md                 # 後端說明
├── pubspec.yaml                  # Flutter 依賴
├── web/                          # Web 資源
│   └── index.html                # 主 HTML
└── .github/
    └── workflows/
        └── deploy.yml            # 部署工作流
```

### 主要依賴

**Flutter**：
- `provider` - 狀態管理
- `shared_preferences` - 本地存儲
- `http` - HTTP 請求
- `uuid` - UUID 生成
- `intl` - 國際化和日期格式

**Node.js**：
- `express` - Web 框架
- `cors` - CORS 支持
- `dotenv` - 環境變數

---

## 貢獻指南

1. Fork 本倉庫
2. 創建功能分支（`git checkout -b feature/AmazingFeature`）
3. 提交更改（`git commit -m 'Add AmazingFeature'`）
4. 推送到分支（`git push origin feature/AmazingFeature`）
5. 開啟 Pull Request

---

## 許可

This project is licensed under the MIT License - see LICENSE file for details.

---

## 聯繫

有任何問題或建議，請提出 GitHub Issue 或聯繫維護者。
