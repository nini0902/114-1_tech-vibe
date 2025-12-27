# Tech Vibe 構建檢查清單

本清單用於驗證項目在部署前的完整性和正確性。

## 代碼結構檢查

### Dart/Flutter 代碼

#### Models（✅ 完成）
- [x] `lib/models/task_model.dart` - 任務數據模型
- [x] `lib/models/countdown_model.dart` - 倒數計時模型
- [x] `lib/models/app_state.dart` - 全局應用狀態

#### Providers（✅ 完成）
- [x] `lib/providers/task_provider.dart` - 狀態管理

#### Screens（✅ 完成）
- [x] `lib/screens/home_screen.dart` - 主屏幕布局

#### Widgets（✅ 完成）
- [x] `lib/widgets/task_block.dart` - 可拖曳的任務區塊
- [x] `lib/widgets/task_pool.dart` - 待放置任務池
- [x] `lib/widgets/day_container.dart` - 一日容器（DragTarget）
- [x] `lib/widgets/task_creation.dart` - 任務建立表單
- [x] `lib/widgets/task_edit_dialog.dart` - 任務編輯對話框
- [x] `lib/widgets/task_decompose_dialog.dart` - AI 任務分解對話框
- [x] `lib/widgets/countdowns_section.dart` - 倒數計時區塊
- [x] `lib/widgets/reference_lines.dart` - 參考線

#### Utils（✅ 完成）
- [x] `lib/utils/constants.dart` - 常數、顏色、文字定義
- [x] `lib/utils/storage.dart` - SharedPreferences 存儲邏輯
- [x] `lib/utils/ai_service.dart` - 後端 API 服務調用

#### Main（✅ 完成）
- [x] `lib/main.dart` - 應用入口點

### 配置文件（✅ 完成）
- [x] `pubspec.yaml` - 依賴管理
- [x] `analysis_options.yaml` - Lint 配置
- [x] `web/index.html` - Web 入口 HTML
- [x] `web/manifest.json` - PWA 配置

## 功能檢查

### 核心功能（✅ 完成）
- [x] 任務建立與編輯
- [x] 任務拖曳到容器
- [x] 容器內拖曳排序
- [x] 任務標記完成
- [x] 任務刪除
- [x] 任務備註（memo）

### 倒數計時（✅ 完成）
- [x] 新增倒數事件
- [x] 顯示剩餘時間
- [x] 刪除倒數事件
- [x] 倒數計時計算

### AI 功能（✅ 完成）
- [x] AI 任務分解對話框
- [x] 後端 API 連接
- [x] Hugging Face 集成

### 數據持久化（✅ 完成）
- [x] SharedPreferences 存儲
- [x] 應用啟動時加載
- [x] 實時保存更改

### UI/UX（✅ 完成）
- [x] 深色主題設計
- [x] 響應式布局
- [x] 視覺反饋（拖曳、完成動畫）
- [x] 參考線顯示

## 後端檢查

### Node.js 服務（✅ 完成）
- [x] `backend/server.js` - Express 伺服器
- [x] `backend/package.json` - 依賴定義
- [x] `backend/.env.example` - 環境變數範本
- [x] `backend/.gitignore` - Git 忽略文件

### API 端點（✅ 完成）
- [x] `GET /health` - 健康檢查
- [x] `POST /api/decompose` - 任務分解

### 部署配置（✅ 完成）
- [x] `.github/workflows/deploy.yml` - GitHub Actions

## 構建前檢查清單

### 本地環境
```bash
# 1. 檢查 Flutter 環境
flutter doctor -v

# 2. 檢查代碼分析
flutter analyze

# 3. 依賴檢查
flutter pub get

# 4. (可選) 構建 Web
flutter build web --release
```

### 後端環境
```bash
# 1. 進入後端目錄
cd backend

# 2. 複製環境文件
cp .env.example .env

# 3. 設置 Hugging Face Token
# 編輯 .env 文件，填入實際的 API token

# 4. 安裝依賴
npm install

# 5. 測試後端
npm run dev
# 在另一個終端：
curl http://localhost:3000/health
```

## 部署檢查清單

### GitHub Pages（自動部署）
- [x] `.github/workflows/deploy.yml` 配置正確
- [x] Repository 啟用 GitHub Pages
- [x] 分支設置為 main/master

### 代碼檢查
- [x] 沒有硬編碼的本地路徑
- [x] API URLs 正確配置
- [x] 環境變數正確設置
- [x] 不含敏感信息

### 部署步驟
1. 確保所有代碼已提交
2. 推送到 GitHub：`git push origin main`
3. 查看 Actions 標籤監控部署進度
4. 部署完成後，訪問 GitHub Pages URL

## 已知限制和注意事項

### 前端限制
- ❌ 無法直接從 GitHub Pages 訪問本地開發後端（localhost:3000）
- ✅ 解決方案：部署後端到在線服務（Vercel、Heroku 等）
- ✅ 本地開發時，後端運行在 localhost:3000 即可

### 後端限制
- ⚠️ Hugging Face free tier 有速率限制（每分鐘若干請求）
- ✅ 建議：實現請求緩存或付費方案

### 瀏覽器兼容性
- ✅ Chrome/Edge（推薦）
- ✅ Firefox
- ✅ Safari
- ⚠️ 需要支持 WebGL/WASM

## 故障排除

### 無法編譯
```bash
# 清理構建文件
flutter clean
flutter pub get
flutter build web --release
```

### 後端無法連接
```bash
# 檢查後端是否運行
curl http://localhost:3000/health

# 檢查環境變數
cat backend/.env | grep HUGGING_FACE

# 檢查防火牆設置
```

### AI 功能無法工作
1. 驗證 Hugging Face API Token 是否有效
2. 檢查後端日誌（error 消息）
3. 在瀏覽器開發者工具查看 Network 標籤

## 完成確認

- [ ] 所有代碼文件已檢查
- [ ] 所有功能已測試
- [ ] 後端已驗證
- [ ] 部署配置已確認
- [ ] README 和文檔已更新
- [ ] 代碼已推送到 GitHub
- [ ] GitHub Actions 部署已成功
- [ ] 在線應用可訪問

---

**最後更新**：2025-12-27
**版本**：1.0.0
