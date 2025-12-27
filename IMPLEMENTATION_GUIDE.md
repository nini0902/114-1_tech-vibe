# Tech Vibe - Flutter Web 實作完整指南

## 已實現的功能

### ✅ 核心功能
- **月曆與日程規劃**：左側月曆，右側展示選中日期的任務
- **任務管理**：新增、編輯、刪除任務
- **時間視覺化**：以 0.5 小時為單位的時間塊展示
- **拖曳功能**：
  - 拖曳任務進出時間表
  - 拖曳下邊緣調整任務時長（以 0.5 小時為單位）
  - 支援往返拖曳（池 ↔ 容器）

### ✅ 任務編輯
- **編輯對話框**：點擊任務跳出編輯框
  - 修改任務名稱
  - 修改時長
  - 新增或編輯備註（memo）
  - 保存和取消功能

### ✅ 任務完成
- **Checklist 功能**：點擊任務旁的複選框標記完成
- **慶祝視窗**：完成任務後跳出恭喜動畫

### ✅ 倒數計時
- **重大事件倒數**：左上角倒數卡片
  - 顯示事件名稱和剩餘時間
  - 右上角 X 按鈕快速刪除
  - 新增倒數的對話框

### ✅ 深色主題
- **沉穩配色**：紫色、藍色、青綠色搭配深灰背景
- **一致性設計**：所有元素使用統一色系

### ✅ AI 任務分解（需要後端）
- **AI 助手按鈕**：任務建立區右上角 ✨ 按鈕
- **任務分解對話框**：
  - 輸入任務描述
  - AI 分析並回傳拆解建議
  - 顯示子任務和時間估算

## 架構總覽

### 前端（Flutter Web）
```
lib/
├── main.dart                    # 應用入口，深色主題設定
├── models/
│   ├── task_model.dart         # 任務模型（新增：memo, isCompleted）
│   ├── countdown_model.dart    # 倒數計時模型（新增）
│   └── app_state.dart          # 應用全局狀態（新增：countdowns）
├── providers/
│   └── task_provider.dart      # 狀態管理（新增：編輯、完成、倒數方法）
├── screens/
│   └── home_screen.dart        # 主畫面（新增：倒數區塊）
├── widgets/
│   ├── task_creation.dart      # 任務建立（新增：備註欄、AI 按鈕）
│   ├── task_block.dart         # 任務區塊（完全重寫：拖曳調整、編輯、完成）
│   ├── task_pool.dart          # 任務池（更新深色主題）
│   ├── day_container.dart      # 日容器（更新深色主題）
│   ├── reference_lines.dart    # 參考線（更新深色主題）
│   ├── task_edit_dialog.dart   # 編輯對話框（新增）
│   ├── countdowns_section.dart # 倒數區塊（新增）
│   └── task_decompose_dialog.dart # AI 分解對話框（新增）
└── utils/
    ├── constants.dart          # 常數與深色色系
    ├── storage.dart            # 本地存儲
    └── ai_service.dart         # AI API 呼叫服務（新增）
```

### 後端（Node.js）
```
backend/
├── server.js              # Express 伺服器，Hugging Face API 整合
├── package.json           # 依賴管理
├── .env.example           # 環境變數範本
└── README.md              # 後端文檔
```

## 使用流程

### 1. 設置後端（需要 Hugging Face API）

```bash
cd backend

# 複製環境配置
cp .env.example .env

# 編輯 .env，填入你的 Hugging Face API Token
# HUGGING_FACE_API_TOKEN=hf_xxxxx

# 安裝依賴
npm install

# 啟動伺服器（開發環境）
npm run dev
# 或生產環境
npm start
```

伺服器將在 `http://localhost:3000` 啟動。

### 2. 啟動 Flutter Web（需要 Flutter SDK）

```bash
# 獲取依賴
flutter pub get

# 啟動開發伺服器
flutter run -d chrome

# 或構建生產版本
flutter build web --release
```

## API 文檔

### 後端任務分解 API

**POST `/api/decompose`**

請求：
```json
{
  "taskDescription": "準備跨年派對，邀請朋友，佈置場地，準備食物和飲料"
}
```

回應：
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

## 關鍵實現細節

### 1. 深色主題實現
在 `main.dart` 中設定 `brightness: Brightness.dark` 並定義統一的顏色方案。所有 widgets 使用 `AppConstants` 中的顏色常數。

### 2. 拖曳時長調整
在 `task_block.dart` 中：
- 使用 `GestureDetector` 監聽下方邊緣的拖曳
- 計算拖曳距離並轉換為時長變化
- 以 0.5 小時為單位四捨五入
- 拖曳結束時呼叫 `provider.editTask()` 保存

### 3. 任務編輯流程
- 點擊任務區塊 → 顯示 `TaskEditDialog`
- 在對話框中編輯名稱、時長、備註
- 保存時調用 `provider.editTask()` 並顯示對話框

### 4. 完成狀態
- 在容器中的任務左側顯示複選框
- 點擊複選框 → `provider.markTaskComplete()`
- 標記完成後顯示慶祝對話框

### 5. 倒數計時
- 新增倒數卡片在左側上方
- 實時計算剩餘時間
- 支援快速刪除（右上角 X）

### 6. AI 任務分解
- 任務建立區右上角 ✨ 按鈕打開分解對話框
- 呼叫 `AIService.decomposeTask()`
- 後端接收請求 → 呼叫 Hugging Face API → 返回結果
- 前端展示 AI 分析結果供使用者參考

## 數據持久化

所有數據自動保存到瀏覽器本地存儲（`shared_preferences`）：
- 任務列表
- 任務狀態（池 vs 容器）
- 倒數計時
- 刷新頁面後數據自動恢復

## 部署

### 部署到 GitHub Pages
```bash
# 構建生產版本
flutter build web --release

# 推送到 gh-pages 分支
# (可自動通過 GitHub Actions 完成)
```

## 故障排排查

### 後端無法連接
- 確認後端伺服器已啟動：`http://localhost:3000/health`
- 檢查防火牆設定
- 在 `ai_service.dart` 中調整 `_backendUrl`

### Hugging Face API 錯誤
- 驗證 Token 正確性
- 確認 Token 未過期
- 檢查 Token 有讀權限
- 查看伺服器日誌了解詳細錯誤

### 任務不保存
- 檢查瀏覽器本地存儲是否已啟用
- 刷新頁面後檢查數據

## 未來擴展方向

1. **月曆視圖**：實現按日期選擇
2. **統計面板**：完成率、總時長等
3. **任務範本**：快速建立常見任務
4. **深色/亮色主題切換**
5. **多語言支持**
6. **移動端優化**
7. **更多 AI 模型支持**

## 最後檢查清單

- [ ] Flutter SDK 已安裝
- [ ] 後端依賴已安裝
- [ ] Hugging Face Token 已設定
- [ ] 後端伺服器已啟動
- [ ] `flutter run -d chrome` 可正常啟動
- [ ] 所有功能正常運作

## 聯繫與支持

有任何問題或建議，請提交 Issue 或 Pull Request。
