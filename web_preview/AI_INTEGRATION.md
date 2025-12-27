# Hugging Face 前端整合指南

## 概述

前端通過調用後端 API 來訪問 Hugging Face 模型。

## 文件結構

```
web_preview/
├── index.html           # 主應用程式
├── ai-integration.js    # AI 整合模組（提供 API 調用函數）
└── examples/
    └── ai-usage.html    # 整合示例頁面
```

## 快速整合

### 1. 引入 AI 整合模組

在 HTML 中加入：

```html
<script src="ai-integration.js"></script>
```

### 2. 調用 API

```javascript
// 方式 1：直接調用
const result = await window.AIIntegration.callDecomposeAPI('準備跨年派對');

if (result.status === 'success') {
  console.log('任務拆解結果:');
  console.log(result.data.output);
} else {
  console.error('錯誤:', result.error);
}
```

### 3. 解析結果

```javascript
// 將 AI 輸出轉換為任務物件陣列
const tasks = window.AIIntegration.parseAIOutput(result.data.output);

// 例如：
// tasks = [
//   { name: "聯繫朋友並發送邀請", duration: 0.5 },
//   { name: "購買派對用品和食物", duration: 2 },
//   ...
// ]
```

### 4. 創建任務（完整流程）

```javascript
// 一鍵分解並創建所有子任務
await window.AIIntegration.decomposeAndCreateTasks(
  '準備跨年派對',
  async (taskInfo) => {
    // taskInfo 包含：{ name, duration, startTime }
    // 在這裡調用你的任務創建函數
    createTaskFromAI(taskInfo);
  }
);
```

## API 調用格式

### 後端 API 文檔

**端點：**
```
POST http://localhost:3000/api/decompose
```

**請求頭：**
```
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

## 使用示例

### 示例 1：簡單調用

```javascript
async function askAI() {
  const description = document.getElementById('taskInput').value;
  const result = await window.AIIntegration.callDecomposeAPI(description);
  
  if (result.status === 'success') {
    document.getElementById('output').textContent = result.data.output;
  } else {
    alert('錯誤: ' + result.error);
  }
}
```

### 示例 2：集成到任務管理器

```javascript
async function createTasksFromAI() {
  const taskDescription = '完成專案報告：收集資料、編寫報告、製作圖表、進行審查';
  
  await window.AIIntegration.decomposeAndCreateTasks(
    taskDescription,
    (taskInfo) => {
      // 創建任務
      const task = {
        id: Date.now(),
        name: taskInfo.name,
        duration: taskInfo.duration,
        startTime: taskInfo.startTime,
        memo: '由 AI 自動生成',
        done: false
      };
      
      // 添加到全局任務列表
      tasks.push(task);
      save();
      rsch(); // 重新渲染
    }
  );
}
```

## 錯誤處理

### 常見錯誤

| 錯誤 | 原因 | 解決方案 |
|------|------|----------|
| `網路錯誤: fetch failed` | 後端未啟動 | 運行 `npm start`（在 backend 目錄） |
| `HTTP 500` | API Token 無效 | 檢查 `.env` 中的 Token |
| `HTTP 400` | 缺少或無效的輸入 | 檢查 taskDescription 參數 |
| `無法提取任務` | AI 輸出格式不符 | 查看原始輸出並調整解析邏輯 |

### 調試技巧

```javascript
// 檢查後端健康狀態
const isHealthy = await window.AIIntegration.checkBackendHealth();
console.log('後端狀態:', isHealthy ? '正常' : '異常');

// 查看原始 AI 輸出
const result = await window.AIIntegration.callDecomposeAPI('測試');
console.log('原始輸出:', result.data.output);

// 查看 API 基礎 URL
console.log('API 地址:', window.AIIntegration.API_BASE_URL);
```

## 環境配置

### 開發環境

編輯 `ai-integration.js`：

```javascript
const API_BASE_URL = 'http://localhost:3000'; // 開發
```

### 生產環境

編輯 `ai-integration.js`：

```javascript
const API_BASE_URL = 'https://your-production-api.com'; // 生產
```

## 安全性考慮

✅ **已實現：**
- API Token 存放在後端環境變數中
- 前端不存放或傳送 Token
- CORS 已啟用

⚠️ **建議：**
- 限制 CORS 來源（生產環境）
- 添加速率限制
- 驗證和監控 API 使用

## 性能優化

### 1. 緩存結果

```javascript
const cache = new Map();

async function getDecomposedTasks(description) {
  if (cache.has(description)) {
    return cache.get(description);
  }
  
  const result = await window.AIIntegration.callDecomposeAPI(description);
  cache.set(description, result);
  return result;
}
```

### 2. 加載狀態

```javascript
async function decomposeWithLoading(description) {
  const btn = document.getElementById('decomposeBtn');
  btn.disabled = true;
  btn.textContent = '分析中...';
  
  try {
    const result = await window.AIIntegration.callDecomposeAPI(description);
    // 處理結果
  } finally {
    btn.disabled = false;
    btn.textContent = '分析任務';
  }
}
```

## 後續改進

- [ ] 添加任務優先度設定
- [ ] 支援多語言提示詞
- [ ] 實現任務修改建議
- [ ] 添加時間估算優化
- [ ] 支援批量任務分解
