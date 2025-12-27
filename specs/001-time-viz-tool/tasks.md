---
description: "一日時間視覺化工具任務清單"
---

# 任務清單：一日時間視覺化工具

**分支**: `001-time-viz-tool` | **日期**: 2025-12-27  
**規格**: `specs/001-time-viz-tool/spec.md` | **計畫**: `specs/001-time-viz-tool/plan.md`  
**部署目錄**: `docs/time-viz-tool/`

---

## 任務格式說明

- **[P]**: 可並行執行（不同檔案、無依賴）
- **[USX]**: 屬於使用者故事 X（US1, US2, US3, US4）
- **[工時]**: 估計工作小時數

---

## Phase 1: 專案初始化

**目標**: 建立專案結構和基礎檔案

### Setup 任務

- [ ] T001 建立專案目錄結構，包含 docs/time-viz-tool/, css/, js/models/, js/components/, js/services/ 等目錄
- [ ] T002 [P] 建立 docs/time-viz-tool/index.html 基礎骨架，包含 DOCTYPE、meta 標籤、基本容器 ID
- [ ] T003 [P] 建立 docs/time-viz-tool/css/styles.css 全局樣式檔案
- [ ] T004 [P] 建立 docs/time-viz-tool/css/components.css 元件樣式檔案
- [ ] T005 [P] 建立 docs/time-viz-tool/css/layout.css 佈局樣式檔案
- [ ] T006 [P] 建立 docs/time-viz-tool/js/ 目錄下的各個 JS 模組檔案（空檔案）
- [ ] T007 初始化 README.md 說明（簡要功能介紹）

**檢查點**: 專案目錄結構完成，所有基礎檔案已建立

---

## Phase 2: 靜態頁面構建

**目標**: 實現基礎 UI 和頁面樣式，使頁面在瀏覽器中能正確顯示

**獨立測試**: 開啟瀏覽器訪問 docs/time-viz-tool/index.html，確認：
- 頁面正常加載，無錯誤
- 三個主要區域清晰可見（任務建立區、任務池、今日容器）
- 時間區塊視覺大小與時長成正比

### 任務建立區 UI

- [ ] T008 [P] 在 index.html 中實現任務名稱輸入欄位，包含 id="taskName"，placeholder 提示「輸入任務名稱」
- [ ] T009 [P] 在 index.html 中實現時長選擇器，包含選項（0.5hr, 1hr, 1.5hr, 2hr, 3hr, 4hr），id="taskDuration"
- [ ] T010 [P] 在 index.html 中實現「新增」按鈕，id="addTaskBtn"，並設定基礎樣式

### 任務池和今日容器 UI

- [ ] T011 [P] 在 index.html 中實現任務池容器，id="taskPool"，高度自適應
- [ ] T012 [P] 在 index.html 中實現今日容器，id="dayContainer"，固定高度 480px（代表 16 小時）
- [ ] T013 在今日容器中添加參考線，標示 8hr、16hr、24hr 的位置，並添加標籤說明

### CSS 樣式實現

- [ ] T014 [P] 在 styles.css 中實現全局樣式：字體、顏色方案、基礎佈局（Flexbox）、單位定義（BASE_UNIT = 30px）
- [ ] T015 [P] 在 components.css 中實現時間區塊樣式：
  - 區塊寬度、邊框、圓角、陰影
  - 區塊內文字顯示（任務名稱、時長）
  - 區塊大小與時長對應的高度公式（height = duration × 30px）
- [ ] T016 [P] 在 components.css 中實現容器樣式（任務池、今日容器）：邊框、背景色、內邊距
- [ ] T017 [P] 在 layout.css 中實現頁面佈局：
  - 主容器使用 Flexbox，分為左欄（任務池）和右欄（今日容器）
  - 任務建立區頂部固定
  - 響應式設計（桌面優先）
- [ ] T018 [P] 在 styles.css 中添加按鈕和輸入欄位的樣式（focus、hover 狀態）
- [ ] T019 實現參考線 CSS 樣式（虛線、標籤位置），確保清晰可見

**檢查點**: 靜態頁面完整，UI 佈局清晰，時間區塊尺寸計算邏輯正確

---

## Phase 3: 資料模型與儲存層

**目標**: 實現資料層，支援任務建立和持久化

**獨立測試**: 在瀏覽器控制台測試：
- 建立一個 Task 實例，驗證屬性正確（id、name、duration）
- 建立一個 TimeBlock 實例，驗證繼承自 Task
- 調用 Store 的 CRUD 方法，驗證資料正確儲存到 localStorage

### Task 和 TimeBlock 模型

- [ ] T020 [P] 在 docs/time-viz-tool/js/models/Task.js 中定義 Task 類：
  - 屬性：id（UUID）、name（字串）、duration（數值，小時）、createdAt（時間戳）
  - 方法：驗證方法（名稱非空、時長有效 0.5-8 小時）
  - 解構方法（用於序列化）
- [ ] T021 [P] 在 docs/time-viz-tool/js/models/TimeBlock.js 中定義 TimeBlock 類：
  - 繼承 Task，新增屬性 position（"pool" 或 "container"）、status（"draft" 或 "scheduled"）
  - 方法：計算視覺高度（height = duration × BASE_UNIT）

### Store 和持久化

- [ ] T022 在 docs/time-viz-tool/js/models/Store.js 中實現 Store 類（localStorage 管理層）：
  - 方法：initStore()、addTask()、removeTask()、updateTask()、getAllTasks()、clearAll()
  - 序列化邏輯：JSON.stringify/parse，保存版本號（version: 1）
  - 異常處理：容量限制檢查，localStorage 不可用時的降級方案
  - 資料驗證：加載時檢查資料完整性，自動修復或清空
- [ ] T023 在 Store.js 中實現初始化邏輯：
  - 首次訪問時初始化空 tasks 陣列
  - 後續訪問時從 localStorage 恢復資料
  - 驗證恢復後的資料合法性

### 應用初始化

- [ ] T024 在 docs/time-viz-tool/js/main.js 中實現應用初始化：
  - 在 DOMContentLoaded 事件中調用 Store.initStore()
  - 恢復頁面加載時的任務池和今日容器狀態
  - 初始化全局變數（appState）保存應用狀態

**檢查點**: 資料層完整，資料持久化正常，localStorage 能正確儲存和恢復資料

---

## Phase 4: 使用者故事 1 - 建立並視覺化時間區塊 (Priority: P1) 🎯 MVP

**目標**: 使用者能輸入任務名稱和時長，系統立即產生對應的時間區塊

**獨立測試**: 
- 輸入任務名稱「寫報告」、選擇「2 小時」、點擊「新增」
- 驗證任務池中出現一個標示「寫報告 / 2hr」的區塊
- 驗證區塊高度為 1 小時區塊的 2 倍
- 建立 3-5 個不同時長的任務，驗證大小差異明顯

### Task 輸入驗證和事件處理

- [ ] T025 [P] [US1] 在 docs/time-viz-tool/js/components/TaskInput.js 中實現 TaskInput 元件：
  - 監聽 addTaskBtn 點擊事件
  - 驗證輸入：檢查名稱非空、時長已選
  - 驗證失敗時顯示友善提示（alert 或 toast，2.0 版本優化）
- [ ] T026 [P] [US1] 在 TaskInput.js 中實現輸入清空邏輯：
  - 成功新增後清空 taskName 輸入欄和 taskDuration 選擇

### 任務建立和儲存

- [ ] T027 [US1] 在 docs/time-viz-tool/js/services/TaskService.js 中實現 createTask() 方法：
  - 接收 name 和 duration，建立 Task 實例
  - 調用 Store.addTask() 儲存到 localStorage
  - 返回新建立的 Task 物件
- [ ] T028 [US1] 在 TaskService.js 中實現 createTimeBlock() 方法：
  - 根據 Task 建立 TimeBlock，設定 position = "pool"、status = "draft"
  - 計算視覺高度和其他 UI 屬性

### 任務池渲染

- [ ] T029 [US1] 在 docs/time-viz-tool/js/components/TaskPool.js 中實現 TaskPool 元件：
  - 初始化時從 Store 載入所有 position="pool" 的任務
  - 方法：renderTasks()、addTaskBlock()、removeTaskBlock()
- [ ] T030 [US1] 在 TaskPool.js 中實現區塊 DOM 生成邏輯：
  - 為每個任務建立 div.time-block 元素
  - 設定 id="task-{taskId}"、data-task-id="{taskId}"
  - 內容：任務名稱 + 時長（例「寫報告 / 2hr」）
  - 高度：元素設定 style.height = `${duration * 30}px`
- [ ] T031 [P] [US1] 在 TaskPool.js 中實現區塊交互元素（刪除按鈕預留）

### UI 更新服務

- [ ] T032 [US1] 在 docs/time-viz-tool/js/services/UI.js 中實現 updateTaskPool() 方法：
  - 接收 Task 陣列，重新渲染任務池
  - 清空舊的 DOM，生成新的區塊元素
- [ ] T033 [US1] 在 main.js 中連接任務輸入流程：
  - 監聽「新增」按鈕事件
  - 調用 TaskService.createTask()
  - 調用 UI.updateTaskPool() 更新顯示

**檢查點**: 使用者故事 1 完整，可建立任務並在任務池中視覺化

---

## Phase 5: 使用者故事 2 - 拖曳區塊進行規劃 (Priority: P1)

**目標**: 使用者能將任務池中的區塊拖曳到今日容器，區塊自動堆疊

**獨立測試**:
- 建立 3 個任務（2hr、1hr、1.5hr）
- 將其全部拖入今日容器
- 驗證區塊依序從底部向上堆疊
- 驗證視覺上能立即判斷總時長

### HTML5 Drag & Drop API 實現

- [ ] T034 [P] [US2] 在 index.html 中為任務池的區塊添加 draggable="true" 屬性
- [ ] T035 [P] [US2] 在 index.html 中為今日容器添加拖放區域標記（data-droppable="true"）

### 拖曳服務

- [ ] T036 [US2] 在 docs/time-viz-tool/js/services/DragDrop.js 中實現拖曳邏輯：
  - dragstart 事件：記錄被拖動的區塊 ID、時長、來源（pool）
  - dragover 事件：允許放置（preventDefault）
  - drop 事件：接收區塊，更新 position 為 "container"，觸發 updateDayContainer()
  - dragend 事件：清理狀態
- [ ] T037 [US2] 在 DragDrop.js 中實現區塊堆疊計算：
  - 根據已有區塊高度計算新區塊的 top 位置
  - 公式：newTop = 所有已有區塊高度之和
  - 無重疊、無空隙
- [ ] T038 [US2] 在 DragDrop.js 中實現容器溢出邏輯：
  - 檢查堆疊總高度是否超過 480px
  - 若超過，區塊視覺上溢出容器，但不被阻擋
  - 設定 CSS overflow: visible 或類似

### 今日容器渲染

- [ ] T039 [US2] 在 docs/time-viz-tool/js/components/DayContainer.js 中實現 DayContainer 元件：
  - 初始化時從 Store 載入所有 position="container" 的任務
  - 方法：renderBlocks()、addBlock()、removeBlock()
- [ ] T040 [US2] 在 DayContainer.js 中實現區塊堆疊渲染：
  - 依序排列區塊，從 bottom 向上
  - 每個區塊設定絕對或相對位置，高度對應時長
  - 計算並更新堆疊高度顯示（總時長 / 容器容量指示器）
- [ ] T041 [P] [US2] 在 DayContainer.js 中實現參考線渲染（如果還未實現）

### 狀態同步

- [ ] T042 [US2] 在 main.js 中實現拖放事件的全局監聽：
  - 監聽今日容器的 drop 事件
  - 更新 Task 的 position 屬性為 "container"
  - 調用 Store.updateTask() 持久化
  - 調用 UI.updateAll() 刷新顯示
- [ ] T043 [US2] 在 UI.js 中實現 updateDayContainer() 方法：
  - 重新渲染今日容器的所有區塊
  - 重新計算堆疊位置和高度

**檢查點**: 使用者故事 2 完整，拖曳功能流暢、區塊堆疊正確

---

## Phase 6: 使用者故事 3 - 調整與移除任務 (Priority: P2)

**目標**: 使用者能從今日容器移除區塊，也能刪除任務

**獨立測試**:
- 建立 5 個任務，全部拖入今日容器
- 拖曳其中 2 個回到任務池
- 刪除任務池中的 1 個任務
- 驗證容器和任務池自動重新排列

### 反向拖曳（從容器回到池）

- [ ] T044 [P] [US3] 在 index.html 中為今日容器的區塊添加 draggable="true"
- [ ] T045 [P] [US3] 在 index.html 中為任務池添加拖放區域標記（data-droppable="true"）
- [ ] T046 [US3] 在 DragDrop.js 中實現反向拖曳邏輯：
  - dragstart：記錄拖動區塊的 ID、來源位置（container）
  - drop 到任務池：更新 position 為 "pool"
  - 觸發 updateTaskPool() 和 updateDayContainer()
- [ ] T047 [US3] 在 DayContainer.js 中實現區塊移除後的重新排列：
  - 移除區塊後，重新計算剩餘區塊的堆疊位置
  - 自動填充空隙，無須使用者操作

### 刪除功能

- [ ] T048 [P] [US3] 在 components.css 中設計刪除按鈕樣式（小型、明顯、hover 高亮）
- [ ] T049 [US3] 在 TaskPool.js 和 DayContainer.js 中為每個區塊添加刪除按鈕：
  - 按鈕文字：「×」或「刪除」
  - id="delete-{taskId}"、class="delete-btn"
  - 點擊事件：調用 deleteTask()
- [ ] T050 [US3] 在 TaskService.js 中實現 deleteTask() 方法：
  - 從 Store 中移除任務
  - 更新 appState
  - 觸發 UI 更新
- [ ] T051 [US3] 在 main.js 中為刪除按鈕綁定事件監聽（事件代理或逐個綁定）

### UI 同步更新

- [ ] T052 [US3] 在 UI.js 中實現 updateAll() 方法：
  - 同時刷新任務池和今日容器
  - 確保所有區塊位置和狀態一致
- [ ] T053 [US3] 在 DragDrop.js 中更新 drop 事件處理，適配新的狀態轉換

**檢查點**: 使用者故事 3 完整，任務移除和刪除流程順暢

---

## Phase 7: 使用者故事 4 - 資料持久化 (Priority: P2)

**目標**: 使用者關閉瀏覽器後重新開啟工具，資料自動恢復

**獨立測試**:
- 建立 3 個任務，拖入今日容器
- 關閉瀏覽器分頁
- 重新開啟工具
- 驗證所有任務和位置完整恢復

### 數據自動恢復

- [ ] T054 [US4] 在 main.js 中完善初始化邏輯（DOMContentLoaded）：
  - 調用 Store.initStore() 載入資料
  - 如果有已儲存的任務，恢復任務池和今日容器的狀態
  - 如果是首次訪問（無資料），顯示空狀態
- [ ] T055 [US4] 在 Store.js 中完善資料恢復邏輯：
  - 驗證 localStorage 中的資料格式和版本
  - 如果版本不符，執行遷移邏輯（目前版本 1，無需遷移）
  - 如果資料損壞，記錄到控制台並清空

### 頁面加載後的視覺恢復

- [ ] T056 [US4] 在 main.js 中確保頁面加載時正確渲染：
  - 依次載入任務、任務池、今日容器
  - 保證 DOM 已準備好再執行 JavaScript
- [ ] T057 [US4] 在 DayContainer.js 中確保容器中的區塊正確定位：
  - 根據儲存的位置數據，重新計算堆疊高度和位置
  - 確保視覺呈現與儲存數據一致

### 清空資料選項（可選，但推薦）

- [ ] T058 [P] [US4] 在 index.html 中添加「清空所有資料」按鈕（底部隱藏或高級選項）
- [ ] T059 [US4] 在 main.js 中為按鈕綁定事件，調用 Store.clearAll()，確認後清空

**檢查點**: 使用者故事 4 完整，資料持久化正常，跨會話恢復完整

---

## Phase 8: 邊界處理與容錯

**目標**: 處理異常情況，確保產品穩定性和友善的使用體驗

**獨立測試**: 測試各邊界情況，確認無崩潰和合理提示

### 輸入驗證增強

- [ ] T060 [P] 在 TaskInput.js 中實現空白名稱提示：
  - 如果輸入為空，提示「請輸入任務名稱」
  - 推薦：顯示 toast 或輸入欄紅邊效果
- [ ] T061 [P] 在 Task.js 中實現超長名稱截斷邏輯：
  - 名稱超過 50 字元時，截斷為「前 47 字...」
  - 保留原始完整名稱在 data 屬性中（用於 hover 時提示）
- [ ] T062 [P] 在 components.css 中實現截斷文字的 title 屬性（HTML）或 tooltip CSS

### 極端時長處理

- [ ] T063 在 TaskInput.js 中驗證時長選擇（防止手動修改 HTML）：
  - 只允許預設的 6 種時長
  - 驗證不通過時，重置為預設值
- [ ] T064 在 DayContainer.js 中驗證溢出情況：
  - 確保容器 CSS 設定 overflow: visible 或 auto
  - 區塊超出容器時視覺上溢出，無遮擋

### 快速連續操作

- [ ] T065 在 DragDrop.js 中實現操作節流：
  - 拖曳進行中禁用其他操作（可選，如無性能問題則可跳過）
  - 或使用 debounce 處理 drop 事件多次觸發
- [ ] T066 在 TaskInput.js 中禁用「新增」按鈕的連續點擊：
  - 點擊後臨時禁用 0.5 秒，防止重複提交
  - 或在 TaskService 層檢查是否已有相同名稱的未完成任務

### 儲存空間限制提示

- [ ] T067 在 Store.js 中實現容量檢查：
  - 嘗試儲存前估算大小
  - 如果接近限制（>4MB），提示使用者清理舊任務
  - 如果超出限制，提示無法儲存並建議刪除
- [ ] T068 在 main.js 中捕獲 QuotaExceededError，顯示友善提示

### 瀏覽器相容性（檢查清單）

- [ ] T069 測試 Chrome（最新版）：驗證功能正常
- [ ] T070 測試 Firefox（最新版）：驗證功能正常
- [ ] T071 測試 Safari（macOS 最新版）：驗證功能正常
- [ ] T072 測試 Edge（最新版）：驗證功能正常

**檢查點**: 邊界情況處理完整，產品穩定性達到 MVP 標準

---

## Phase 9: 效能優化

**目標**: 確保拖曳流暢、頁面加載快速

**獨立測試**: 使用 DevTools 測試性能指標

### 拖曳效能優化

- [ ] T073 [P] 在 DragDrop.js 中使用 CSS transform 動畫替代 top/left 變更：
  - 拖曳時使用 requestAnimationFrame() 更新位置
  - 優先使用 transform 而非 left/top（減少重排）
- [ ] T074 [P] 在 components.css 中為拖曳狀態添加 will-change 屬性
- [ ] T075 在 DayContainer.js 中批量 DOM 操作：
  - 使用 DocumentFragment 或批量更新，減少重排次數

### 事件代理優化

- [ ] T076 在 main.js 中實現事件代理：
  - 使用單一的 click 監聽器處理所有刪除按鈕，而非逐個綁定
  - 在 event.target 上檢查是否為刪除按鈕
- [ ] T077 [P] 在 DragDrop.js 中使用事件代理處理拖曳事件（如適用）

### 頁面加載優化

- [ ] T078 [P] 在 index.html 中將 JavaScript 引入移至 body 底部
- [ ] T079 [P] 在 index.html 中添加 async 或 defer 屬性到 script 標籤（如適用）
- [ ] T080 [P] 在 Store.js 中延遲初始化非必需的全局對象

### CSS 優化

- [ ] T081 [P] 在 styles.css 中移除未使用的選擇器
- [ ] T082 [P] 在 components.css 中合併相同的樣式規則
- [ ] T083 [P] 檢查 CSS 中是否有觸發重排的屬性（height、width 在動畫中）

**檢查點**: 拖曳反應時間 < 100ms，頁面加載時間 < 2s

---

## Phase 10: 無障礙基礎支援（可選增強）

**目標**: 提升對鍵盤和螢幕閱讀器的基礎支援

- [ ] T084 [P] 在 index.html 中為所有交互元素添加 aria-label 或合理的文字標籤
- [ ] T085 [P] 在 index.html 中確保輸入欄和按鈕有合理的 tabindex 順序
- [ ] T086 在 TaskInput.js 中支援 Enter 鍵提交（在輸入欄按 Enter 即新增）
- [ ] T087 [P] 在 components.css 中添加 focus-visible 樣式，增強鍵盤導航可見性

**檢查點**: 使用 Tab 鍵能導航至所有功能，無需滑鼠操作

---

## Phase 11: 文檔與部署

**目標**: 準備用戶文檔和 GitHub Pages 部署

### 文檔撰寫

- [ ] T088 完善 docs/time-viz-tool/README.md，包含：
  - 功能簡介（一句話簡述）
  - 使用指南（分 3 步說明基本操作）
  - 已知限制（託管環境限制、儲存空間等）
  - 功能清單（檢查表格式列出 FR-001 至 FR-018）
- [ ] T089 [P] 在 docs/time-viz-tool/ 中創建 DEVELOPMENT.md，說明：
  - 本地開發環境（無需特殊依賴，直接開啟 index.html）
  - 專案結構簡介
  - 如何修改和擴展
- [ ] T090 [P] 在 specs/001-time-viz-tool/ 中創建 QUICKSTART.md，記錄測試場景

### GitHub Pages 部署

- [ ] T091 驗證 GitHub Pages 源目錄設定為 `docs/`（在 repo Settings）
- [ ] T092 [P] 驗證 docs/time-viz-tool/ 中的所有靜態資源路徑正確
  - CSS 和 JS 文件路徑相對或絕對（GitHub Pages 兼容）
  - 資源加載順序正確
- [ ] T093 本地測試部署版本：
  - 使用 python3 -m http.server 或類似工具在 docs/ 目錄啟動本地伺服器
  - 訪問 http://localhost:8000/time-viz-tool/
  - 驗證功能完整
- [ ] T094 [P] 驗證 GitHub Pages URL（https://[username].github.io/114-1_tech-vibe/time-viz-tool/）可正常訪問

### 最終整合測試

- [ ] T095 執行完整的端到端測試：
  - 建立 5 個任務（多種時長）
  - 拖曳 3 個到今日容器
  - 刪除 1 個
  - 重新加載頁面，驗證資料恢復
  - 在各瀏覽器驗證（Chrome、Firefox、Safari、Edge）
- [ ] T096 [P] 檢查瀏覽器控制台是否有錯誤或警告
- [ ] T097 [P] 檢查性能指標（DevTools > Performance）

**檢查點**: 工具在 GitHub Pages 正常訪問和使用，文檔完整清晰

---

## Phase 12: 版本控制與交付

**目標**: 整理代碼、提交到 git，準備交付

- [ ] T098 檢查所有 JavaScript 代碼是否遵循命名規範（camelCase）
- [ ] T099 [P] 移除所有 console.log() 調試語句（或保留必要的錯誤日誌）
- [ ] T100 [P] 檢查代碼註釋是否清晰簡潔（只註釋複雜邏輯，避免過度註釋）
- [ ] T101 git add . && git commit -m "feat: complete 001-time-viz-tool MVP"
- [ ] T102 驗證 git 提交成功，無遺漏檔案

**檢查點**: 代碼整潔，git 歷史清晰，MVP 準備交付

---

## 依賴關係與執行順序

### 各階段依賴

```
Phase 1 (Setup)
    ↓
Phase 2 (靜態頁面)
    ↓
Phase 3 (資料層) ← 依賴 Phase 2 HTML 結構
    ↓
Phase 4 (US1: 建立任務) ← 依賴 Phase 3 Store
    ↓
Phase 5 (US2: 拖曳) ← 依賴 Phase 4 任務建立
    ↓
Phase 6 (US3: 調整移除) ← 依賴 Phase 4、5
    ↓
Phase 7 (US4: 資料持久化) ← 依賴 Phase 3、4、5、6
    ↓
Phase 8 (邊界處理) ← 依賴所有 US
    ↓
Phase 9 (效能優化)
    ↓
Phase 10 (無障礙，可選)
    ↓
Phase 11 (文檔與部署)
    ↓
Phase 12 (版本控制)
```

### 使用者故事依賴

- **US1 (建立任務)**: 無依賴（Phase 4 開始）
  - 完全獨立，不需要 US2、US3、US4
- **US2 (拖曳)**: 依賴 US1 的任務存在
  - 但可在 US1 「建立」功能完成後立即開始
- **US3 (調整移除)**: 依賴 US2（需要區塊在容器中）
  - 反向拖曳、刪除等
- **US4 (持久化)**: 理論上獨立（Phase 7 可並行）
  - 但實際測試需要 US1-3 都完成

### 並行機會

- **Phase 1**: 所有文件建立可並行（T001-T007）
- **Phase 2**: CSS 檔案和 HTML 結構可部分並行（T008-T010 可並行、T011-T019 大多可並行）
- **Phase 3**: Task/TimeBlock/Store 模型可並行定義（T020-T021 可並行）
- **Phase 4**: TaskInput、TaskPool、TaskService 可部分並行（但 TaskService 完成後才能連接）
- **Phase 5**: DragDrop、DayContainer 可部分並行
- **Phase 8**: 各邊界處理任務大多可並行
- **Phase 9**: 效能優化任務可並行
- **Phase 11**: 不同文檔撰寫可並行

---

## 並行執行示例

### 快速啟動（單人順序實作，預期 12-18 天）

1. 完成 Phase 1（1 天）
2. 完成 Phase 2（2-3 天）
3. 完成 Phase 3（2-3 天）
4. 完成 Phase 4（2 天）→ **MVP 可驗證**
5. 完成 Phase 5（3-4 天）→ **核心功能完整**
6. 完成 Phase 6、7（2-3 天）→ **功能完整**
7. 完成 Phase 8-12（2-3 天）→ **生產就緒**

### 團隊並行方案（假設 2 人，預期 8-10 天）

- **人員 A**: Phase 1、2、4 → US1 完成
- **人員 B**: Phase 3 同步進行 → Store 完成 → 支援 Phase 4
- **並行**: Phase 5（A）+ Phase 8（B）
- **接續**: Phase 6、7、9、10、11、12（可分工或順序）

---

## 實作策略

### MVP 驗證點（建議在此停留並驗證）

完成 **Phase 4 後**:
- ✅ 使用者能建立任務
- ✅ 任務視覺化正確
- ✅ 資料持久化工作
- **建議**: 在此停留，進行內部使用測試，確認核心價值

完成 **Phase 5 後**:
- ✅ 拖曳功能完整
- ✅ 容量感知實現
- **建議**: 第一版公開 demo 或早期用戶測試

完成 **Phase 6-7 後**:
- ✅ 所有用戶故事完整
- ✅ 功能完整
- **建議**: 版本 1.0 發佈

### 增量交付方案

1. **v0.1** (MVP): Phase 1-4 → 「建立任務」可用
2. **v0.2**: Phase 5 → 「拖曳規劃」可用
3. **v0.3**: Phase 6-7 → 「調整移除 + 持久化」可用
4. **v1.0**: Phase 8-12 → 完整、穩定、文檔完善

---

## 工時估算總結

| 階段 | 任務數 | 預計工時 | 備註 |
|------|-------|--------|------|
| Phase 1 | 7 | 2 小時 | 可並行 |
| Phase 2 | 12 | 8 小時 | 可部分並行 |
| Phase 3 | 5 | 6 小時 | 涉及 Store，核心 |
| Phase 4 | 9 | 8 小時 | MVP，優先 |
| Phase 5 | 10 | 12 小時 | 複雜度高（拖曳） |
| Phase 6 | 10 | 8 小時 | 依賴 Phase 4-5 |
| Phase 7 | 6 | 4 小時 | 理論獨立，實際需前置 |
| Phase 8 | 8 | 6 小時 | 邊界處理 |
| Phase 9 | 8 | 4 小時 | 可並行 |
| Phase 10 | 4 | 2 小時 | 可選，簡單 |
| Phase 11 | 7 | 4 小時 | 文檔和部署 |
| Phase 12 | 5 | 2 小時 | 版本控制 |
| **總計** | **91** | **66 小時** | **約 8-10 天（單人）** |

---

## 驗收標準檢查清單

### 功能完整性（FR-001 至 FR-018）

- [ ] FR-001: 任務建立介面包含名稱輸入和時長選擇
- [ ] FR-002: 至少 6 種預設時長選項
- [ ] FR-003: 點擊「新增」立即產生區塊
- [ ] FR-004: 區塊顯示名稱和時長，大小與時長成正比
- [ ] FR-005: 任務池區域存在
- [ ] FR-006: 今日容器區域存在
- [ ] FR-007: 今日容器固定高度（480px = 16hr），參考線清晰
- [ ] FR-008: 拖曳區塊從池到容器
- [ ] FR-009: 拖曳區塊從容器回到池
- [ ] FR-010: 容器中區塊自動堆疊，無空隙
- [ ] FR-011: 容器溢出時視覺上無遮擋
- [ ] FR-012: 可刪除任務池中的區塊
- [ ] FR-013: 可移除容器中的區塊，剩餘自動排列
- [ ] FR-014: 資料儲存到 localStorage
- [ ] FR-015: 重新開啟時自動載入資料
- [ ] FR-016: 純靜態環境運作，無後端依賴
- [ ] FR-017: 空白名稱提示或預設
- [ ] FR-018: 超長名稱截斷並保持版面

### 可用性標準（SC-001 至 SC-007）

- [ ] SC-001: 30 秒內完成第一個任務建立
- [ ] SC-002: 2 分鐘內建立 3 個任務並規劃
- [ ] SC-003: 無說明文件也能成功操作（90% 成功率）
- [ ] SC-004: 一眼判斷時間負荷，無需計算
- [ ] SC-005: 資料恢復完整率 100%
- [ ] SC-006: 拖曳反應時間 < 100ms
- [ ] SC-007: Chrome、Firefox、Safari、Edge 都能正常運作

### 邊界情況

- [ ] 空白名稱提示友善
- [ ] 超長名稱截斷正常
- [ ] 極端時長（8hr+）顯示無破版
- [ ] 容器溢出（>16hr）無視覺遮擋
- [ ] 快速連續操作無誤
- [ ] 儲存滿時友善提示

---

## 後續步驟

1. ✅ 完成此任務清單（tasks.md）的撰寫
2. 🚀 開始 Phase 1 - 建立專案目錄結構（T001）
3. 📋 根據實際進度每日更新任務狀態
4. 📍 在各個 **Checkpoint** 處驗證功能，確保品質
5. 🎯 優先完成 MVP（Phase 4），提早獲得使用者反饋

---

**文檔版本**: 1.0 | **最後更新**: 2025-12-27 | **狀態**: 已準備實作

