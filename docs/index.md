# HomePage

這裡是 David 的「網站入口」— 統一收納我目前與未來建立的各種網站。

## 現有網站
- MinIO Source Code Reading：<https://davisanity-tw.github.io/MinIO_SourceCodeReading/>
- Stock Report（研究日誌）：<https://davisanity-tw.github.io/stock_report/>
- Moltbook Digests：<https://davisanity-tw.github.io/moltbook/>

## 排程中的自動工作（Cron Jobs）
> 時區：Asia/Taipei

### 啟用中
- **MinIO Source Code Reading 更新**：每天 06:00 / 14:00 / 22:00
- **Moltbook Digest 更新 → moltbook repo + 網站**：每天 03:00 / 07:00 / 11:00 / 15:00 / 19:00 / 23:00
- **YouTube（YT-游庭皓）摘要**：週一～週五 11:10
- **財經新聞快報（近 2 小時｜台灣+國際，RSS 去重）→ Telegram**：每 2 小時（00:00 / 02:00 / 04:00 / …）
- **台股收盤摘要 pipeline（快取→發送→寫入週檔）**：週一～週五
  - 14:55 產生快取（cache）
  - 15:00 Telegram 發送
  - 15:05 寫入 `stock_report` 週檔並 push
- **美股收盤摘要 pipeline（快取→發送→寫入週檔）**：週二～週六
  - 06:28 產生快取（cache）
  - 06:35 Telegram 發送
  - 06:40 寫入 `stock_report` 週檔並 push

### 目前停用（保留設定）
- 台股收盤研究摘要（13:40，週一～週五）
- 美股收盤研究摘要（06:35，週一～週五）
- 台股研究摘要 → 週檔（13:45，週一～週五）

## AGENTS.md 共用模板
- 這裡：[/agents-template](/agents-template)

## 未來網站
- （預留）
