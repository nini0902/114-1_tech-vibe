# GitHub Copilot 指令設定

## 語言設定
- 請用**繁體中文**撰寫規格文件與回答

## SpecKit Slash 指令
本專案使用來自 `.github/prompts` 的 slash 指令（以 `/speckit.` 開頭）來管理規格與開發流程。

可用指令：
- `/speckit.specify` - 撰寫或更新規格文件
- `/speckit.plan` - 根據規格建立任務清單
- `/speckit.implement` - 執行實作任務
- 其他 SpecKit 相關指令

## 工作原則
- **不要過度設計**
- **除非使用者有特別要求，否則不要建立新的 Markdown 文件來記錄變更或總結您的工作**
- 確保 git 在每個階段都有正確運行
- 確保在 implement 階段時 tasks.md 有正常打勾
- 在 implement 階段時要確認不要不小心把規格文件刪掉或覆蓋掉（尤其套用框架的模板時）
- 如果是網站專案，以前端靜態網站為主（可部署到 GitHub Pages）
