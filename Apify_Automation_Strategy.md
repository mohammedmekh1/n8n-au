# 🚀 SaaSAI Apify Automation Strategy (Optimized & Budget-Friendly)

## 🎯 Goal
Scrape fresh leads from Facebook, Instagram, TikTok, and X within the last 24-48 hours while maintaining a monthly budget of **$25-$35**.

---

## 🛠️ Platform & Actor Selection

| Platform | Recommended Actor (Apify Store) | Focus | Cost Strategy |
|----------|---------------------------------|-------|---------------|
| **Facebook** | `apify/facebook-groups-scraper` | Groups & Pages | Use `recent` sort, limit to 20 posts/group. |
| **Instagram** | `apify/instagram-hashtag-scraper` | Hashtags | Scrape `top` & `recent`. Limit results to 30 per tag. |
| **TikTok** | `apify/tiktok-scraper` | Profiles & Keywords | Targeted search, limit to last 24h upload date. |
| **X (Twitter)** | `apify/twitter-scraper-lite` | Keywords | Search with `until_time` and `since_time`. |

---

## 💰 Budget Management ($25 - $35/mo)
*   **Daily Budget:** ~$0.83 - $1.16.
*   **Frequency:** Run once every 24 hours (8 AM Riyadh).
*   **Optimization:**
    *   Use **Lite** versions of actors where available.
    *   Set `maxItems` per run (e.g., 50 per platform/keyword).
    *   Enable **Proxy: Residential** only when necessary (it costs more). Use **Datacenter** proxies for X and TikTok if possible.

---

## 📈 Scalability: Handling Hundreds of Keywords
Instead of hardcoding keywords in n8n, we use a dedicated Google Sheet tab: `radar_config`.

### Structure of `radar_config` tab:
| target_type | value | status | priority |
|-------------|-------|--------|----------|
| fb_group    | https://facebook.com/groups/automation | active | high |
| ig_hashtag  | #automation_ksa | active | medium |
| tw_search   | "أريد أتمتة أعمالي" | active | high |

---

## 🔄 Freshness Logic (24-48h)
*   **X (Twitter):** Search query: `"keyword" since:2026-05-02`.
*   **Facebook:** Actor parameter `onlyNewerThan`: `24h`.
*   **Instagram:** Filter by `timestamp` in the post-processing Code node in n8n.
*   **TikTok:** Use `publishTime` filter in Actor settings.

---

## ✅ Implementation in SaaSAI F1
1.  **Node: `GSheets – Get Keywords`**: Replaces the static Config node.
2.  **Node: `Loop Over Targets`**: Iterates through URLs/Keywords from the sheet.
3.  **Node: `Apify Run Actor`**: Dynamically passes the URL/Keyword.
4.  **Node: `Filter – 24h`**: Ensures no old data enters the AI Analysis node.
