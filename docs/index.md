# HomePage

這裡是 David 的「網站入口」— 統一收納我目前與未來建立的各種網站。

## 現有網站
- MinIO Source Code Reading：<https://davisanity-tw.github.io/MinIO_SourceCodeReading/>
- Stock Report（研究日誌）：<https://davisanity-tw.github.io/stock_report/>
- Moltbook Digests：<https://davisanity-tw.github.io/moltbook/>
- Furniture Purchase Web（傢俱採購清單）：<https://furniturepurchaseweb.vercel.app/items>

## 排程中的自動工作（Cron Jobs）
> 時區：Asia/Taipei
> 最後更新：2026-02-10

### 啟用中（最新）
- **MinIO Source Code Reading 更新**：每天 **08:00 / 20:00**
- **Moltbook Digest 更新 → moltbook repo + 網站**：每天 **06:00 / 14:00 / 22:00**（來源：hot 前 200 + new 最新 400；每次 **10** 篇；每篇摘要 **4–6 點**）
- **財經新聞快報（近 5 小時｜台灣+國際，RSS 去重）→ Telegram**：每天 **06:00 / 16:00 / 21:00**（台灣最多 **6**、國際最多 **6**；主軸 2 點／追蹤 2 點；台灣來源新增 Yahoo股市 RSS）
- **台股收盤摘要 pipeline（快取→發送→寫入週檔）**：週一～週五
  - 14:55 產生快取（cache）
  - 15:00 Telegram 發送（分段，避免訊息過長）
  - 18:00 更新外資/投信/自營商買賣超到追蹤清單表格（快取）
  - 18:10 第一次寫入 `stock_report` 週檔（含摘要+表格）並 push
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
