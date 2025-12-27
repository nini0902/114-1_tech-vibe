# 部署指南

## 自動部署到 GitHub Pages

此專案已設定自動部署工作流程。

### 流程說明

1. **推送到 main 或 master 分支** - GitHub Actions 會自動觸發
2. **Flutter Web 構建** - 使用 `flutter build web --release`
3. **發佈到 GitHub Pages** - 自動推送到 `gh-pages` 分支

### 部署狀態

查看工作流程狀況：
- GitHub Repository → Actions → "部署到 GitHub Pages"

### 本地測試

```bash
# 構建 Web 版本
flutter build web --release

# 在本地運行（需要 Flutter）
flutter run -d chrome
```

### 環境變數設置

#### 後端 API（可選）

如果需要啟用 AI 功能（任務分解），設定以下環境變數：

```env
HUGGING_FACE_API_TOKEN=your_token_here
HUGGING_FACE_MODEL=flan-t5-base
```

後端使用 Node.js/Python 部署時需配置這些變數。

### GitHub Pages 設置

1. 進入 Repository Settings
2. 找到 "Pages" 部分
3. 確認 Source 設為 "Deploy from a branch"
4. 選擇 `gh-pages` 分支
5. 儲存設定

您的網站將在以下位置：
`https://nini0902.github.io/114-1_tech-vibe/`

---

**上次更新**：2025-12-27
