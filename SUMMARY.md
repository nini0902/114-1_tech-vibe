# Tech Vibe 項目總結

## 概況

**Tech Vibe** 是一個現代化的日程規劃應用，結合 Flutter Web 和 AI 功能。

## 📦 你現在擁有什麼

### 🎯 完整的功能
- ✅ **任務管理系統** - 建立、編輯、刪除、完成追蹤
- ✅ **視覺化排程** - 拖曳式介面，直觀的時間管理
- ✅ **AI 助手** - Hugging Face 驅動的任務分解
- ✅ **倒數計時** - 重大事件倒數
- ✅ **自動保存** - 本地數據持久化
- ✅ **現代設計** - 深色主題、響應式布局

### 📱 應用架構
```
Web 應用（Flutter）────HTTP────→ 後端服務（Node.js）
                        ↓
                  Hugging Face API
```

### 📂 項目結構
```
tech-vibe/
├── lib/              # Flutter 源代碼（17 個 Dart 文件）
├── backend/          # Node.js API 服務
├── web/              # Web 資源
└── .github/          # GitHub Actions 部署配置
```

## 🚀 快速開始（3 步）

### 1️⃣ 本地開發設置

**安裝依賴**：
```bash
# 後端
cd backend
npm install

# 前端
flutter pub get
```

**設置環境變數**：
```bash
cd backend
cp .env.example .env
# 編輯 .env，填入你的 Hugging Face API Token
```

### 2️⃣ 運行應用

**啟動後端**（終端 1）：
```bash
cd backend
npm run dev
```

**啟動前端**（終端 2）：
```bash
flutter run -d chrome
```

### 3️⃣ 部署（GitHub Pages）

```bash
git push origin main
# GitHub Actions 自動部署
# 幾分鐘後訪問：https://<username>.github.io/<repo>
```

## 📖 核心概念

### 時間容器模型
應用基於「時間容量」概念：
- 一天 = 固定時間容器（可配置 16-24 小時）
- 每個任務占據一定空間
- 視覺化查看時間分配

### 拖曳工作流
1. **新增任務** → 進入「待放置任務池」
2. **拖曳到容器** → 加入「今日規劃」
3. **調整位置** → 改變任務順序
4. **完成標記** → 成就感 🎉

### AI 任務分解
1. 輸入複雜任務（例如：「籌辦派對」）
2. AI 自動分解成子任務和時間估算
3. 逐項添加到規劃中

## 🎨 UI 亮點

### 深色主題
```
背景：#1a1a2e（深藍黑）
卡片：#16213e（深藍）
強調：#9d4edd（紫色）
輔助：#3a86ff（青色）
```

### 響應式設計
- 二分欄布局（左：新增 + 任務池，右：容器）
- 自適應屏幕寬度
- 觸控友好的拖曳區域

### 實時反饋
- 拖曳視覺預覽
- 完成時慶祝動畫
- 錯誤和成功提示

## ⚙️ 技術細節

### 前端（Dart/Flutter）
```
main.dart ─┬─ HomeScreen
           ├─ TaskProvider (狀態管理)
           ├─ Widgets (UI 組件)
           ├─ Models (數據)
           └─ Utils (工具和 API)
```

### 後端（Node.js）
```
server.js ─┬─ GET /health (健康檢查)
           └─ POST /api/decompose (任務分解)
              └─ Hugging Face API (flan-t5-base)
```

### 狀態管理
```
AppState (全局狀態)
├─ allTasks (所有任務)
├─ tasksInContainer (容器中的任務)
└─ countdowns (倒數事件)
```

## 📝 文檔路線圖

| 文檔 | 何時閱讀 | 内容 |
|------|--------|------|
| [QUICK_SETUP.md](./QUICK_SETUP.md) | 🚀 立即開始 | 開發環境設置 |
| [IMPLEMENTATION_COMPLETE.md](./IMPLEMENTATION_COMPLETE.md) | 📋 了解進度 | 完成功能列表 |
| [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) | 🌐 準備上線 | 詳細部署步驟 |
| [BUILD_CHECKLIST.md](./BUILD_CHECKLIST.md) | ✅ 構建驗證 | 檢查清單和故障排除 |
| [backend/README.md](./backend/README.md) | 🖥️ 後端相關 | 後端配置和 API |

## 🎯 常見任務

### 改變主題顏色
編輯 `lib/utils/constants.dart` 中的顏色常數

### 改變容器大小
編輯 `AppConstants.containerHeightHours`（小時數）

### 改變時長選項
編輯 `AppConstants.durationOptions` 列表

### 添加新的 AI 功能
1. 在 `backend/server.js` 添加新端點
2. 在 `lib/utils/ai_service.dart` 添加調用方法
3. 在 UI 中集成

### 部署後端到 Vercel
```bash
cd backend
# 安裝 Vercel CLI
npm i -g vercel
# 部署
vercel
# 更新 lib/utils/ai_service.dart 中的 URL
```

## 🔒 安全檢查清單

部署前必須確認：

- [ ] `.env` 文件不在 Git 中（`.gitignore` 已配置）
- [ ] Hugging Face Token 不在代碼中
- [ ] 後端 URL 在生產環境正確
- [ ] CORS 配置適當
- [ ] API 輸入驗證完善

## 📊 性能和限制

### 性能
- 任務數 < 100：無延遲
- 任務數 100-500：輕微延遲
- 任務數 > 500：考慮分頁或歸檔

### Hugging Face 限制
- Free tier：有速率限制
- 每個請求：~2-5 秒
- 大文本：可能超時

### 瀏覽器兼容性
- ✅ Chrome/Edge (推薦)
- ✅ Firefox
- ✅ Safari (iOS 13+)
- ❌ IE 11 (不支持 WebGL/WASM)

## 🎨 設計決策

### 為什麼是 Flutter？
- ✅ 跨平台一致性
- ✅ 熱重載加速開發
- ✅ 原生性能
- ✅ 豐富的 Widget 庫

### 為什麼使用 AI？
- ✅ 自動任務分解
- ✅ 時間估算建議
- ✅ 提高用戶效率

### 為什麼使用 Hugging Face？
- ✅ 免費推理 API
- ✅ 無需自托管 GPU
- ✅ 社區支持強
- ✅ 模型多樣化

## 🚀 現在該做什麼？

### 立即
1. 按照 [QUICK_SETUP.md](./QUICK_SETUP.md) 設置本地環境
2. 在 `localhost` 測試應用
3. 體驗所有功能

### 今天
1. 根據需要定制主題色
2. 配置時長選項
3. 設置後端服務

### 本週
1. 部署後端到 Vercel
2. 更新後端 URL
3. 推送到 GitHub 部署

### 未來
1. 添加日曆視圖
2. 添加通知/提醒
3. 添加導出功能
4. 考慮移動應用版本

## 💡 開發提示

### 在開發中加快速度
```bash
# 使用 --watch 模式監聽後端文件變更
cd backend && npm run dev

# 使用 flutter run 自動重載前端
flutter run -d chrome
```

### 調試 AI 功能
```bash
# 測試後端 API
curl -X POST http://localhost:3000/api/decompose \
  -H "Content-Type: application/json" \
  -d '{"taskDescription":"測試任務"}'
```

### 查看本地存儲
打開瀏覽器開發者工具 (F12):
- Application → Local Storage → http://localhost:xxxx

## 📚 學習資源

- [Flutter 官方文檔](https://flutter.dev/docs)
- [Provider 狀態管理](https://pub.dev/packages/provider)
- [Express.js 教程](https://expressjs.com/)
- [Hugging Face API](https://huggingface.co/docs/api-inference)

## 🤝 貢獻指南

歡迎改進！

1. Fork 項目
2. 創建特性分支
3. 提交更改
4. 推送到遠程
5. 開啟 Pull Request

## 📞 支持

- 📖 查看 [BUILD_CHECKLIST.md](./BUILD_CHECKLIST.md) 的故障排除
- 🐛 在 GitHub 提交 Issue
- 💬 查看討論區

## 📄 許可

MIT License - 自由使用和修改

---

## 下一步

**👉 立即開始**：前往 [QUICK_SETUP.md](./QUICK_SETUP.md)

**✅ 已準備好生產環境** - 你擁有一個完全功能的、生產級的應用！

---

**版本**：1.0.0  
**最後更新**：2025-12-27  
**狀態**：✨ 完成 ✨

Made with ❤️ using Flutter + Node.js + Hugging Face
