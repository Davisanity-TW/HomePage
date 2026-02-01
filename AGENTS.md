# AGENTS.md — HomePage

This repo builds **HomePage**: David 的網站入口（索引頁），用 VitePress 部署到 GitHub Pages。

## 目標（What this repo is for）
- 提供單一入口，連到其他站（stock_report / moltbook / MinIO_SourceCodeReading…）。
- 在首頁維護「目前排程中的自動工作（Cron Jobs）」清單（**Asia/Taipei** 時區）。

## 重要路徑（Key paths）
- `docs/index.md`：首頁內容（所有人會看到的清單/說明）
- `docs/.vitepress/config.mts`：VitePress 設定（nav/sidebar/base）
- `package.json`：VitePress scripts
- `.github/workflows/deploy.yml`：GitHub Pages 部署

## 常用命令（Commands）
```bash
cd /home/ubuntu/clawd/homepage

# 本機開發（在機器上提供預覽）
npm run docs

# 建置（部署前可先跑一次確認不爆）
npm run build

# 產物預覽
npm run serve
```

## 產出規範（Output conventions）
- 文案語言：繁體中文（zh-Hant）。
- 排程時間：一律以 **Asia/Taipei** 標示（避免 UTC 混淆）。
- 首頁內容以「清單 + 短描述」為主，避免放太長的 log 或 raw data。
- 連結盡量用完整 URL。

## 禁止事項（Do not）
- 不要把任何 secrets / token 寫進 repo（例如 GitHub token、API key）。
- 不要在首頁貼出內網 IP、機器帳號、或任何可能被用來入侵的細節。
- 不要更動 `base` 或路徑結構，除非你確定 GitHub Pages 的 URL 同步會改。

## 變更流程（Working agreement）
- 修改 `docs/index.md` 後：先 `npm run build` 確認 OK，再 commit。
- 若需要 push 到 GitHub：請在不確定時描述變更並請人類確認（尤其是大改版/大範圍重構）。
