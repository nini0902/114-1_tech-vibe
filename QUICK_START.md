# Tech Vibe - 快速開始指南

## 🎯 五分鐘快速開始

### 1️⃣ 後端設置（需要 Hugging Face API）

```bash
# 進入後端目錄
cd backend

# 複製環境配置
cp .env.example .env

# 編輯 .env 文件，填入你的 Hugging Face API Token
nano .env
# 或用編輯器打開 .env，填入：
# HUGGING_FACE_API_TOKEN=hf_xxxxx（從 https://huggingface.co/settings/tokens 獲取）

# 安裝依賴
npm install

# 啟動後端伺服器
npm run dev
# 輸出應該看到：🚀 Tech Vibe Backend running on http://localhost:3000
```

### 2️⃣ 前端設置

在另一個終端窗口：

```bash
# 回到項目根目錄
cd ..

# 確保 Flutter SDK 已安裝
flutter --version

# 獲取 Dart 依賴
flutter pub get

# 啟動開發伺服器
flutter run -d chrome
# 應該會自動打開 Chrome 並加載應用
```

### 3️⃣ 開始使用！

應用現在應該在 `http://localhost:8080` 運行。

## 📋 使用說明

### 基本操作

1. **新增任務**
   - 在上方的「新增任務」區域輸入任務名稱
   - 選擇預估時長（0.5 ~ 4 小時）
   - 可選：輸入補充說明（memo）
   - 點擊「新增」按鈕

2. **拖曳任務到時間表**
   - 從左側「待放置的任務」區域
   - 拖曳任務到右側「今日規劃」容器
   - 任務會根據時長自動調整高度

3. **調整任務時長**
   - 將滑鼠懸停在任務下方邊緣
   - 看到「⋮」把手時，拖曳上下即可調整時長
   - 以 0.5 小時為單位自動四捨五入

4. **編輯任務詳情**
   - 點擊任務區塊打開編輯對話框
   - 修改名稱、時長、備註
   - 點擊「保存」確認

5. **標記任務完成**
   - 在時間表中的任務左側有複選框
   - 點擊複選框標記完成
   - 完成的任務會變成灰色並有刪除線
   - 會顯示恭喜動畫 🎉

6. **新增倒數計時**
   - 點擊左上方「重大倒數」區域的「+」按鈕
   - 輸入事件名稱
   - 選擇目標日期
   - 倒數會自動計算剩餘時間

7. **AI 任務分解**（需要後端運行）
   - 點擊「新增任務」區域右上方的 ✨ 按鈕
   - 輸入複雜任務描述
   - 點擊「分析」
   - AI 會給出分解建議

## 🎨 主題

- **深色主題**：沉穩的藍紫配色
- **任務顏色**：6 種不同顏色，基於任務 ID 自動分配

## 💾 數據保存

- 所有數據自動保存到瀏覽器本地存儲
- 刷新頁面後數據仍會保留
- 清除瀏覽器緩存會丟失數據

## 🔧 故障排除

### 應用無法連接到後端
```bash
# 檢查後端是否運行
curl http://localhost:3000/health
# 應該返回：{"status":"ok","message":"Tech Vibe Backend is running"}

# 如果無法連接，檢查：
# 1. 後端是否啟動（npm run dev）
# 2. 防火牆設置
# 3. 埠號是否正確（應該是 3000）
```

### AI 分解功能不工作
```bash
# 檢查 Hugging Face Token 是否正確
# 1. 驗證 backend/.env 中的 Token
# 2. 確認 Token 未過期（https://huggingface.co/settings/tokens）
# 3. Token 應該有 "read" 權限

# 查看後端日誌了解詳細錯誤信息
# npm run dev 的輸出會顯示 API 錯誤
```

### 任務不保存
```bash
# 檢查瀏覽器本地存儲是否已啟用
# 1. 在 Chrome DevTools 中檢查 Application → Local Storage
# 2. 確認沒有禁用 Local Storage
# 3. 檢查存儲空間是否已滿
```

## 📁 項目結構

```
tech-vibe/
├── lib/                        # Flutter 前端代碼
│   ├── models/                 # 數據模型
│   ├── providers/              # 狀態管理
│   ├── screens/                # 畫面
│   ├── widgets/                # UI 組件
│   ├── utils/                  # 工具函數
│   └── main.dart               # 應用入口
├── backend/                    # Node.js 後端
│   ├── server.js               # API 伺服器
│   ├── package.json            # 依賴配置
│   └── .env                    # 環境變數（需要創建）
├── pubspec.yaml                # Flutter 配置
├── SPEC.md                     # 原始需求規格
├── plan.md                     # 開發計畫
├── IMPLEMENTATION_GUIDE.md     # 詳細實裝指南
└── QUICK_START.md              # 此文件
```

## 📚 詳細文檔

- **SPEC.md** - 完整的功能規格書
- **plan.md** - 詳細的開發計畫和架構
- **IMPLEMENTATION_GUIDE.md** - 代碼實現細節
- **backend/README.md** - 後端 API 文檔

## 🚀 下一步

### 如果一切正常運行：
1. 嘗試新增一些任務
2. 拖曳任務到時間表
3. 調整任務時長
4. 使用 AI 分解複雜任務
5. 設置倒數計時
6. 標記任務完成

### 如果要深度了解：
1. 查看 `IMPLEMENTATION_GUIDE.md` 了解架構
2. 查看 `backend/README.md` 了解 API
3. 檢查源代碼中的註釋

## 💡 建議

1. **性能優化**（如果任務很多）
   - 虛擬化長列表
   - 減少重新渲染

2. **功能擴展**
   - 添加月曆視圖選擇日期
   - 添加任務分類/標籤
   - 添加統計面板

3. **部署**
   - 後端可部署到 Heroku、Railway 等
   - 前端可部署到 GitHub Pages
   - 生產環境需要 CORS 配置

## 🤝 需要幫助？

- 檢查此文件的「故障排除」部分
- 查閱 `IMPLEMENTATION_GUIDE.md`
- 查閱 `backend/README.md`

---

**祝你使用愉快！** 🎉

如有問題，歡迎提出 Issue 或提交改進建議。
