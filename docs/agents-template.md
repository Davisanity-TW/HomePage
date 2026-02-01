# AGENTS.md 共用模板

> 這份模板給「新 repo」直接套用（把 `<REPO_NAME>` 替換成實際名稱即可）。

```md
# AGENTS.md — <REPO_NAME>

一句話說明：這個 repo 用來做什麼（目標/產物/對外網址）。

## 目標（What this repo is for）
- 目標 1
- 目標 2

## 重要路徑（Key paths）
- `path/to/thing`：用途
- `docs/`：網站/文件
- `bin/`：產製腳本

## 常用命令（Commands）
```bash
# 安裝依賴
npm ci  # 或 npm install

# 開發/預覽
npm run docs

# 建置
npm run build

# 測試（如果有）
npm test
```

## 產出規範（Output conventions）
- 語言/格式：
- 時區/日期規則：
- 檔名/路徑規則：
- 生成檔案的來源（手改 vs 由腳本產生）：

## 禁止事項（Do not）
- 不要把 secrets / token / cookies commit 進 repo。
- 不要把內網資訊（IP/主機名/帳號）放到公開頁面。
- 不要改動部署路徑（例如 VitePress `base`）除非你確定 URL 也要跟著變。

## 變更流程（Working agreement）
- 小改：直接修改 → 本機 build → commit。
- 大改/會影響部署：先提出變更摘要與風險點，請人類確認後再 push。
```
