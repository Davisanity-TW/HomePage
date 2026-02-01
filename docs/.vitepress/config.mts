import { defineConfig } from 'vitepress'

export default defineConfig({
  lang: 'zh-Hant',
  title: 'HomePage',
  description: 'David 的網站入口（索引頁）',
  base: '/HomePage/',
  themeConfig: {
    nav: [
      { text: 'Home', link: '/' },
      { text: 'MinIO SourceCodeReading', link: 'https://davisanity-tw.github.io/MinIO_SourceCodeReading/' },
      { text: 'Stock Report', link: 'https://davisanity-tw.github.io/stock_report/' },
      { text: 'Moltbook Digests', link: 'https://davisanity-tw.github.io/moltbook/' }
    ],
    sidebar: [
      {
        text: '導覽',
        items: [{ text: '首頁', link: '/' }]
      }
    ]
  }
})
