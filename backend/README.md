# Tech Vibe Backend

後端 API 服務，負責與 Hugging Face Inference API 整合。

## 功能

- ✅ 接收前端的任務描述文字
- ✅ 呼叫 Hugging Face flan-t5-base 模型
- ✅ 進行任務拆解與時間估算
- ✅ 返回結構化的 JSON 回應

## 快速開始

### 1. 安裝依賴

```bash
npm install
```

### 2. 配置環境變數

複製 `.env.example` 並重命名為 `.env`：

```bash
cp .env.example .env
```

編輯 `.env` 並填入你的 Hugging Face API Token：

```
HUGGING_FACE_API_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxx
PORT=3000
```

如何獲取 Token：
1. 訪問 https://huggingface.co/settings/tokens
2. 點擊「New token」
3. 設定名稱和權限（選擇 `Read` 即可）
4. 複製 Token 到 `.env` 文件

### 3. 啟動伺服器

```bash
# 生產環境
npm start

# 開發環境（自動重新載入）
npm run dev
```

伺服器將在 `http://localhost:3000` 啟動

## API 端點

### 健康檢查

```bash
GET /health
```

**回應示例：**
```json
{
  "status": "ok",
  "message": "Tech Vibe Backend is running"
}
```

### 任務分解

```bash
POST /api/decompose
Content-Type: application/json
```

**請求體：**
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
    "output": "1. 聯繫朋友並發送邀請 - 預計時間：0.5小時\n2. 購買派對用品和食物 - 預計時間：2小時\n3. 準備飲料和小食 - 預計時間：1.5小時\n4. 佈置場地和裝飾 - 預計時間：2小時\n5. 最後檢查準備工作 - 預計時間：0.5小時"
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

## cURL 測試

```bash
curl -X POST http://localhost:3000/api/decompose \
  -H "Content-Type: application/json" \
  -d '{
    "taskDescription": "準備跨年派對"
  }'
```

## 前端整合

詳見 `../web_preview/index.html` 中的 `callDecomposeAPI()` 函數。

## 環境變數

| 變數名 | 說明 | 預設值 |
|--------|------|--------|
| `HUGGING_FACE_API_TOKEN` | Hugging Face API Token (必需) | - |
| `PORT` | 伺服器埠號 | 3000 |
| `NODE_ENV` | 環境 (development/production) | development |

## 架構說明

```
Flutter Web 前端
    ↓
    ├─ POST /api/decompose (JSON)
    ↓
Node.js 後端
    ├─ 驗證輸入
    ├─ 構建提示詞
    ↓
Hugging Face API
    ├─ 模型: flan-t5-base
    ├─ 處理文字生成
    ↓
後端解析回應
    ├─ 提取生成的文字
    ↓
回傳結構化 JSON 給前端
```

## 常見問題

**Q: Token 不正確會如何？**
A: 會收到 401 或 403 錯誤。請確認 Token 正確且未過期。

**Q: 模型速度慢怎麼辦？**
A: flan-t5-base 首次呼叫可能較慢（模型載入），之後會更快。可考慮使用更快的模型。

**Q: 能改成其他模型嗎？**
A: 可以，編輯 `server.js` 中的 `HF_API_URL` 即可。

## 安全性說明

- ✅ API Token 放在後端環境變數中，不暴露給前端
- ✅ 前端直接呼叫後端 API，無需存放 Token
- ✅ 啟用 CORS，可根據需要限制來源
