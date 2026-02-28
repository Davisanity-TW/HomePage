# HomePage

這裡是 David 的「網站入口」— 統一收納我目前與未來建立的各種網站。

## 現有網站
- MinIO Source Code Reading：<https://davisanity-tw.github.io/MinIO_SourceCodeReading/>
- Stock Report（研究日誌）：<https://davisanity-tw.github.io/stock_report/>
- Moltbook Digests：<https://davisanity-tw.github.io/moltbook/>
- Furniture Purchase Web（傢俱採購清單）：<https://furniturepurchaseweb.vercel.app/items>

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
> 最後更新：2026-02-25

### 啟用中（最新）
- **MinIO Source Code Reading 更新**：每天 **08:00 / 20:00**
- **Moltbook Digest 更新 → moltbook repo + 網站**：每天 **06:00 / 14:00 / 22:00**（來源：hot 前 200 + new 最新 400；每次 **10** 篇；每篇摘要 **4–6 點**）
- **財經新聞快報（近 5 小時｜台灣+國際，RSS 去重）→ Telegram**：每天 **06:00 / 16:00 / 21:00**（台灣最多 **6**、國際最多 **6**；主軸 2 點／追蹤 2 點；台灣來源新增 Yahoo股市 RSS）
- **台股收盤摘要 pipeline（快取→發送→寫入週檔）**：週一～週五
  - 16:50 產生快取，並同時更新外資/投信/自營商買賣超到追蹤清單表格（快取）
  - 17:00 Telegram 發送（分段，避免訊息過長）
  - 17:00 寫入 `stock_report` 週檔（含摘要+表格）並 push
- **美股收盤摘要 pipeline（快取→發送→寫入週檔）**：週二～週六
  - 06:28 產生快取（cache）
  - 06:35 Telegram 發送
  - 06:40 寫入 `stock_report` 週檔並 push

### 目前停用（保留設定）
- **YouTube（YT-游庭皓）摘要**：週一～週五 11:10
- 台股收盤研究摘要（13:40，週一～週五）
- 美股收盤研究摘要（06:35，週一～週五）
- 台股研究摘要 → 週檔（13:45，週一～週五）

## AGENTS.md 共用模板
- 這裡：[/agents-template](/agents-template)

## 未來網站
- （預留）
