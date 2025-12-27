# Tech Vibe - 快速設置指南

## 📋 項目概述

**Tech Vibe** 是一個全功能的日程規劃應用，具有以下特色：

✨ **核心功能**：
- 🎯 任務建立與管理（支援備註）
- 🖱️ 任務拖曳和排序
- ✅ 任務完成追蹤
- 🤖 AI 任務分解（使用 Hugging Face）
- ⏰ 倒數計時器
- 💾 自動本地存儲
- 🌙 現代深色主題

## 🚀 快速開始（開發模式）

### 前置要求
- **Flutter SDK** ≥ 3.0（[安裝](https://flutter.dev/docs/get-started/install)）
- **Node.js** ≥ 16（[安裝](https://nodejs.org)）
- **Hugging Face API Token**（[獲取](https://huggingface.co/settings/tokens)）

### 1️⃣ 設置後端（必須）

```bash
# 進入後端目錄
cd backend

# 複製環境範本
cp .env.example .env

# 編輯 .env 文件，填入你的 Hugging Face Token
# HUGGING_FACE_API_TOKEN=hf_xxxxxxxxxx

# 安裝依賴和啟動
npm install
npm run dev
```

✅ 後端將運行在 `http://localhost:3000`

**驗證後端**：
```bash
# 在新終端運行
curl http://localhost:3000/health
# 應該返回: {"status":"ok",...}
```

### 2️⃣ 運行 Flutter Web（在新終端）

```bash
# 在項目根目錄
flutter pub get
flutter run -d chrome
```

🎉 應用會自動在瀏覽器中打開

## 🌐 部署到 GitHub Pages

### 前置配置

1. **確保後端已部署**
   - 推薦使用 **Vercel** 部署後端（免費）
   - [Vercel 部署步驟](./DEPLOYMENT_GUIDE.md#生產環境)

2. **更新後端 URL**
   
   編輯 `lib/utils/ai_service.dart`：
   ```dart
   // 改為你的實際後端 URL
   static const String _backendUrl = 'https://your-backend.vercel.app';
   ```

3. **推送到 GitHub**
   ```bash
   git add .
   git commit -m "準備部署"
   git push origin main
   ```

### 自動部署

GitHub Actions 會自動：
1. 檢出代碼
2. 安裝 Flutter 和依賴
3. 構建生產版本（`flutter build web --release`）
4. 部署到 GitHub Pages

✅ 部署完成後，訪問：
```
https://<your-github-username>.github.io/<repo-name>
```

## 🎮 使用指南

### 新增任務
1. 在「新增任務」區塊輸入任務名稱和時長
2. （可選）添加備註說明
3. 點擊「新增」按鈕

### 拖曳任務
1. 點擊左側任務池中的任務
2. 拖曳到右側「今日規劃」容器
3. 可繼續拖曳調整位置

### 調整任務時長
1. 點擊任務區塊打開編輯對話框
2. 修改時長
3. 點擊「保存」

### 標記完成
- 點擊任務區塊上的複選框
- 完成後會有慶祝動畫 🎉

### AI 任務分解
1. 點擊「新增任務」右上方的 ✨ 按鈕
2. 輸入複雜任務描述
3. 點擊「分析」等待 AI 分解
4. 查看詳細的子任務和時間估算

### 倒數計時
1. 點擊左側「重大倒數」區塊中的 + 按鈕
2. 輸入事件名稱和日期
3. 實時看到倒數顯示

## 📁 項目結構速查

```
tech-vibe/
├── lib/                    # Flutter 源代碼
│   ├── main.dart          # 應用入口
│   ├── models/            # 數據模型（Task, Countdown, AppState）
│   ├── providers/         # TaskProvider (狀態管理)
│   ├── screens/           # HomeScreen
│   ├── widgets/           # 所有 UI 組件
│   └── utils/             # 常數、存儲、API 服務
├── backend/               # Node.js 後端
│   ├── server.js          # Express 伺服器
│   └── .env.example       # 環境範本
├── pubspec.yaml          # Flutter 依賴
├── web/                  # Web 資源
└── .github/workflows/    # GitHub Actions
```

## ⚙️ 配置修改

### 改變深色主題顏色
編輯 `lib/utils/constants.dart`：
```dart
static const Color darkBg = Color(0xFF1a1a2e);        // 背景色
static const Color accentPurple = Color(0xFF9d4edd);  // 強調色
static const Color accentCyan = Color(0xFF3a86ff);    // 輔助色
```

### 改變容器高度（時間單位）
```dart
static const double containerHeightHours = 16.0;  // 改為你的需要
```

### 改變時長選項
```dart
static const List<double> durationOptions = [0.5, 1.0, 1.5, 2.0, 3.0, 4.0];
```

## 🐛 常見問題

### Q: 後端無法連接
```bash
# 檢查後端是否運行
ps aux | grep node

# 重新啟動後端
cd backend && npm run dev
```

### Q: AI 功能無效
1. 檢查 `backend/.env` 中的 token 是否正確
2. 驗證 Hugging Face 免費額度未用完
3. 檢查瀏覽器開發者工具的 Network 標籤

### Q: 應用無法載入本地數據
- 清除瀏覽器緩存
- 重新打開應用
- 檢查 Local Storage（F12 > Application > Local Storage）

### Q: 部署後 AI 功能不工作
- 確認後端已部署到在線服務（Vercel/Heroku）
- 更新 `lib/utils/ai_service.dart` 中的後端 URL
- 確保後端 URL 在 Flutter 代碼中正確

## 📚 詳細文檔

- **完整部署指南**：[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
- **構建檢查清單**：[BUILD_CHECKLIST.md](./BUILD_CHECKLIST.md)
- **API 文檔**：[DEPLOYMENT_GUIDE.md#api-文檔](./DEPLOYMENT_GUIDE.md#api-文檔)

## 💡 開發提示

### 熱重載開發
```bash
flutter run -d chrome
# 修改代碼後自動重載（Ctrl+S 或 Cmd+S）
```

### 代碼分析
```bash
flutter analyze
```

### 清理構建
```bash
flutter clean
flutter pub get
```

### 查看日誌
```bash
flutter logs -v
```

## 🔒 安全提示

⚠️ **重要**：
- ❌ 不要在代碼中提交 Hugging Face API Token
- ✅ 總是使用 `.env` 文件存儲敏感信息
- ✅ 後端應該在環境變數中讀取 token，不要在代碼中硬編碼

## 🎯 下一步

1. **本地開發**：完成上面的開發步驟
2. **部署後端**：按照 [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) 部署到 Vercel
3. **配置前端**：更新後端 URL
4. **推送到 GitHub**：`git push origin main`
5. **享受！** 🚀

## 📞 需要幫助？

- 檢查 [BUILD_CHECKLIST.md](./BUILD_CHECKLIST.md)
- 查看 [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
- 查看項目 Issues 或提出新 Issue

---

**Made with ❤️ using Flutter + Node.js + Hugging Face**
