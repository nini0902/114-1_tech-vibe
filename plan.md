# 一日時間視覺化工具 - Flutter Web 實作計畫

## 1. 技術棧選擇與說明

### 核心技術選擇
- **前端框架**：Flutter for Web（Dart）
- **狀態管理**：Provider（輕量且易於學習）
- **本地存儲**：localstorage（Dart `html` 包）或 `shared_preferences` for web
- **拖曳功能**：Flutter 原生 `Draggable` + `DragTarget`
- **構建與部署**：`flutter build web` → GitHub Pages

### 技術選擇的理由

| 技術 | 選擇 | 原因 |
|------|------|------|
| 框架 | Flutter Web | SPEC.md 明確要求，跨平台一致性，UI 控制精細 |
| 狀態管理 | Provider | 官方推薦，生態成熟，學習曲線溫和 |
| 拖曳 | Draggable/DragTarget | Flutter 原生支持，無需第三方依賴 |
| 存儲 | shared_preferences (web) | Dart 官方支持，跨平台，簡單可靠 |
| 部署 | GitHub Pages | SPEC.md 要求靜態構建，free hosting |

### 與 Vanilla JS 版本的主要差異

| 面向 | Vanilla JS | Flutter Web |
|------|-----------|------------|
| 開發語言 | JavaScript | Dart |
| 樣式系統 | CSS | Flutter Material / Cupertino |
| 狀態管理 | 手寫 JS 邏輯 | Provider + ChangeNotifier |
| DOM 操作 | 直接操作 DOM | Widget Tree |
| 拖曳實現 | HTML5 Drag & Drop API | Draggable + DragTarget Widget |
| 本地存儲 | localStorage API | shared_preferences |
| 構建輸出 | 單一 HTML + JS 文件 | Web 應用（HTML + JS bundle） |
| 打包複雜度 | 低 | 中（Dart toolchain） |

---

## 2. Flutter 專案結構設計

### 專案根目錄結構
```
tech-vibe/
├── pubspec.yaml                 # 依賴管理
├── pubspec.lock                 # 版本鎖定
├── web/                         # Web 特定資源
│   ├── index.html               # 主 HTML 入口
│   ├── favicon.ico
│   └── manifest.json            # PWA 配置
├── lib/
│   ├── main.dart                # 應用入口
│   ├── app.dart                 # App Widget
│   ├── models/
│   │   ├── task_model.dart      # Task 數據模型
│   │   └── app_state.dart       # 全局應用狀態
│   ├── providers/
│   │   └── task_provider.dart   # 任務狀態管理
│   ├── screens/
│   │   └── home_screen.dart     # 主畫面
│   ├── widgets/
│   │   ├── task_pool.dart       # 待放置任務區
│   │   ├── day_container.dart   # 一日容器
│   │   ├── task_block.dart      # 任務區塊
│   │   ├── task_creation.dart   # 任務建立區
│   │   └── reference_lines.dart # 參考線
│   └── utils/
│       ├── constants.dart       # 常數定義
│       ├── storage.dart         # 本地存儲邏輯
│       └── colors.dart          # 顏色主題
├── analysis_options.yaml        # Lint 配置
├── .github/
│   └── workflows/
│       └── deploy.yml           # GitHub Pages 自動部署
└── README.md
```

### 核心文件內容概要

#### `pubspec.yaml` 結構
```yaml
name: tech_vibe
description: 一日時間視覺化工具 - Flutter Web 版本

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0           # 狀態管理
  shared_preferences: ^2.0.0 # 本地存儲
  intl: ^0.18.0              # 日期/時間本地化

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_linter: ^2.0.0
```

#### 主要 Dart 文件職責

| 文件 | 職責 | 關鍵內容 |
|------|------|--------|
| `models/task_model.dart` | Task 數據結構 | 任務名稱、時長、拖曳狀態、序列化 |
| `providers/task_provider.dart` | 狀態管理邏輯 | 增刪改任務、拖入/拖出容器 |
| `screens/home_screen.dart` | UI 布局主體 | 二分欄設計（左：任務池 + 建立區；右：容器 + 參考線） |
| `widgets/task_block.dart` | 可拖曳的任務區塊 | Draggable Widget 包裝 |
| `widgets/day_container.dart` | 拖曳目標區域 | DragTarget Widget 實現 |
| `utils/storage.dart` | 持久化邏輯 | shared_preferences 讀寫，JSON 序列化 |

---

## 3. 開發階段拆分（Flutter 特定流程）

### Phase 0: 環境與依賴準備
**里程碑**：Flutter 環境就緒，依賴安裝完成

**任務**：
1. [ ] 確認 Flutter SDK 版本 ≥ 3.0.0
2. [ ] 初始化 Flutter Web 專案結構（如需要調整）
3. [ ] 執行 `flutter pub get`
4. [ ] 確認 `flutter run -d chrome` 可正常啟動
5. [ ] 設置 GitHub Pages 部署流程

**輸出物**：
- 可執行的 dev 環境
- `pubspec.lock` 已生成

### Phase 1: 數據模型與狀態管理
**里程碑**：核心數據模型完成，狀態管理框架就緒

**任務**：
1. [ ] 定義 `Task` 模型
   - 字段：`id`、`name`、`duration`（以小時為單位）、`isInContainer`
   - 實現 `toJson()` / `fromJson()` 用於序列化
2. [ ] 實現 `TaskProvider`（使用 ChangeNotifier）
   - 方法：`addTask()`、`removeTask()`、`moveTaskToContainer()`、`moveTaskOutOfContainer()`、`loadFromStorage()`、`saveToStorage()`
3. [ ] 設置 `shared_preferences` 持久化邏輯
4. [ ] 編寫單元測試：數據模型、Provider 邏輯

**輸出物**：
- `lib/models/task_model.dart`
- `lib/providers/task_provider.dart`
- `lib/utils/storage.dart`
- 模型與邏輯的單元測試

### Phase 2: UI 基礎組件與布局
**里程碑**：靜態 UI 框架完成，可視化層次清晰

**任務**：
1. [ ] 建立 `HomeScreen` 主畫面
   - 二分欄布局（左側：任務建立 + 任務池；右側：一日容器 + 參考線）
2. [ ] 實現 `TaskCreationWidget`
   - 任務名稱輸入框
   - 時長下拉選單（0.5、1、1.5、2、3、4 小時）
   - 「新增」按鈕
3. [ ] 實現 `TaskBlock` Widget
   - 顯示任務名稱和時長
   - 計算高度（基於 24 小時容器的比例）
   - 基本樣式（邊框、背景色、陰影）
4. [ ] 實現 `TaskPoolWidget`
   - 網格或列表顯示待放置任務
   - 配合 Draggable 實現視覺回饋
5. [ ] 實現 `DayContainerWidget`
   - 固定高度（24 小時視覺化）
   - 溢出允許（overflow: visible）
   - 背景/邊框樣式

**輸出物**：
- `lib/screens/home_screen.dart`
- `lib/widgets/task_creation.dart`
- `lib/widgets/task_block.dart`
- `lib/widgets/task_pool.dart`
- `lib/widgets/day_container.dart`
- `lib/utils/constants.dart`（常數：容器高度、顏色、時長選項）

### Phase 3: 拖曳與互動機制
**里程碑**：完整的拖曳功能，UI 響應式更新

**任務**：
1. [ ] 實現 `Draggable<Task>` 包裝
   - 包裹 TaskBlock Widget
   - 拖曳開始/結束時的視覺回饋
   - 配置 feedback Widget（拖曳時跟隨光標的預覽）
2. [ ] 實現 `DragTarget<Task>` 目標區域
   - DayContainer 中接收 Task
   - 驗證（檢查是否已在容器中，避免重複）
   - 成功接收後觸發 Provider 狀態更新
3. [ ] 實現返回拖曳（從容器拖回任務池）
   - TaskBlock 在 DayContainer 內也須是 Draggable
   - 目標區域可以是 TaskPoolWidget 或外部空白區域
4. [ ] 刪除功能
   - TaskBlock 上的刪除按鈕
   - 觸發 `removeTask()` 邏輯
5. [ ] 測試拖曳流程
   - 無衝突的多次拖曳
   - 邊界情況（空容器、滿容器）

**輸出物**：
- 更新 `lib/widgets/task_block.dart`（加入 Draggable）
- 更新 `lib/widgets/day_container.dart`（加入 DragTarget）
- 更新 `lib/widgets/task_pool.dart`（加入拖曳目標）
- 互動邏輯測試

### Phase 4: 本地存儲與數據持久化
**里程碑**：重新整理後數據保持

**任務**：
1. [ ] 連接 `shared_preferences`
   - 初始化時從存儲讀取任務列表
   - 任務列表修改時自動保存
2. [ ] 實現 JSON 序列化/反序列化
   - Task.toJson() 與 Task.fromJson()
   - 列表的序列化
3. [ ] 應用啟動時加載數據
   - 在 `main()` 或 App Widget 初始化時調用
4. [ ] 測試數據持久化
   - 添加任務 → 刷新頁面 → 數據仍存在

**輸出物**：
- 更新 `lib/providers/task_provider.dart`
- 完整的 `lib/utils/storage.dart`
- 持久化測試

### Phase 5: 參考線與視覺優化
**里程碑**：UI 視覺完整，用戶體驗優化

**任務**：
1. [ ] 實現 `ReferenceLines` 組件
   - 在 DayContainer 右側顯示：「8 小時」、「16 小時」、「24 小時」
   - 水平參考線標記
   - 文字標籤定位
2. [ ] 顏色主題與樣式
   - 定義統一的顏色方案
   - TaskBlock 不同顏色區分（可使用隨機或固定色板）
   - 容器、按鈕、文本的一致性設計
3. [ ] 響應式布局調整
   - 確保在不同螢幕尺寸下可用
   - 移動端友好性（觸控拖曳）
4. [ ] 動畫與過渡
   - 任務移動的過渡動畫
   - 刪除時的淡出動畫（可選）

**輸出物**：
- `lib/widgets/reference_lines.dart`
- 更新 `lib/utils/colors.dart` 與主題定義
- 更新各 Widget 的樣式和動畫

### Phase 6: 測試與優化
**里程碑**：功能完整，性能達標

**任務**：
1. [ ] 集成測試
   - 完整的使用流程測試
   - 邊界情況驗證
2. [ ] 性能優化
   - 檢查不必要的重建（使用 `const`）
   - 大列表情況下的效能表現
3. [ ] Lint 與代碼品質
   - 執行 `flutter analyze`
   - 修正警告
4. [ ] 瀏覽器兼容性測試
   - Chrome、Firefox、Safari

**輸出物**：
- 集成測試代碼
- 性能報告
- Lint clean

### Phase 7: 部署與文檔
**里程碑**：應用上線，文檔完整

**任務**：
1. [ ] 構建生產版本
   - `flutter build web --release`
   - 生成 `build/web/` 輸出
2. [ ] GitHub Pages 配置
   - 確保 Actions Workflow 正確
   - 自動部署到 `gh-pages` 分支
3. [ ] 驗證在線可訪問性
   - 打開 GitHub Pages URL
   - 測試核心功能
4. [ ] 編寫 README
   - 項目說明
   - 開發指南
   - 部署說明

**輸出物**：
- `build/web/` 已部署
- GitHub Pages 正常服務
- 完整的 README.md

---

## 4. Flutter 關鍵技術決策點

### 4.1 拖曳實現（Draggable / DragTarget）

**決策**：使用 Flutter 原生 `Draggable<Task>` + `DragTarget<Task>`

**為什麼**：
- 無需依賴第三方包
- 跨平台一致（Web、Mobile）
- 提供完整的拖曳生命週期回調

**實現概要**：
```dart
// TaskBlock 組件
Draggable<Task>(
  data: task,
  feedback: CustomTaskBlockFeedback(task),  // 拖曳時跟隨光標
  childWhenDragging: Opacity(opacity: 0.5, child: originalWidget),
  child: TaskBlockWidget(task),
);

// DayContainer 中的 DragTarget
DragTarget<Task>(
  onWillAccept: (task) => !isTaskAlreadyInContainer(task),
  onAccept: (task) => provider.moveTaskToContainer(task),
  builder: (context, candidateData, rejectedData) {
    return Container(/* ... */);
  },
);
```

**注意事項**：
- Draggable 不能嵌套（TaskBlock 在容器內需使用包裝的 Widget 重新變成 Draggable）
- DragTarget 的 `onAccept` 才是確認收納，`onWillAccept` 用於視覺預覽

### 4.2 狀態管理（Provider）

**決策**：使用 `provider` 包管理全局應用狀態

**為什麼**：
- 官方推薦，生態成熟
- 相比 Bloc 學習曲線平緩
- 足以支撐 MVP 複雜度

**結構**：
```dart
class TaskProvider extends ChangeNotifier {
  List<Task> _allTasks = [];
  Set<String> _tasksInContainer = {};

  // 公開接口
  List<Task> get tasksInPool => _allTasks.where((t) => !_tasksInContainer.contains(t.id)).toList();
  List<Task> get tasksInContainer => _allTasks.where((t) => _tasksInContainer.contains(t.id)).toList();

  void addTask(String name, double duration) {
    _allTasks.add(Task(id: uuid(), name: name, duration: duration));
    notifyListeners();
    _saveToStorage();
  }

  void moveTaskToContainer(Task task) {
    if (!_tasksInContainer.contains(task.id)) {
      _tasksInContainer.add(task.id);
      notifyListeners();
      _saveToStorage();
    }
  }
}
```

**注意事項**：
- 避免過度細粒度的 Provider（防止頻繁重建）
- 使用 `Selector` 優化 Widget 訂閱

### 4.3 本地存儲（shared_preferences for Web）

**決策**：使用 `shared_preferences` for web

**為什麼**：
- Dart 官方支持的跨平台解決方案
- Web 端底層使用 `localStorage`
- API 簡潔，易於 JSON 序列化

**實現概要**：
```dart
// storage.dart
class StorageService {
  static const _tasksKey = 'tasks_list';
  static const _containerKey = 'container_tasks';

  static Future<void> saveTasks(List<Task> tasks, Set<String> inContainer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _tasksKey,
      jsonEncode(tasks.map((t) => t.toJson()).toList()),
    );
    await prefs.setStringList(_containerKey, inContainer.toList());
  }

  static Future<Map<String, dynamic>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    // 反序列化邏輯...
  }
}
```

**注意事項**：
- Web 端 `shared_preferences` 會拋出例外，需要特殊初始化
- JSON 序列化時需確保 Task 模型的完整性

### 4.4 數據模型設計

**Task 模型字段**：
```dart
class Task {
  final String id;           // UUID
  final String name;         // 任務名稱
  final double duration;     // 時長（小時）
  final DateTime createdAt;  // 建立時間（便於排序）

  Task({
    required this.id,
    required this.name,
    required this.duration,
    required this.createdAt,
  });

  // JSON 序列化
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'duration': duration,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    name: json['name'] as String,
    duration: json['duration'] as double,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
```

### 4.5 可視化與響應式設計

**決策**：使用 Flutter 的 `LayoutBuilder` 和 `MediaQuery` 實現響應式

**容器高度計算**：
```dart
// 假設 24 小時 = 500 邏輯像素
const double CONTAINER_HEIGHT_FOR_24_HOURS = 500.0;
const double TOTAL_HOURS = 24.0;

double calculateTaskHeight(double durationHours) {
  return (durationHours / TOTAL_HOURS) * CONTAINER_HEIGHT_FOR_24_HOURS;
}
```

**布局結構**：
```dart
// HomeScreen 使用 Row 實現二分欄
Row(
  children: [
    Expanded(
      flex: 1,
      child: Column(
        children: [
          TaskCreationWidget(),
          Expanded(child: TaskPoolWidget()),
        ],
      ),
    ),
    Expanded(
      flex: 1,
      child: Column(
        children: [
          Expanded(child: DayContainerWithReferences()),
        ],
      ),
    ),
  ],
);
```

---

## 5. 實作順序與依賴關係

### 依賴圖（由下至上）

```
層級 7: 部署與文檔
    └─ Phase 7

層級 6: 測試與優化
    └─ Phase 6

層級 5: 視覺優化
    └─ Phase 5
         ↑
層級 4: 持久化
    └─ Phase 4
         ↑
層級 3: 互動與拖曳
    └─ Phase 3
         ↑
層級 2: UI 基礎組件
    └─ Phase 2
         ↑
層級 1: 狀態管理
    └─ Phase 1
         ↑
層級 0: 環境準備
    └─ Phase 0
```

### 關鍵路徑（最短實現 MVP）

1. **Phase 0**: Flutter 環境就緒 → Phase 1
2. **Phase 1**: Task 模型 + TaskProvider → Phase 2
3. **Phase 2**: UI 布局 + TaskBlock → Phase 3
4. **Phase 3**: Draggable/DragTarget 交互 → **可交付 MVP v1**
5. Phase 4: 數據持久化 → **MVP v1.1（帶存儲）**
6. Phase 5+: 優化與部署 → **生產版本**

### 內部任務依賴

| Phase | 依賴 | 原因 |
|-------|------|------|
| 1 | 0 | 需要 pubspec.yaml 和依賴安裝 |
| 2 | 1 | TaskProvider 是 UI 數據源 |
| 3 | 2 | 基礎 UI 才能加入拖曳邏輯 |
| 4 | 3 | 互動完成後才能持久化 |
| 5 | 4 | 完整功能後進行視覺優化 |
| 6 | 5 | 功能完整才能進行測試 |
| 7 | 6 | 測試通過後部署 |

---

## 6. 與 Vanilla JS 版本的主要差異說明

### 6.1 開發工作流

| 方面 | Vanilla JS | Flutter Web |
|------|-----------|------------|
| **開發環境** | 任意文本編輯器 + 瀏覽器 | Flutter SDK + IDE |
| **熱重載** | 瀏覽器刷新 | `flutter run -d chrome` 支持熱重載（更快） |
| **調試** | Chrome DevTools | Dart DevTools + Chrome DevTools |
| **構建** | 無需構建（直接 HTML） | `flutter build web` 編譯為 JS 和 WASM |
| **依賴管理** | npm 或手動引入 | pubspec.yaml + `flutter pub` |

### 6.2 代碼組織差異

#### Vanilla JS 例子
```javascript
// task.js
class Task {
  constructor(name, duration) {
    this.id = uuid();
    this.name = name;
    this.duration = duration;
  }
}

// app.js
const tasks = [];
function addTask(name, duration) {
  tasks.push(new Task(name, duration));
  render();
}

function render() {
  // 直接修改 DOM
  document.getElementById('pool').innerHTML = tasks.map(t => `<div>${t.name}</div>`).join('');
}
```

#### Flutter Web 例子
```dart
// models/task_model.dart
class Task {
  final String id;
  final String name;
  final double duration;

  Task({required this.id, required this.name, required this.duration});
}

// providers/task_provider.dart
class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  void addTask(String name, double duration) {
    _tasks.add(Task(id: uuid(), name: name, duration: duration));
    notifyListeners(); // 通知 UI 更新
  }
}

// widgets/task_block.dart → UI 自動重建
```

### 6.3 互動實現差異

#### Vanilla JS（HTML5 Drag & Drop）
```javascript
// HTML5 原生 API
element.addEventListener('dragstart', (e) => {
  e.dataTransfer.effectAllowed = 'move';
  e.dataTransfer.setData('task-id', task.id);
});

dropZone.addEventListener('dragover', (e) => {
  e.preventDefault();
  e.dataTransfer.dropEffect = 'move';
});

dropZone.addEventListener('drop', (e) => {
  const taskId = e.dataTransfer.getData('task-id');
  addTaskToContainer(taskId);
});
```

#### Flutter Web（Widget-based）
```dart
Draggable<Task>(
  data: task,
  feedback: TaskBlockFeedback(task),
  child: TaskBlock(task),
)

DragTarget<Task>(
  onAccept: (task) {
    provider.moveTaskToContainer(task);
  },
  builder: (context, candidateData, rejectedData) {
    return Container(/* ... */);
  },
)
```

**優勢對比**：
- JS：底層控制細緻，但代碼繁瑣
- Flutter：高層抽象，代碼簡潔，跨平台一致

### 6.4 狀態管理差異

| 方面 | Vanilla JS | Flutter (Provider) |
|------|-----------|-----------------|
| **全局狀態** | 全局變數或簡單物件 | ChangeNotifier + Provider |
| **更新通知** | 手動調用 `render()` | 自動 Widget 訂閱與重建 |
| **複雜性** | 低（MVP） → 高（擴展） | 中等（一致性好） |
| **測試** | Mock 全局變數 | Mock Provider，單元測試清晰 |

### 6.5 存儲實現差異

#### Vanilla JS
```javascript
// 直接操作 localStorage
localStorage.setItem('tasks', JSON.stringify(tasks));
const loaded = JSON.parse(localStorage.getItem('tasks') || '[]');
```

#### Flutter Web
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString('tasks', jsonEncode(tasks.map((t) => t.toJson()).toList()));

final json = prefs.getString('tasks');
final loaded = (jsonDecode(json) as List).map((t) => Task.fromJson(t)).toList();
```

**差異**：Flutter 官方模式更結構化，序列化通過 Model 層統一管理。

### 6.6 樣式與主題差異

#### Vanilla JS（CSS）
```css
/* style.css */
.task-block {
  height: calc(var(--duration) * 20px);
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 8px;
}
```

#### Flutter（Material 設計）
```dart
Container(
  height: calculateTaskHeight(task.duration),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  child: /* ... */,
)
```

**差異**：
- JS：CSS 檔案分離，樣式與邏輯解耦
- Flutter：樣式在 Widget 中定義（文件統一，類型安全）

### 6.7 部署與輸出差異

| 方面 | Vanilla JS | Flutter Web |
|------|-----------|------------|
| **輸出文件** | index.html + style.css + script.js | build/web/ （包含 HTML、JS bundle、資源） |
| **大小** | 通常 < 100KB | 初始 ~ 3-5MB（Dart VM 相關） |
| **構建時間** | 無（即開發即上線） | 需要編譯（1-2分鐘） |
| **優化** | 手動 | `--release` flag 自動壓縮 |
| **瀏覽器兼容** | IE 11+ | 現代瀏覽器（需 WebGL/WASM） |

**建議**：
- Vanilla JS：開發快速，交付簡單，但長期維護複雜
- Flutter：初期投入高，但可擴展性好，跨平台一致

---

## 7. 實作檢查清單

### 前置準備
- [ ] Flutter SDK ≥ 3.0.0 安裝完成
- [ ] VS Code / Android Studio 配置好 Flutter 插件
- [ ] 確認 `flutter doctor` 無 Web 相關警告

### Phase 0 檢查點
- [ ] 專案目錄結構如上述建立
- [ ] `pubspec.yaml` 依賴版本確認
- [ ] `flutter pub get` 成功執行
- [ ] `flutter run -d chrome` 啟動無誤

### Phase 1 檢查點
- [ ] Task 模型完整（所有序列化方法）
- [ ] TaskProvider 方法覆蓋完整
- [ ] 單元測試編寫並通過

### Phase 2 檢查點
- [ ] HomeScreen 布局清晰，二分欄生效
- [ ] TaskCreationWidget 輸入和選擇功能正常
- [ ] TaskBlock 高度計算正確
- [ ] TaskPoolWidget 和 DayContainerWidget 顯示無誤

### Phase 3 檢查點
- [ ] Draggable/DragTarget 可拖曳
- [ ] 視覺回饋（feedback、childWhenDragging）正常
- [ ] 各方向拖曳（池 → 容器、容器 → 池、容器內排序）都支持
- [ ] 刪除按鈕功能完整

### Phase 4 檢查點
- [ ] shared_preferences 初始化正常
- [ ] 任務保存與加載成功
- [ ] 刷新頁面後數據仍存在

### Phase 5 檢查點
- [ ] ReferenceLines 顯示在正確位置
- [ ] 顏色主題統一，視覺美觀
- [ ] 響應式布局在不同螢幕尺寸工作

### Phase 6 檢查點
- [ ] 集成測試覆蓋主要流程
- [ ] `flutter analyze` 無誤
- [ ] 瀏覽器測試（Chrome、Firefox、Safari）通過

### Phase 7 檢查點
- [ ] `flutter build web --release` 構建成功
- [ ] GitHub Pages 自動部署配置完成
- [ ] 在線 URL 可訪問並功能完整
- [ ] README.md 文檔完整

---

## 8. 技術參考與資源

### 官方文檔
- [Flutter for Web](https://flutter.dev/web)
- [Provider 包](https://pub.dev/packages/provider)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [Draggable & DragTarget](https://api.flutter.dev/flutter/widgets/Draggable-class.html)

### 最佳實踐
- 使用 `const` 修飾不變的 Widget，優化重建
- 避免 `setState()`，統一用 Provider 管理狀態
- 編寫可測試的 Model 和 Provider 邏輯
- Web 端特殊考慮：URL routing（如需）、鍵盤快捷鍵支持

### 常見問題
1. **shared_preferences 在 Web 端拋出錯誤**
   - 原因：初始化時間點不對
   - 解決：確保在 `main()` 中 `await SharedPreferences.getInstance()` 後再啟動 App

2. **Draggable 在 DragTarget 內無法工作**
   - 原因：嵌套 Draggable
   - 解決：使用包裝 Widget 或重新設計層級

3. **拖曳後 UI 未更新**
   - 原因：未調用 `notifyListeners()`
   - 解決：確保 Provider 方法末尾都有呼叫通知

---

## 9. 預期時程估算

| Phase | 預計天數 | 說明 |
|-------|--------|------|
| 0 | 0.5 | 環境檢查，快速 |
| 1 | 1-2 | 模型和邏輯，相對獨立 |
| 2 | 2-3 | UI 組件眾多，調整反覆 |
| 3 | 2-3 | 拖曳邏輯複雜度高 |
| 4 | 1 | 存儲相對簡單 |
| 5 | 1-2 | 視覺優化，時程浮動 |
| 6 | 1-2 | 測試和 Lint 修復 |
| 7 | 0.5 | 部署配置 |
| **總計** | **9-15 天** | MVP 開發週期 |

---

## 總結

本計畫詳細規劃了使用 **Flutter Web + Dart** 開發「一日時間視覺化工具」的完整路徑。相比 Vanilla JS 版本：

- **優勢**：跨平台一致性、熱重載加速開發、狀態管理清晰、長期可維護性好
- **挑戰**：學習曲線（Dart + Flutter 生態）、初始編譯時間、輸出包體積較大

通過分階段實現，從基礎模型 → UI 組件 → 互動邏輯 → 持久化 → 優化 → 部署，確保每個階段都有可交付的成果。團隊可根據實際進度調整各 Phase 的工作量。
