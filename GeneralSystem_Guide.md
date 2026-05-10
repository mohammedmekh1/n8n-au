# 🤖 [COMPANY_NAME] – دليل المنظومة الشامل v1.0
> منصة الأتمتة الذكية الشاملة | 12 نظام متكامل

**الشيت:** `[YOUR_GOOGLE_SHEET_ID]`
**n8n:** `[YOUR_N8N_URL]`
**الموقع:** `[YOUR_WEBSITE_URL]`

---

## 🏢 خدمات [COMPANY_NAME] (10 خدمات)

| الخدمة | service_type | Webhook رئيسي |
|--------|-------------|--------------|
| أتمتة الأعمال (n8n/Make/Zapier) | `automation` | `/webhook/[COMPANY_NAME]-radar` |
| الذكاء الاصطناعي وحلول LLM | `ai_solutions` | `/webhook/[COMPANY_NAME]-scoring-entry` |
| بناء المواقع والمنصات | `web_dev` | `/webhook/lead-from-radar` |
| تحسين محركات البحث (SEO) | `seo` | `/webhook/marketing-journey` |
| تصميم الجرافيك والهوية | `design` | `/webhook/general-delivery-engine` |
| إنتاج الفيديو والموشن | `video` | `/webhook/generate-content` |
| التسويق الرقمي | `marketing` | `/webhook/general-sales-handoff` |
| كتابة المحتوى AI | `content` | `/webhook/wp-pipeline` |
| التدريب على n8n | `training` | `/webhook/[COMPANY_NAME]-scoring-entry` |
| **دعوات المناسبة خاصة الرقمية** ⭐ | `special_service` | `/webhook/[COMPANY_NAME]-special_service-order` |

---

## 📋 الأنظمة الـ 12

| # | الملف | الوظيفة | getRows |
|---|-------|---------|---------|
| F1 | `[COMPANY_NAME]_F1_Radar_Capture.json` | اصطياد Leads من السوشيال | 0 |
| F2 | `[COMPANY_NAME]_F2_Lead_Capture.json` | استقبال من 5 قنوات | 2 ✅ |
| F3 | `[COMPANY_NAME]_F3_Lead_Scoring.json` | تقييم + تصنيف الخدمة | 0 |
| F4 | `[COMPANY_NAME]_F4_Marketing_Journeys.json` | رسائل تسويق مرحلية | 1 ✅ |
| F5 | `[COMPANY_NAME]_F5_Delivery_Engine.json` | محرك الإرسال | 1 ✅ |
| F6 | `[COMPANY_NAME]_F6_Sales_Handoff.json` | تسليم للمبيعات | 3 ✅ |
| F7 | `[COMPANY_NAME]_F7_Content_Factory.json` | توليد محتوى AI يومي | 0 |
| F8 | `[COMPANY_NAME]_F8_Publisher.json` | النشر على المنصات | 1 ✅ |
| F9 | `[COMPANY_NAME]_F9_Dashboard.json` | تقارير KPI (getAll مطلوب) | — |
| F10 | `[COMPANY_NAME]_F10_WordPress.json` | مقالات WordPress | 1 ✅ |
| F11 | `[COMPANY_NAME]_F11_WP_Publisher.json` | نشر WordPress | 1 ✅ |
| **F12** | `[COMPANY_NAME]_F12_Wedding_Invitations.json` | **دعوات المناسبة خاصة الرقمية** ⭐ | 0 |

---

## 📊 الجداول – 15 جدول

| الجدول | gid | جديد؟ | المُغذِّي |
|--------|-----|-------|---------|
| `leads` | 1136316584 | — | F1-F4,F6,F12 |
| `services_log` | 2001234567 | ✅ | F3,F6 |
| `additional_orders` | 2001234568 | ✅ | F12 |
| `training_log` | 2001234569 | ✅ | F6 |
| `social_posts` | 966952321 | — | F7,F8 |
| `articles` | 1427001239 | — | F10,F11 |
| `daily_reports` | 1610612762 | — | F9 |
| `publish_log` | 1848411495 | — | F8 |
| `interactions_log` | 862175237 | — | F2 |
| `consent_log` | 882831808 | — | F2,F5 |
| `journey_log` | 1417386966 | — | F4 |
| `delivery_log` | 1759159568 | — | F5 |
| `sales_tasks` | 1511983230 | — | F6 |
| `workflow_errors` | 1659619068 | — | F1-F12 |

---

## 📦 تخصيص الخدمات
يمكنك تعديل أنواع الخدمات والبيانات المطلوبة في ملف الإعداد Config الخاص بكل نظام.

---

## 🔄 تحديثات getAll → getRows

| الوورك | العقدة القديمة (getAll) | العقدة الجديدة (getRows) | فلتر |
|--------|------------------------|------------------------|------|
| F2 | Check Existing Lead | ✅ getRows | `phone = $json.phone` |
| F2 | Check Consent | ✅ getRows | `phone = $json.phone` |
| F4 | Get Customer Profile | ✅ getRows | `phone = $json.phone` |
| F5 | Check Consent | ✅ getRows | `phone = $json.phone` |
| F6 | Get Customer Profile | ✅ getRows | `phone = $json.phone` |
| F6 | Check Task Open | ✅ getRows | `task_id = $json.task_id` |
| F6 | Check Task After 2h | ✅ getRows | `task_id = $json.task_id` |
| F8 | سحب منشور | ✅ getRows | `status = ready_to_publish` |
| F10 | سحب الأفكار | ✅ getRows | `status = idea` |
| F11 | سحب المقالات | ✅ getRows | `status = ready` |
| **F9** | Read Tabs (5 عقد) | ✅ **getAll مُبرَّر** | تقارير KPI تحتاج كل البيانات |

---

## 🌐 Dashboard [COMPANY_NAME]

### النشر على Vercel:
```bash
cd [COMPANY_NAME]_Dashboard  # فك الضغط
npm install --legacy-peer-deps
vercel deploy --prod --token YOUR_TOKEN
```

### متغيرات البيئة:
```env
GOOGLE_SHEET_ID=[YOUR_GOOGLE_SHEET_ID]
NEXT_PUBLIC_SHEET_API_KEY=your_key
N8N_BASE_URL=[YOUR_N8N_URL]
```

### تبويبات Dashboard:
1. **📊 نظرة عامة** – KPIs + رسوم بيانية + رؤى AI
2. **💼 الخدمات** – توزيع 10 خدمات + دعوات المناسبة خاصة
3. **📱 المحتوى** – منشورات + مقالات
4. **⚙️ الأنظمة** – حالة 12 نظام + خريطة التكامل

---

## ✅ قائمة إعداد ما بعد الاستيراد

```
□ استيراد 12 ملف JSON في n8n
□ ربط credentials: Google Sheets, Telegram, Gmail, Apify
□ ربط WordPress credentials (F10/F11)
□ إنشاء 3 تبويبات جديدة في الشيت: services_log, additional_orders, training_log
□ تحديث gid حقيقي للتبويبات الجديدة في Config
□ اختبار النظام بـ Webhook تجريبي
□ نشر Dashboard على Vercel وإضافة SHEET_API_KEY
□ تفعيل F1 Demo Mode أولاً للاختبار الكامل
□ تغيير /webhook/[COMPANY_NAME]-radar في F1 إذا تم تغيير المسار
□ إضافة طلب تجريبي للتحقق من تكامل البيانات
```

---

*[COMPANY_NAME] System v2.0 | منصة الأتمتة الذكية الشاملة | 12 نظام | 15 جدول | 10 خدمات*
