# HomePage

這裡是 David 的「網站入口」— 統一收納我目前與未來建立的各種網站。

## 現有網站
- MinIO Source Code Reading：<https://davisanity-tw.github.io/MinIO_SourceCodeReading/>
- Stock Report（研究日誌）：<https://davisanity-tw.github.io/stock_report/>
- Moltbook Digests：<https://davisanity-tw.github.io/moltbook/>
- Furniture Purchase Web（傢俱採購清單）：<https://furniturepurchaseweb.vercel.app/items>

## Understand-Anything（OpenClaw：程式碼理解工具）
這是一組 OpenClaw skills，用來把「目前所在的 repo/codebase」建立成可問答的 knowledge graph。

### 怎麼用（3 個指令）
- `@understand`：分析目前 codebase（建立/更新理解結果）
- `@understand-chat`：對 knowledge graph 提問（例如：入口點、呼叫關係、模組責任、某段邏輯在哪裡）
- `@understand-dashboard`：開啟互動式 dashboard（用 UI 瀏覽/查詢）

### 使用小提醒
- 你在哪個 repo 的上下文/工作目錄呼叫，它就會分析哪個 repo。
- 如果你剛 pull 更新過程式碼，建議先再跑一次 `@understand` 讓圖譜同步。

## 股癌週報：摘要更新（給 Clawdbot 的固定 Prompt）
把你整理好的「股癌」節目摘要（你要我原文照貼的版本）更新到：
<https://davisanity-tw.github.io/stock_report/reports/guai/>

**請直接複製這段 Prompt 使用：**

> 把你整理好的「股癌」節目摘要（你要我原文照貼的版本）更新到：
> <https://davisanity-tw.github.io/stock_report/reports/guai/>
> 
> 請直接複製這段 Prompt 使用：
> 
> 幫我把以下內容「一字不漏」更新到股癌週報，並用 Markdown 做「加粗/放大」的可讀性排版（不得改寫、不得刪字、不得補字，只能加上 Markdown 標記）。
> 
> 排版規則（很重要）：
> - 檔案內的「當日區塊」用二級標題：## 2026-mm-dd（不要在日期後面加星期幾）
> - 這集的主標題用一級標題：# EPxxx / xx月xx日
> - 章節標題（例如 1. 市場概況 / 2. 關注的股票 / 3. 其他... / 4. Q&A）用二級標題：##
> - 每一點的小標題要加粗：凡是出現 小標題： 這種格式（行尾是全形冒號 ：），請把「冒號前的文字 + 冒號」整段加粗，例如：
>   - 震盪盤勢下的心理挑戰： → **震盪盤勢下的心理挑戰：**
>   - 油價作為關鍵觀察指標： → **油價作為關鍵觀察指標：**
>   - VIX 指標的買入邏輯： → **VIX 指標的買入邏輯：**
>   - （注意：只加粗，不要改任何字、空格、標點）
> 
> 更新位置必須是：stock_report repo 的 reports/guai/yyyy-Wxx.md
> 並同步到：docs/reports/guai/yyyy-Wxx.md
> 並推到 GitHub Pages
> 
> - 週次檔案：2026-Wxx（請依我提供的週次）
> - 日期：2026-mm-dd
> - 標題：EPxxx / xx月xx日
> - 內容：
> 
> （把摘要全文貼在這裡，包含所有段落與編號；不要省略）
> 
> 如果 Clawdbot 沒有更新到正確位置 請你提醒他：你要更新的是「股癌」頁：
> <https://davisanity-tw.github.io/stock_report/reports/guai/2026-W09.html>
> 不是 finance_news。

---

## 家具/家電採購清單：快速新增（給 Clawdbot 的固定 Prompt）
以後你只要照下面格式丟給 Clawdbot，我就會用 Edge Function API 幫你把項目新增到清單。

**請直接複製這段 Prompt 使用：**

> 幫我把這個項目加入家具/家電採購清單。
> 
> - 商品名稱：<必填>
> - 類別：<必填>
> - 價格：<必填，數字>
> - 網址：<必填>
> - 空間(room)：客廳｜廚房｜電腦房｜小房間｜主臥室｜浴室（不填就用「客廳」）
> - 狀態(status)：candidate｜want｜decided｜purchased（不填就用「candidate」）

### 如果 Clawdbot 一時無法認得這個 Prompt
請把下面這段內容貼給他，讓他回想起來要用哪個 API，以及你需要提供 `TELEGRAM_INGEST_SECRET` 才能成功新增：

```bash
curl -L -X POST 'https://whjkvgjihtnvcgtsygst.supabase.co/functions/v1/telegram-add-item' \
  -H 'Authorization: Bearer sb_publishable_WkbLn0NqaCpoGmmD0ybqsA_pqdRZjqb' \
  -H 'apikey: sb_publishable_WkbLn0NqaCpoGmmD0ybqsA_pqdRZjqb' \
  -H 'Content-Type: application/json' \
  --data '{"name":"Functions"}'
```

> 註：實際呼叫時，需要額外提供 `TELEGRAM_INGEST_SECRET`（Edge Functions Secrets 中設定的那個明文值）。

## 排程中的自動工作（Cron Jobs）
> 時區：Asia/Taipei
> 最後更新：2026-09-25
> 目前共 19 個：啟用 6 個、停用 13 個

### 啟用中（最新）

> 規則總表（我必須遵守的工作規則）：[/rules](/rules)
- **US close cache + weekly git log (merged)**：週二～週六 **06:28**
- **Finance news quick digest (5h, TW only) -> Telegram + site (08 Taipei)**：每天 **08:00**
- **TW close report -> Telegram + stock_report (merged shell)**：週一～週五 **17:12**
- **YT yutinghao summary script (16:00 Taipei)**：週一～週五 **16:00**
- **Furniture purchase Supabase weekly backup -> local + Telegram**：週日 **09:00**
- **Supabase keepalive SQL query (every 5 days)**：每 **5** 天

### 目前停用（保留設定）
- **TW close market report (David)**：週一～週五 **13:40**
- **US close market report (David)**：週一～週五 **06:35**
- **TW report -> weekly git log (David)**：週一～週五 **13:45**
- **TW report -> weekly git log (15:05)**：週一～週五 **15:05**
- **YT yutinghao summary (11:10 Taipei)**：週一～週五 **11:10**
- **TEMP Iran-US war news scan (08:30/10:30/16:30/20:30 Taipei) -> Telegram (David)**：每天 **08:30 / 10:30 / 16:30 / 20:30**
- **US close send 06:35 (David)**：週二～週六 **06:35**
- **US report -> weekly git log (David)**：週二～週六 **06:40**
- **DISABLED - TW close prep (merged into 17:12 shell)**：週一～週五 **15:50**
- **TW close send 16:00 (David)**：週一～週五 **16:00**
- **DISABLED - TW insti refresh (merged into 17:12 shell)**：週一～週五 **16:55**
- **WTXP& 台指期盤後行情 (21:40 Taipei) -> Telegram**：週一～週五 **21:40**
- **Keep Supabase awake - furniturepurchaseweb**：每天 **08:20**

## AGENTS.md 共用模板
- 這裡：[/agents-template](/agents-template)

## 未來網站
- （預留）
