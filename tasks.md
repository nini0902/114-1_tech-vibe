# 任務清單：一日時間視覺化工具 - Flutter Web 版本

**輸入來源**：plan.md（Flutter Web 實作計畫）、SPEC.md（規格定義）  
**組織方式**：按 Flutter Web 開發階段（Phase 0-7）組織，包含驗收標準、工時估計與並行標記  
**格式**：Markdown checklist 格式，每任務包含 ID、優先級、故事標籤、描述與文件路徑

---

## 概述

| 項目 | 數量 |
|------|------|
| 總任務數 | 74 |
| Phase 0 (環境準備) | 6 |
| Phase 1 (數據模型與狀態管理) | 12 |
| Phase 2 (UI 基礎組件) | 15 |
| Phase 3 (拖曳與互動) | 13 |
| Phase 4 (本地存儲) | 8 |
| Phase 5 (參考線與視覺優化) | 10 |
| Phase 6 (測試與優化) | 8 |
| Phase 7 (部署與文檔) | 4 |

---

## Phase 0：環境與依賴準備

**里程碑**：Flutter 環境就緒，依賴安裝完成，可啟動 dev 環境

**驗收標準**：
- ✅ `flutter --version` 顯示 ≥ 3.0.0
- ✅ `flutter pub get` 完成無誤
- ✅ `flutter run -d chrome` 成功啟動並顯示預設 Flutter Demo

### 任務清單

- [ ] T001 確認 Flutter SDK 版本 ≥ 3.0.0
  - 執行 `flutter --version`，記錄版本號
  - **工時估計**：0.25h
  - **驗收**：版本 ≥ 3.0.0 確認

- [ ] T002 [P] 初始化 Flutter Web 專案結構
  - 確認 `pubspec.yaml`、`web/`、`lib/`、`test/` 目錄結構
  - 調整目錄層級（若需要）符合 plan.md 規劃
  - **文件**：`pubspec.yaml`、`web/index.html`、`lib/main.dart`
  - **工時估計**：0.5h
  - **驗收**：項目結構完整，無缺失重要目錄

- [ ] T003 [P] 配置 pubspec.yaml 依賴
  - 添加 `provider: ^6.0.0`（狀態管理）
  - 添加 `shared_preferences: ^2.0.0`（本地存儲）
  - 添加 `intl: ^0.18.0`（日期本地化）
  - **文件**：`pubspec.yaml`
  - **工時估計**：0.5h
  - **驗收**：依賴版本正確，無語法錯誤

- [ ] T004 執行 `flutter pub get` 安裝依賴
  - 運行命令，等待完成
  - 確認 `pubspec.lock` 生成
  - **工時估計**：2h（首次下載可能較慢）
  - **驗收**：`pubspec.lock` 存在，無錯誤訊息

- [ ] T005 [P] 確認 `flutter run -d chrome` 可正常啟動
  - 執行命令，啟動 Chrome 瀏覽器
  - 驗證預設 Flutter Demo 顯示
  - **工時估計**：1h
  - **驗收**：Chrome 成功啟動，預設應用可見

- [ ] T006 設置 GitHub Pages 部署流程（初步）
  - 確認 `.github/workflows/deploy.yml` 或建立部署 workflow
  - 配置自動化構建與發佈到 `gh-pages` 分支
  - **文件**：`.github/workflows/deploy.yml`
  - **工時估計**：1h
  - **驗收**：Workflow 文件存在，基本配置完整

---

## Phase 1：數據模型與狀態管理

**里程碑**：核心數據模型完成，狀態管理框架就緒，單元測試通過

**驗收標準**：
- ✅ `Task` 模型實現完整（序列化/反序列化）
- ✅ `TaskProvider` 所有方法可用
- ✅ 單元測試覆蓋模型與 Provider 邏輯
- ✅ `flutter test` 執行無失敗

### 任務清單

- [ ] T007 定義 `Task` 數據模型
  - 字段：`id`（UUID）、`name`（任務名稱）、`duration`（時長，單位小時）、`createdAt`（建立時間）
  - 實現 `toJson()` 方法用於序列化
  - 實現 `fromJson()` 工廠構造用於反序列化
  - 實現 `==` 和 `hashCode` 用於比較
  - **文件**：`lib/models/task_model.dart`
  - **工時估計**：1.5h
  - **驗收**：所有方法實現，無編譯錯誤

- [ ] T008 [P] 定義全局應用狀態類 `AppState`
  - 字段：`allTasks`（所有任務列表）、`tasksInContainer`（已放入容器的任務 ID 集合）
  - Getter 方法：`tasksInPool`、`tasksInContainer`
  - **文件**：`lib/models/app_state.dart`
  - **工時估計**：0.5h
  - **驗收**：狀態類定義清楚，無邏輯錯誤

- [ ] T009 [P] 實現 `TaskProvider` 狀態管理（使用 ChangeNotifier）
  - 方法：`addTask(String name, double duration)`
  - 方法：`removeTask(String id)`
  - 方法：`moveTaskToContainer(Task task)`
  - 方法：`moveTaskOutOfContainer(Task task)`
  - 方法：`loadFromStorage()` 和 `saveToStorage()`
  - 每個修改操作後調用 `notifyListeners()`
  - **文件**：`lib/providers/task_provider.dart`
  - **工時估計**：2h
  - **驗收**：所有方法實現，邏輯正確，無編譯錯誤

- [ ] T010 [P] 設置 `shared_preferences` 持久化邏輯
  - 初始化 `SharedPreferences` 實例
  - 實現儲存任務列表到本地存儲
  - 實現從本地存儲讀取任務列表
  - **文件**：`lib/utils/storage.dart`
  - **工時估計**：1.5h
  - **驗收**：讀寫函數無誤，JSON 序列化完整

- [ ] T011 [P] 定義常數與配置文件
  - 時長選項常數：0.5、1、1.5、2、3、4 小時
  - 容器高度：24 小時對應 500 邏輯像素
  - 顏色方案初步定義（稍後完善）
  - **文件**：`lib/utils/constants.dart`
  - **工時估計**：0.5h
  - **驗收**：常數定義完整，無語法錯誤

- [ ] T012 [P] 編寫 `Task` 模型單元測試
  - 測試 `toJson()` / `fromJson()` 序列化
  - 測試 `==` 比較操作
  - 測試邊界值（0.5h、24h 等）
  - **文件**：`test/models/task_model_test.dart`
  - **工時估計**：1.5h
  - **驗收**：所有測試通過，`flutter test` 無失敗

- [ ] T013 [P] 編寫 `TaskProvider` 邏輯單元測試
  - 測試 `addTask()` 正確添加任務
  - 測試 `removeTask()` 正確移除任務
  - 測試 `moveTaskToContainer()` / `moveTaskOutOfContainer()` 狀態轉換
  - 測試重複操作不出錯
  - **文件**：`test/providers/task_provider_test.dart`
  - **工時估計**：2h
  - **驗收**：所有測試通過，邏輯覆蓋完整

- [ ] T014 [P] 編寫持久化存儲單元測試
  - 測試 `saveTasks()` 正確保存
  - 測試 `loadTasks()` 正確讀取
  - 測試空列表、異常情況
  - **文件**：`test/utils/storage_test.dart`
  - **工時估計**：1.5h
  - **驗收**：所有測試通過，無未預期的異常

- [ ] T015 在 `main.dart` 中初始化 `TaskProvider`
  - 使用 `MultiProvider` 包裹應用
  - 配置 `TaskProvider` 為全局提供者
  - 應用啟動時加載存儲中的數據
  - **文件**：`lib/main.dart`
  - **工時估計**：1h
  - **驗收**：應用啟動無誤，Provider 可在 Widget 中訪問

- [ ] T016 驗收 Phase 1：Phase 1 完整性測試
  - 執行 `flutter test` 確認所有單元測試通過
  - 執行 `flutter analyze` 檢查代碼品質
  - 驗證 Provider 在熱重載下仍工作正常
  - **工時估計**：1h
  - **驗收**：所有測試綠燈，無 Lint 警告

---

## Phase 2：UI 基礎組件與布局

**里程碑**：靜態 UI 框架完成，可視化層次清晰，所有基礎 Widget 可顯示

**驗收標準**：
- ✅ `HomeScreen` 二分欄布局清晰
- ✅ 所有基礎 Widget 無編譯錯誤
- ✅ 任務區塊高度計算正確
- ✅ 應用視覺整潔，易於使用

### 任務清單

- [ ] T017 建立 `HomeScreen` 主畫面框架
  - 二分欄布局：左側（任務建立 + 任務池）、右側（一日容器 + 參考線預留）
  - 使用 `Row` 和 `Expanded` 實現動態佈局
  - 設置基本背景色與邊框
  - **文件**：`lib/screens/home_screen.dart`
  - **工時估計**：1.5h
  - **驗收**：佈局顯示正確，二分欄比例均勻

- [ ] T018 [P] 實現 `TaskCreationWidget` 建立任務區
  - 任務名稱輸入框（`TextField`）
  - 時長下拉選單（`DropdownButton`，選項來自常數）
  - 「新增任務」按鈕（`ElevatedButton`）
  - 點擊按鈕時調用 `TaskProvider.addTask()`
  - **文件**：`lib/widgets/task_creation.dart`
  - **工時估計**：1.5h
  - **驗收**：輸入框與按鈕響應，下拉選單正常

- [ ] T019 [P] 實現 `TaskPoolWidget` 任務池
  - 顯示所有未放入容器的任務（網格或列表佈局）
  - 每個任務顯示為 TaskBlock Widget（見 T020）
  - 空任務池時顯示提示文本
  - **文件**：`lib/widgets/task_pool.dart`
  - **工時估計**：1.5h
  - **驗收**：任務列表正確顯示，佈局不重疊

- [ ] T020 [P] 實現 `TaskBlock` 任務區塊 Widget
  - 顯示任務名稱、時長
  - 計算區塊高度：`(duration / 24) * 500 邏輯像素`
  - 應用顏色主題（邊框、背景、文字）
  - 初步設置靜態樣式，後續支持拖曳（Phase 3）
  - **文件**：`lib/widgets/task_block.dart`
  - **工時估計**：1.5h
  - **驗收**：高度計算正確，視覺外觀整潔

- [ ] T021 [P] 實現 `DayContainerWidget` 一日容器
  - 固定高度（500 邏輯像素，代表 24 小時）
  - 可設置背景色、邊框、陰影
  - 允許內容溢出（`overflow: visible`）
  - 初步設置靜態顯示，後續支持拖曳目標（Phase 3）
  - **文件**：`lib/widgets/day_container.dart`
  - **工時估計**：1h
  - **驗收**：容器高度固定，邊界清晰

- [ ] T022 [P] 實現 `ReferenceLines` 參考線組件（基礎版）
  - 在容器右側顯示水平參考線：8h、16h、24h
  - 計算參考線位置：`(hour / 24) * 500`
  - 添加文字標籤（「8 小時」、「16 小時」、「24 小時」）
  - **文件**：`lib/widgets/reference_lines.dart`
  - **工時估計**：1.5h
  - **驗收**：參考線位置正確，文字標籤清晰

- [ ] T023 [P] 定義顏色主題與樣式
  - 定義色板：任務區塊背景色（6 種或使用隨機色）
  - 定義 UI 元件顏色：容器邊框、按鈕、文本
  - 定義字體與大小
  - **文件**：`lib/utils/colors.dart`
  - **工時估計**：1h
  - **驗收**：色板完整，無視覺衝突

- [ ] T024 [P] 在 `HomeScreen` 集成所有基礎 Widget
  - 組合 `TaskCreationWidget`、`TaskPoolWidget`、`DayContainerWidget`、`ReferenceLines`
  - 確保佈局層級清晰
  - 應用顏色主題至各個 Widget
  - **文件**：`lib/screens/home_screen.dart`（更新）
  - **工時估計**：1h
  - **驗收**：完整 UI 顯示無誤，視覺層次清晰

- [ ] T025 [P] 實現 `App` Widget 與路由框架
  - 建立 `App` Widget（應用根節點）
  - 配置 Material Theme
  - 設置首頁為 `HomeScreen`
  - **文件**：`lib/app.dart`
  - **工時估計**：0.5h
  - **驗收**：應用啟動無誤，主題一致

- [ ] T026 [P] 進行響應式布局調試
  - 在不同螢幕寬度測試佈局（桌面、平板、手機寬度）
  - 調整 `Expanded` 比例或使用 `LayoutBuilder`
  - **工時估計**：1h
  - **驗收**：佈局在 320px-2560px 寬度都可用

- [ ] T027 [P] 添加基礎動畫與過渡效果
  - 任務新增時的淡入動畫（`AnimatedOpacity`）
  - 按鈕按下時的縮放動畫（`AnimatedScale`）
  - **文件**：`lib/widgets/task_creation.dart`、`lib/widgets/task_block.dart`（更新）
  - **工時估計**：1.5h
  - **驗收**：動畫流暢，無卡頓

- [ ] T028 [P] 實現任務刪除按鈕（UI 層）
  - 在 TaskBlock 上添加刪除按鈕（X 圖標）
  - 點擊時調用 `TaskProvider.removeTask()`
  - 添加確認對話框（可選）
  - **文件**：`lib/widgets/task_block.dart`（更新）
  - **工時估計**：1h
  - **驗收**：按鈕可點擊，任務成功刪除

- [ ] T029 驗收 Phase 2：UI 視覺審查與品質檢查
  - 執行 `flutter analyze` 檢查代碼品質
  - 手動測試所有 UI 元件顯示
  - 檢查無浮點數舍入引起的視覺誤差
  - **工時估計**：1.5h
  - **驗收**：UI 視覺符合規格，無 Lint 警告

---

## Phase 3：拖曳與互動機制

**里程碑**：完整的拖曳功能，UI 響應式更新，交互流暢

**驗收標準**：
- ✅ 可從任務池拖曳任務到容器
- ✅ 可從容器拖曳任務回任務池
- ✅ 拖曳時有視覺反饋（反色、陰影等）
- ✅ 拖曳後 Provider 狀態正確更新
- ✅ 邊界情況（空容器、重複拖曳）處理無誤

### 任務清單

- [ ] T030 實現 `Draggable<Task>` 包裝
  - 在 `TaskBlock` 中使用 `Draggable<Task>`
  - 配置 `data` 為當前 Task 對象
  - 實現 `feedback` Widget（拖曳時跟隨光標的預覽，半透明）
  - 配置 `childWhenDragging`（拖曳中原位置的狀態，例：半透明）
  - **文件**：`lib/widgets/task_block.dart`（更新）
  - **工時估計**：1.5h
  - **驗收**：拖曳開始時有視覺反饋，反色/陰影正確

- [ ] T031 [P] 實現 `DragTarget<Task>` 在容器中
  - 在 `DayContainerWidget` 中使用 `DragTarget<Task>`
  - 實現 `onWillAccept` 驗證邏輯（檢查任務是否已在容器）
  - 實現 `onAccept` 回調調用 `provider.moveTaskToContainer(task)`
  - 實現 `builder` 顯示拖曳懸停時的視覺反饋（邊框發亮等）
  - **文件**：`lib/widgets/day_container.dart`（更新）
  - **工時估計**：1.5h
  - **驗收**：任務成功拖入容器，Provider 狀態更新

- [ ] T032 [P] 實現容器內任務的 `Draggable<Task>` 包裝
  - 當任務在容器內時，仍可拖曳（使用同樣的 Draggable 包裝）
  - 配置視覺反饋一致性
  - **文件**：`lib/widgets/day_container.dart`（更新）
  - **工時估計**：1h
  - **驗收**：容器內任務仍可拖動

- [ ] T033 [P] 實現任務池的 `DragTarget<Task>` 作為丟棄區
  - 從容器拖曳任務回任務池
  - 實現 `onAccept` 調用 `provider.moveTaskOutOfContainer(task)`
  - **文件**：`lib/widgets/task_pool.dart`（更新）
  - **工時估計**：1h
  - **驗收**：任務成功拖回任務池，Provider 狀態正確

- [ ] T034 [P] 實現拖曳的視覺反饋與動畫
  - 拖曳懸停時容器邊框發亮（顏色變化）
  - 拖曳完成後動畫重置（`AnimatedContainer`）
  - **文件**：`lib/widgets/day_container.dart`、`lib/widgets/task_pool.dart`（更新）
  - **工時估計**：1.5h
  - **驗收**：拖曳反饋流暢，動畫無卡頓

- [ ] T035 [P] 測試拖曳邊界情況
  - 空任務池拖曳（無法拖曳）
  - 滿容器（24 小時）拖曳超過容量的任務（允許溢出，視覺上超出邊界）
  - 多次快速拖曳（無衝突、狀態一致）
  - **工時估計**：2h
  - **驗收**：所有邊界情況處理無異常

- [ ] T036 實現拖曳的撤銷/取消機制（可選增強功能）
  - 拖曳到無效區域時自動返回原位置
  - **文件**：`lib/widgets/task_block.dart`（更新）
  - **工時估計**：1h
  - **驗收**：無效拖曳可撤銷

- [ ] T037 [P] 優化 Provider 中的任務狀態轉換邏輯
  - 確保重複移動同一任務不會崩潰
  - 添加日誌記錄拖曳操作（便於調試）
  - **文件**：`lib/providers/task_provider.dart`（更新）
  - **工時估計**：1h
  - **驗收**：狀態轉換邏輯穩定，日誌清晰

- [ ] T038 [P] 實現鍵盤支持（可選增強功能）
  - 支持 Delete 鍵刪除選中任務
  - 支持 Enter 鍵新增任務
  - **文件**：`lib/widgets/task_creation.dart`、`lib/widgets/task_block.dart`（更新）
  - **工時估計**：1.5h
  - **驗收**：快捷鍵正常工作

- [ ] T039 驗收 Phase 3：互動流程完整性測試
  - 完整使用流程測試：建立 → 拖入 → 拖出 → 刪除
  - 手動測試多個任務的組合操作
  - 驗證 UI 狀態與 Provider 狀態同步
  - **工時估計**：2h
  - **驗收**：所有互動流程通暢，無滯後或崩潰

---

## Phase 4：本地存儲與數據持久化

**里程碑**：數據持久化完整，重新整理後數據保持

**驗收標準**：
- ✅ 新增任務後保存成功
- ✅ 拖曳操作後狀態保存成功
- ✅ 刷新頁面後數據仍存在
- ✅ 多次操作後存儲無數據丟失

### 任務清單

- [ ] T040 連接 `shared_preferences` 初始化
  - 在 `main()` 中初始化 `SharedPreferences`
  - 確保非同步操作完成後啟動 App
  - 配置異常處理（若 shared_preferences 初始化失敗）
  - **文件**：`lib/main.dart`（更新）
  - **工時估計**：1h
  - **驗收**：應用啟動無異常，初始化日誌清晰

- [ ] T041 [P] 完善 JSON 序列化/反序列化
  - Task.toJson() 方法完整（所有字段）
  - Task.fromJson() 工廠構造完整
  - List<Task> 的序列化（使用 `jsonEncode`）
  - List<Task> 的反序列化（使用 `jsonDecode`）
  - **文件**：`lib/models/task_model.dart`（更新）
  - **工時估計**：0.5h
  - **驗收**：序列化/反序列化測試通過

- [ ] T042 [P] 實現 `TaskProvider.loadFromStorage()`
  - 應用啟動時從存儲讀取任務列表
  - 讀取 `tasksInContainer` 集合
  - 異常處理（若存儲為空或格式不正確）
  - **文件**：`lib/providers/task_provider.dart`（更新）
  - **工時估計**：1h
  - **驗收**：啟動時數據成功加載

- [ ] T043 [P] 實現 `TaskProvider.saveToStorage()`
  - 每次任務修改後自動保存
  - 保存任務列表與容器狀態
  - 異常處理與日誌記錄
  - **文件**：`lib/providers/task_provider.dart`（更新）
  - **工時估計**：1h
  - **驗收**：修改操作後數據保存成功

- [ ] T044 [P] 在各 Provider 方法中添加存儲調用
  - `addTask()` 後調用 `saveToStorage()`
  - `removeTask()` 後調用 `saveToStorage()`
  - `moveTaskToContainer()` 後調用 `saveToStorage()`
  - `moveTaskOutOfContainer()` 後調用 `saveToStorage()`
  - **文件**：`lib/providers/task_provider.dart`（更新）
  - **工時估計**：0.5h
  - **驗收**：所有修改方法都觸發保存

- [ ] T045 [P] 編寫數據持久化集成測試
  - 模擬完整流程：建立 → 修改 → 存儲 → 讀取
  - 測試重新整理頁面後數據仍存在
  - **文件**：`test/integration/persistence_test.dart`
  - **工時估計**：2h
  - **驗收**：集成測試通過，無數據丟失

- [ ] T046 驗證瀏覽器 LocalStorage 正確使用
  - 打開 Chrome DevTools → Application 標籤
  - 檢查 LocalStorage 中的數據正確存儲
  - 驗證數據格式為 JSON 字符串
  - **工時估計**：1h
  - **驗收**：LocalStorage 數據格式正確

- [ ] T047 驗收 Phase 4：數據持久化完整性檢查
  - 執行完整操作流程並驗證存儲
  - 手動清理 LocalStorage 並重新測試
  - 執行 `flutter test` 確認持久化測試通過
  - **工時估計**：1.5h
  - **驗收**：數據持久化可靠，無邊界情況失敗

---

## Phase 5：參考線與視覺優化

**里程碑**：UI 視覺完整，用戶體驗優化，應用美觀專業

**驗收標準**：
- ✅ 參考線清晰標示時間刻度
- ✅ 顏色主題統一，視覺和諧
- ✅ 響應式布局在多種螢幕工作
- ✅ 動畫與過渡流暢無卡頓

### 任務清單

- [ ] T048 完善 `ReferenceLines` 參考線組件
  - 優化參考線的繪製（使用 `CustomPaint` 或簡單 Widget）
  - 調整線寬、顏色、透明度
  - 優化文字標籤的位置與大小
  - 適配不同螢幕尺寸
  - **文件**：`lib/widgets/reference_lines.dart`（更新）
  - **工時估計**：1.5h
  - **驗收**：參考線清晰可辨，文字標籤不重疊

- [ ] T049 [P] 實現任務區塊的顏色多樣性
  - 為每個新任務分配隨機或循環顏色
  - 顏色從預定色板選擇（定義在 `colors.dart`）
  - **文件**：`lib/models/task_model.dart`（添加 color 字段）、`lib/widgets/task_block.dart`（更新）
  - **工時估計**：1.5h
  - **驗收**：任務區塊顯示不同顏色，無視覺單調

- [ ] T050 [P] 優化 UI 元件的視覺層次
  - 調整 TaskBlock 的邊距、陰影、圓角
  - 調整按鈕的大小、顏色、懸停效果
  - 調整容器的邊框厚度與顏色
  - **文件**：`lib/utils/constants.dart`（更新）、各 Widget 文件
  - **工時估計**：2h
  - **驗收**：UI 層次清晰，視覺層級易於理解

- [ ] T051 [P] 実装スムーズなアニメーション與過渡
  - 任務堆疊時的位置動畫（`AnimatedPositioned`）
  - 任務刪除時的淡出動畫（`AnimatedOpacity`）
  - 容器懸停時的背景色變化（`AnimatedContainer`）
  - **文件**：`lib/widgets/day_container.dart`、`lib/widgets/task_block.dart`（更新）
  - **工時估計**：2h
  - **驗收**：動畫流暢，無跳幀或延遲

- [ ] T052 [P] 響應式佈局微調
  - 在 480px、768px、1024px、1920px 寬度測試佈局
  - 調整 `Expanded` 的 `flex` 比例或使用 `ConstrainedBox`
  - 在平板/手機視圖優化文字大小與按鈕尺寸
  - **文件**：`lib/screens/home_screen.dart`（更新）
  - **工時估計**：1.5h
  - **驗收**：所有測試寬度的佈局都可用且美觀

- [ ] T053 [P] 添加無障礙支持（a11y）
  - 為按鈕添加 `semanticLabel`
  - 為重要元素添加 `Semantics` Widget
  - 確保高對比度的文字
  - **文件**：各 Widget 文件
  - **工時估計**：1.5h
  - **驗收**：無障礙檢查工具無失敗

- [ ] T054 [P] 優化字體與排版
  - 統一應用字體系列（例：系統默認或 Google Fonts）
  - 設置清晰的字號層級（標題、正文、標籤）
  - 調整行高與字間距改善易讀性
  - **文件**：`lib/utils/constants.dart`（更新）、各 Widget
  - **工時估計**：1h
  - **驗收**：排版清晰易讀，無字型混亂

- [ ] T055 [P] 實現深色主題支持（可選增強）
  - 定義深色色板（若使用者系統使用深色主題）
  - 使用 `MediaQuery.of(context).platformBrightness` 檢測
  - **文件**：`lib/utils/colors.dart`（更新）、`lib/app.dart`（更新）
  - **工時估計**：1.5h
  - **驗收**：深色主題下視覺層次清晰

- [ ] T056 驗收 Phase 5：視覺品質審查
  - 執行 `flutter analyze` 檢查代碼品質
  - 手動檢視多種螢幕尺寸下的視覺效果
  - 瀏覽器兼容性檢查（Chrome、Firefox、Safari）
  - **工時估計**：2h
  - **驗收**：視覺品質達到專業水準，無 Lint 警告

---

## Phase 6：測試與優化

**里程碑**：功能完整，性能達標，代碼品質優秀

**驗收標準**：
- ✅ 單元測試覆蓋 ≥ 70%
- ✅ 集成測試覆蓋主要使用流程
- ✅ `flutter analyze` 無警告
- ✅ 性能測試：頁面加載 < 2s，互動延遲 < 100ms

### 任務清單

- [ ] T057 [P] 擴展單元測試覆蓋
  - 補充 Widget 層的單元測試（TextFields、Buttons 等）
  - 補充常數與工具函數的測試
  - **文件**：`test/widgets/*_test.dart`、`test/utils/*_test.dart`
  - **工時估計**：2h
  - **驗收**：覆蓋率 ≥ 70%，所有測試通過

- [ ] T058 [P] 編寫完整的集成測試
  - 測試使用流程：打開 → 建立 → 拖曳 → 刪除
  - 測試邊界情況（多任務、大時長、快速操作）
  - **文件**：`test/integration/*_test.dart`
  - **工時估計**：2.5h
  - **驗收**：集成測試涵蓋主要流程，所有通過

- [ ] T059 [P] 進行性能優化
  - 使用 `const` 修飾不變的 Widget 減少重建
  - 優化 Provider 訂閱，使用 `Selector` 減少不必要的重建
  - 檢查 ListBuilder 性能（若任務數量大）
  - **文件**：各 Widget 文件
  - **工時估計**：2h
  - **驗收**：頁面加載 < 2s，互動延遲 < 100ms

- [ ] T060 [P] 優化包大小與加載時間
  - 檢查 `flutter build web` 輸出大小
  - 使用 `--release` 構建並啟用壓縮
  - 移除未使用的依賴
  - **工時估計**：1.5h
  - **驗收**：構建輸出合理（< 10MB），加載快速

- [ ] T061 代碼清理與重構
  - 移除調試代碼與日誌語句
  - 統一命名規範與代碼格式
  - 提取公共邏輯為獨立函數/方法
  - **工時估計**：1.5h
  - **驗收**：代碼整潔，無冗餘，易於維護

- [ ] T062 執行 `flutter analyze` 與 Lint 修復
  - 執行命令檢查代碼品質
  - 修復所有警告與錯誤
  - **工時估計**：1h
  - **驗收**：`flutter analyze` 無警告

- [ ] T063 進行瀏覽器兼容性測試
  - 在 Chrome、Firefox、Safari 上測試
  - 檢查拖曳、存儲、UI 渲染
  - 記錄並修復兼容性問題
  - **工時估計**：2h
  - **驗收**：所有主流瀏覽器可用

- [ ] T064 驗收 Phase 6：品質與效能驗證
  - 執行 `flutter test` 確認所有測試通過
  - 執行性能分析工具（DevTools Profiler）
  - 最終代碼審查
  - **工時估計**：2h
  - **驗收**：測試覆蓋率達標，性能指標達到預期

---

## Phase 7：部署與文檔

**里程碑**：應用上線，文檔完整，可供使用

**驗收標準**：
- ✅ `flutter build web --release` 構建成功
- ✅ GitHub Pages 自動部署配置完成
- ✅ 在線 URL 可訪問，功能完整
- ✅ README.md 與使用指南編寫完成

### 任務清單

- [ ] T065 構建生產版本
  - 執行 `flutter build web --release`
  - 驗證 `build/web/` 目錄生成完整
  - 檢查生成的 HTML、JS 文件無誤
  - **工時估計**：2h
  - **驗收**：構建成功，輸出完整

- [ ] T066 [P] 配置 GitHub Pages 自動部署
  - 確認 `.github/workflows/deploy.yml` 完整配置
  - 配置自動化 CI/CD 流程：push → build → deploy to gh-pages
  - 配置 GitHub Pages 設置（Settings → Pages）指向 gh-pages 分支
  - **文件**：`.github/workflows/deploy.yml`
  - **工時估計**：1h
  - **驗收**：Workflow 執行成功，自動部署到 gh-pages

- [ ] T067 [P] 驗證在線應用可訪問性
  - 打開 GitHub Pages URL 訪問應用
  - 測試核心功能：建立、拖曳、刪除、刷新保持
  - **工時估計**：1h
  - **驗收**：在線應用完全可用

- [ ] T068 編寫完整的 README.md 文檔
  - 項目簡介與功能說明
  - 開發環境設置指南
  - 運行開發環境步驟（`flutter pub get` → `flutter run -d chrome`）
  - 構建與部署說明（`flutter build web --release`）
  - 技術棧說明與與 Vanilla JS 版本的區別
  - 常見問題與解決方案
  - 貢獻指南
  - **文件**：`README.md`（更新或新建）
  - **工時估計**：2h
  - **驗收**：文檔完整清晰，新開發者可按指南快速上手

- [ ] T069 編寫快速啟動指南（quickstart.md）
  - 5 分鐘快速體驗應用
  - 包含 clone、setup、run 三步
  - **文件**：`quickstart.md`
  - **工時估計**：0.5h
  - **驗收**：指南簡潔可行

- [ ] T070 編寫開發者指南（CONTRIBUTING.md）
  - 開發流程與分支管理
  - 代碼風格與規範
  - 提交 PR 的要求
  - **文件**：`CONTRIBUTING.md`
  - **工時估計**：1h
  - **驗收**：指南清晰，便於協作

---

## 額外任務：文檔與知識管理（可選）

這些任務不直接影響功能，但有助於知識保留與長期維護。

- [ ] T071 [P] 編寫架構設計文檔
  - 數據流圖：User Input → Provider → UI Update
  - 組件層級關係圖
  - **文件**：`docs/architecture.md`
  - **工時估計**：1h

- [ ] T072 [P] 編寫 API 文檔（Provider 方法簽名）
  - `TaskProvider` 所有公開方法的文檔
  - 參數說明與返回值說明
  - **文件**：`docs/api.md`
  - **工時估計**：0.5h

- [ ] T073 [P] 編寫常見問題與解決方案（FAQ）
  - shared_preferences 初始化問題
  - Draggable/DragTarget 嵌套問題
  - **文件**：`docs/faq.md`
  - **工時估計**：0.5h

- [ ] T074 編寫變更日誌（CHANGELOG.md）
  - 記錄從 Vanilla JS 到 Flutter Web 的遷移說明
  - 各版本的功能與改進
  - **文件**：`CHANGELOG.md`
  - **工時估計**：0.5h

---

## 依賴關係與執行順序

### Phase 依賴圖

```
Phase 0 (環境準備)
    ↓
Phase 1 (數據模型與狀態管理)
    ↓
Phase 2 (UI 基礎組件)
    ↓
Phase 3 (拖曳與互動) ← 可與 Phase 2 重疊
    ↓
Phase 4 (本地存儲)
    ↓
Phase 5 (視覺優化) ← 可與 Phase 4 重疊
    ↓
Phase 6 (測試與優化)
    ↓
Phase 7 (部署與文檔)
```

### 關鍵路徑（最短實現 MVP）

1. **Phase 0** (4h)：環境就緒
2. **Phase 1** (12h)：數據模型 + 狀態管理
3. **Phase 2** (15h)：UI 框架完成
4. **Phase 3** (13h)：拖曳交互完成 → **可交付 MVP v1**（43h）
5. Phase 4 (8h)：持久化完成 → **MVP v1.1**（51h）
6. Phase 5 (10h)：視覺優化 → **MVP v1.2**（61h）
7. Phase 6 (8h)：測試優化
8. Phase 7 (5h)：部署上線 → **生產版本**（74h）

### 並行機會

**Phase 0**：所有標記 [P] 的任務可並行
- T002、T003、T005、T006

**Phase 1**：標記 [P] 的任務可並行（不同文件，無依賴）
- T008、T009、T010、T011、T012、T013、T014

**Phase 2**：標記 [P] 的任務可並行
- T018、T019、T020、T021、T022、T023、T025、T026、T027、T028

**Phase 3**：標記 [P] 的任務可並行
- T031、T032、T033、T034、T035、T037、T038

**Phase 4-7**：同樣遵循 [P] 標記進行並行

### 並行執行範例：Phase 1

```
開發者 A：T008、T012 (AppState + 其單元測試)
開發者 B：T009、T013 (TaskProvider + 其單元測試)
開發者 C：T010、T014 (Storage + 其單元測試)
開發者 D：T007、T011 (Task Model + 常數定義)

所有開發者並行工作，完成後 Phase 1 準備就緒。
```

### 順序依賴

| 任務 | 依賴 | 理由 |
|------|------|------|
| T002 | T001 | 需確認 Flutter 版本正確 |
| T004 | T003 | 需配置 pubspec.yaml 後執行 pub get |
| T005 | T004 | 依賴已安裝完成 |
| T015 | T001-T014 | 需 Provider 和 Task Model 都完成 |
| T017 | T015 | 需 Provider 已初始化在 main.dart |
| T024 | T018-T022 | 需所有基礎 Widget 都實現 |
| T030 | T020 | 需 TaskBlock 先實現 |
| T031 | T021 | 需 DayContainer 先實現 |
| T040 | T039 | Phase 3 完成後進行 |
| T055 | T054 | 依賴字體設置完成 |

---

## 實施策略

### MVP 優先（只做 User Story 1）

對應本項目，相當於完成基礎功能：

1. 完成 **Phase 0** → 環境就緒
2. 完成 **Phase 1** → 數據模型與狀態管理就緒
3. 完成 **Phase 2** → UI 框架就緒
4. 完成 **Phase 3** → 拖曳交互完成 → **MVP 可用**
5. **驗證**：手動測試完整流程
6. **部署**：如準備好，執行 Phase 7 部署

**MVP 預計工時**：~43 小時

### 增量交付

1. **MVP v1** (Phase 0-3)：核心功能，無數據持久化
2. **MVP v1.1** (Phase 4)：添加數據持久化
3. **MVP v1.2** (Phase 5)：視覺優化
4. **v1.0 生產版** (Phase 6-7)：測試、部署、文檔

每個階段都可獨立驗證與部署。

### 並行團隊策略

若有 4 人開發團隊：

1. **第 1 天**：全隊完成 Phase 0 (4h)
2. **第 2 天**：全隊完成 Phase 1 (12h，並行分工)
3. **第 3 天**：全隊完成 Phase 2 (15h，並行分工)
4. **第 4-5 天**：全隊完成 Phase 3 (13h，並行分工) + Phase 4 (8h)
5. **第 6 天**：全隊完成 Phase 5 (10h，並行分工)
6. **第 7 日**：全隊完成 Phase 6 (8h) + Phase 7 (5h)

**總耗時**：約 7-10 個工作日（視實際速度調整）

### 單人開發策略

建議按 Phase 順序執行：

1. Phase 0 (0.5 天)
2. Phase 1 (2 天)
3. Phase 2 (2.5 天)
4. Phase 3 (2.5 天) → **在此停止驗證 MVP**
5. Phase 4 (1 天)
6. Phase 5 (1.5 天)
7. Phase 6 (1.5 天)
8. Phase 7 (1 天)

**總耗時**：約 12-14 個工作日

---

## 驗收檢查清單

### Phase 0 驗收
- [ ] Flutter SDK ≥ 3.0.0 安裝完成
- [ ] `pubspec.lock` 生成
- [ ] `flutter run -d chrome` 啟動成功

### Phase 1 驗收
- [ ] Task Model 所有方法實現
- [ ] TaskProvider 所有方法實現
- [ ] 單元測試覆蓋率 ≥ 80%
- [ ] `flutter test` 全部通過

### Phase 2 驗收
- [ ] HomeScreen 二分欄布局清晰
- [ ] 所有基礎 Widget 顯示正確
- [ ] 高度計算無誤
- [ ] 響應式布局在 320-2560px 寬度可用

### Phase 3 驗收
- [ ] 可拖曳任務到容器
- [ ] 可拖曳任務回任務池
- [ ] 拖曳有視覺反饋
- [ ] Provider 狀態同步正確

### Phase 4 驗收
- [ ] 新增任務後保存成功
- [ ] 重新整理後數據仍存在
- [ ] 拖曳操作後狀態保存
- [ ] 多次操作無數據丟失

### Phase 5 驗收
- [ ] 參考線清晰標示時間刻度
- [ ] 顏色主題統一和諧
- [ ] 動畫流暢無卡頓
- [ ] 視覺層次清晰易懂

### Phase 6 驗收
- [ ] 單元測試覆蓋率 ≥ 70%
- [ ] 集成測試覆蓋主要流程
- [ ] `flutter analyze` 無警告
- [ ] 性能指標達到預期

### Phase 7 驗收
- [ ] `flutter build web --release` 成功
- [ ] GitHub Pages 自動部署配置完成
- [ ] 在線 URL 可訪問
- [ ] README、quickstart 等文檔完整

---

## 技術參考與資源

### 官方文檔
- [Flutter for Web](https://flutter.dev/web)
- [Flutter Draggable](https://api.flutter.dev/flutter/widgets/Draggable-class.html)
- [Flutter DragTarget](https://api.flutter.dev/flutter/widgets/DragTarget-class.html)
- [Provider 包](https://pub.dev/packages/provider)
- [shared_preferences](https://pub.dev/packages/shared_preferences)

### 常見問題與解決方案

#### Q1: shared_preferences 在 Web 端拋出異常
**原因**：初始化時機不對或未等待非同步操作完成  
**解決**：在 `main()` 中使用 `WidgetsFlutterBinding.ensureInitialized()` 並 `await SharedPreferences.getInstance()`

#### Q2: Draggable 在 DragTarget 內無法工作
**原因**：嵌套了多層 Draggable，Flutter 限制嵌套深度  
**解決**：使用包裝 Widget 或重新設計層級結構

#### Q3: 拖曳後 UI 未更新
**原因**：Provider 的 `notifyListeners()` 未調用  
**解決**：確保所有修改狀態的方法末尾都呼叫 `notifyListeners()`

#### Q4: 性能問題（卡頓、延遲）
**原因**：過度重建、未使用 `const` 修飾  
**解決**：使用 `Selector` 精細化訂閱，使用 `const` 修飾不變 Widget

---

## 預期工時總結

| Phase | 工時 (小時) | 說明 |
|-------|----------|------|
| 0 | 4 | 環境檢查與配置 |
| 1 | 12 | 模型、Provider、存儲邏輯 |
| 2 | 15 | UI 組件開發 |
| 3 | 13 | 拖曳交互實現 |
| **MVP 小計** | **44** | 可交付基本功能 |
| 4 | 8 | 持久化集成 |
| 5 | 10 | 視覺優化 |
| 6 | 8 | 測試與性能優化 |
| 7 | 5 | 部署與文檔 |
| **總計** | **75** | 完整生產版本 |

---

## 注意事項

1. **不要過度設計**：遵循 SPEC.md 的 MVP 範圍，暫不實現 V2 功能（多天規劃、AI 建議等）
2. **優先完整性**：每個 Phase 都應產生可運行的版本，避免「最後才能測試」
3. **持續測試**：每完成一個任務就執行 `flutter run` 驗證，及早發現問題
4. **代碼審查**：多人協作時，建議在 PR 合併前進行代碼審查
5. **文檔同步**：實現過程中同步更新文檔，不要留到最後

---

## 更新日誌

| 日期 | 版本 | 變更 |
|------|------|------|
| 2025-12-27 | 1.0 | 初版發佈，74 任務，包含 Phase 0-7 完整規劃 |

---

**最後更新**：2025-12-27  
**制定人**：SpecKit 任務規劃系統  
**適用範圍**：一日時間視覺化工具 - Flutter Web 版本
