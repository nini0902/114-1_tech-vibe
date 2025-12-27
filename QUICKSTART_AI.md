# Tech Vibe - AI 整合快速開始指南

## 📋 概述

Tech Vibe 已集成 **Hugging Face flan-t5-base** 模型，用於自動分解任務並估算時間。

### 架構

```
Flutter Web 前端
    ↓
Node.js 後端 (Express)
    ↓
Hugging Face Inference API
    ↓
flan-t5-base 模型
```

## 🚀 快速開始（5分鐘）

### 步驟 1: 獲取 Hugging Face API Token

1. 訪問 https://huggingface.co/settings/tokens
2. 登入你的 Hugging Face 帳號（沒有則註冊）
3. 點擊「New token」
4. 設定：
   - **Name**: 任意名稱（如 "tech-vibe"）
   - **Type**: 選擇 "Read"
   - **其他**: 保持預設
5. 複製生成的 Token

### 步驟 2: 配置後端

```bash
# 進入後端目錄
cd /workspaces/114-1_tech-vibe/backend

# 複製環境變數示例
cp .env.example .env

# 編輯 .env 文件
# 將 HUGGING_FACE_API_TOKEN=your_token_here 替換為你的真實 Token
```

### 步驟 3: 安裝依賴並啟動後端

```bash
# 安裝依賴（首次執行）
npm install

# 啟動後端服務
npm start
```

輸出示例：
```
🚀 Tech Vibe Backend running on http://localhost:3000
📝 Task decompose API: POST http://localhost:3000/api/decompose
🏥 Health check: GET http://localhost:3000/health
```

### 步驟 4: 測試 AI 功能

在瀏覽器中訪問：

```
file:///workspaces/114-1_tech-vibe/web_preview/ai-demo.html
```

或使用 cURL 測試：

```bash
curl -X POST http://localhost:3000/api/decompose \
  -H "Content-Type: application/json" \
  -d '{
    "taskDescription": "準備跨年派對"
  }'
```

## 📖 使用方式

### 方式 1: 使用演示頁面

訪問 `ai-demo.html`：
1. 輸入任務描述
2. 點擊「分析任務」
3. 查看 AI 分解結果
4. 根據需要創建任務

### 方式 2: 在主應用中整合

#### HTML 中引入

```html
<script src="ai-integration.js"></script>
```

#### 調用 API

```javascript
// 簡單調用
const result = await window.AIIntegration.callDecomposeAPI(
  '準備跨年派對'
);

if (result.status === 'success') {
  console.log(result.data.output);
} else {
  console.error(result.error);
}
```

#### 完整流程

```javascript
// 自動分解並創建任務
await window.AIIntegration.decomposeAndCreateTasks(
  '準備跨年派對，邀請朋友，佈置場地',
  (taskInfo) => {
    // taskInfo = { name, duration, startTime }
    // 在這裡創建任務
    console.log(`創建任務: ${taskInfo.name} (${taskInfo.duration}小時)`);
  }
);
```

## 🔧 API 文檔

### POST /api/decompose

**請求：**
```json
{
  "taskDescription": "準備跨年派對，邀請朋友，佈置場地，準備食物和飲料"
}
```

**成功回應 (200)：**
```json
{
  "status": "success",
  "data": {
    "input": "準備跨年派對，邀請朋友，佈置場地，準備食物和飲料",
    "output": "1. 聯繫朋友並發送邀請 - 預計時間：0.5小時\n2. 購買派對用品和食物 - 預計時間：2小時\n..."
  },
  "error": null
}
```

**錯誤回應 (400/500)：**
```json
{
  "status": "error",
  "data": null,
  "error": "詳細錯誤訊息"
}
```

### GET /health

**回應：**
```json
{
  "status": "ok",
  "message": "Tech Vibe Backend is running"
}
```

## 🎯 常見問題

### Q: 後端無法啟動？

**A:** 檢查以下幾點：

1. Node.js 已安裝
   ```bash
   node --version
   ```

2. 依賴已安裝
   ```bash
   npm install
   ```

3. 埠號 3000 未被占用
   ```bash
   # 或修改 .env 中的 PORT
   ```

### Q: 出現 401/403 錯誤？

**A:** API Token 無效

1. 確認 Token 正確複製
2. 檢查 Token 未過期（https://huggingface.co/settings/tokens）
3. 確認 `.env` 文件正確

### Q: 模型響應很慢？

**A:** 首次調用會比較慢（模型載入）。後續調用會更快。

可選：
- 使用更輕量的模型（編輯 `server.js` 中的 `HF_API_URL`）
- 實現結果緩存

### Q: 如何修改模型？

**A:** 編輯 `backend/server.js`：

```javascript
const HF_API_URL = 'https://api-inference.huggingface.co/models/google/flan-t5-large';
// 或其他模型，如 'distilgpt2', 'gpt2' 等
```

可用模型列表：https://huggingface.co/models

## 📁 文件結構

```
tech-vibe/
├── backend/
│   ├── server.js            # 後端主程式
│   ├── package.json         # npm 依賴
│   ├── .env.example         # 環境變數示例
│   └── README.md            # 後端文檔
├── web_preview/
│   ├── ai-integration.js    # 前端 AI 模組
│   ├── ai-demo.html         # AI 演示頁面
│   ├── AI_INTEGRATION.md    # 前端集成指南
│   └── index.html           # 主應用
└── QUICKSTART.md            # 本文檔
```

## 🔒 安全性檢查表

- ✅ API Token 存儲在 `.env`（後端環境變數）
- ✅ `.env` 已添加到 `.gitignore`（不提交到版本控制）
- ✅ 前端不存儲或傳送 Token
- ✅ CORS 已啟用（可在生產環境限制來源）
- ✅ 輸入已驗證

## 🚀 生產環境部署

### 環境變數

```bash
# .env（生產）
HUGGING_FACE_API_TOKEN=your_production_token
PORT=3000
NODE_ENV=production
```

### 前端 API 地址

編輯 `ai-integration.js`：

```javascript
// 開發環境
const API_BASE_URL = 'http://localhost:3000';

// 生產環境
const API_BASE_URL = 'https://your-api.com';
```

### 部署選項

1. **Heroku**
   ```bash
   heroku create
   heroku config:set HUGGING_FACE_API_TOKEN=your_token
   git push heroku main
   ```

2. **Vercel**
   ```bash
   vercel env add HUGGING_FACE_API_TOKEN
   vercel deploy
   ```

3. **自署伺服器**
   - 使用 PM2 或 systemd 保持進程運行
   - 使用 Nginx 反向代理
   - 啟用 HTTPS

## 📚 更多資源

- **後端詳細文檔**: `backend/README.md`
- **前端集成指南**: `web_preview/AI_INTEGRATION.md`
- **AI 演示頁面**: `web_preview/ai-demo.html`
- **Hugging Face 文檔**: https://huggingface.co/docs/api-inference
- **flan-t5 模型**: https://huggingface.co/google/flan-t5-base

## 💬 支援

如遇問題，請檢查：

1. 後端日誌（終端輸出）
2. 瀏覽器開發者工具（Network 標籤）
3. `.env` 文件配置
4. Hugging Face API 狀態

## ✨ 下一步

- [ ] 在主應用中集成 AI 功能
- [ ] 添加任務編輯建議
- [ ] 實現結果緩存
- [ ] 支援多語言
- [ ] 添加優先度分析

---

**祝你使用愉快！🎉**
