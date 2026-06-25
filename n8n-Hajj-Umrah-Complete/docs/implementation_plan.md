# 📅 خطة التنفيذ التفصيلية - 6 أسابيع

## نظرة عامة

تم تقسيم تنفيذ الأنظمة الـ 56 إلى 6 دفعات أسبوعية، مع التركيز على بناء الأساس أولاً ثم التوسع التدريجي.

---

## الأسبوع 1: الرادار والبيانات ✅

### الأهداف
- [x] إعداد البنية التحتية الكاملة
- [x] تفعيل نظام الرادار العالمي (F1)
- [x] جمع أول 1000 عميل محتمل
- [x] ضبط قاعدة البيانات ولوحات التحكم

### المهام اليومية

#### اليوم 1: إعداد الخادم
```bash
# تثبيت Docker و Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
apt install docker-compose-plugin -y

# تحميل المشروع
git clone <repo-url> n8n-Hajj-Umrah-Complete
cd n8n-Hajj-Umrah-Complete

# تشغيل المنظومة
./scripts/setup.sh
```

**المعايير:**
- ✅ جميع الخدمات تعمل (n8n, PostgreSQL, Metabase, MinIO)
- ✅ قاعدة البيانات مُهيأة
- ✅ الوصول للواجهات متاح

#### اليوم 2: تكوين APIs
- إنشاء Telegram Bot عبر @BotFather
- الحصول على OpenAI API Key من platform.openai.com
- تفعيل Apify API من apify.com
- إضافة Credentials في n8n

**اختبار النجاح:**
```bash
# اختبار Telegram Bot
curl "https://api.telegram.org/bot<YOUR_TOKEN>/getMe"

# اختبار OpenAI
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer <YOUR_KEY>"
```

#### اليوم 3: استيراد F1_Global_Radar
1. الدخول إلى n8n (http://your-ip:5678)
2. استيراد `workflows/F1_Global_Radar.json`
3. تكوين العقد:
   - Webhook URL
   - Apify Credentials
   - OpenAI Credentials
   - PostgreSQL Connection
4. تفعيل Workflow

**كلمات البحث الأولية (15 لغة):**
```
العربية: "عمرة والدي المتوفى", "حج أمي المريضة", "نيابة عن الميت"
الإنجليزية: "umrah for deceased", "hajj on behalf of father"
الأردية: "میرے والد کے لیے عمرہ", "میت کے لیے حج"
الإندونيسية: "umrah untuk ayah meninggal", "haji untuk ibu"
التركية: "vefat eden anne için umre", "babası için hac"
الفارسية: "عمره برای پدر متوفی", "حج نیابتی"
الفرنسية: "omra pour défunt", "pèlerinage pour mort"
الألمانية: "umrah für verstorbene", "hadsch für tote"
الإسبانية: "umrah para fallecido", "peregrinación por muerto"
الروسية: "умра за умершего", "хадж за покойного"
الصينية: "为死者朝觐", "代朝"
اليابانية: "故人のためのウムラ", "代理巡礼"
الكورية: "고인을 위한 움라", "대리 순례"
الهندية: "मृतक के लिए उमराह", "तीर्थयात्रा"
البنغالية: "মৃতের জন্য উমরাহ", "হজ্জ"
```

#### اليوم 4: ضبط Apify Actors
**الـ Actors المستخدمة:**
- `apify/instagram-scraper` (مجاني حتى 1000 نتيجة/شهر)
- `apify/facebook-search` (مجاني حتى 500 نتيجة/شهر)
- `apify/twitter-scraper` (يتطلب اشتراك)

**إعدادات التشغيل:**
```json
{
  "searchTerms": ["عمرة والدي المتوفى", "حج أمي المريضة"],
  "resultsLimit": 50,
  "searchType": "hashtag",
  "addRequestDelay": true
}
```

#### اليوم 5: لوحة Metabase
**إنشاء Dashboard:**

1. **رسم بياني 1:** العملاء المحتملين يومياً
```sql
SELECT DATE(created_at) as date, COUNT(*) as leads
FROM potential_clients
GROUP BY DATE(created_at)
ORDER BY date DESC;
```

2. **رسم بياني 2:** توزيع اللغات
```sql
SELECT detected_language, COUNT(*) as count
FROM potential_clients
GROUP BY detected_language
ORDER BY count DESC;
```

3. **رسم بياني 3:** درجة الجدية المتوسطة
```sql
SELECT AVG(seriousness_score) as avg_score
FROM potential_clients
WHERE created_at >= NOW() - INTERVAL '24 hours';
```

#### اليوم 6-7: الاختبار والتحسين
- تشغيل الرادار لمدة 24 ساعة
- مراجعة النتائج في Metabase
- ضبط كلمات البحث
- تحسين System Prompt لـ OpenAI

**المخرجات المتوقعة:**
- 500-1000 Lead جديد
- 50-100 Lead عالي الجودة (score > 70)
- 5-10 عملاء جدد

---

## الأسبوع 2: الذكاء والفرز

### الأهداف
- [ ] تفعيل F7 Legal Negotiator
- [ ] تفعيل F8 Document Verifier
- [ ] تفعيل F9 Intent Analyzer
- [ ] تحقيق دقة 85%+ في التصنيف

### المهام الرئيسية

#### F7 - الوكيل الشرعي
1. استيراد `F7_Legal_Negotiator.json`
2. اختبار الفتاوى بـ 50 سؤال متنوع
3. ضبط درجة الحرارة (Temperature = 0.2 للأحكام)
4. تفعيل نظام المراجعة البشرية

**أسئلة الاختبار:**
```
1. هل يجوز العمرة عن الميت بدون إذن ورثته؟
2. ما الفرق بين النيابة في الحج والعمرة؟
3. إذا مات الشخص قبل أن يحج، هل يحج عنه من ماله؟
4. هل تجزئ عمرة واحدة عن عدة موتى؟
5. ما شروط صحة الإنابة في العمرة؟
```

#### F8 - التحقق من الوثائق
1. تثبيت Tesseract OCR على VPS
```bash
docker run -d --name hajj_tesseract \
  -v ./data/ocr_input:/input \
  -v ./data/ocr_output:/output \
  tesseractshadow/tesseract4re
```

2. اختبار قراءة شهادات الوفاة العربية
3. تحقيق دقة 90%+ للنصوص المطبوعة

#### F9 - تحليل النوايا
1. استخدام نموذج HuggingFace المحلي
```bash
# تشغيل نموذج تحليل المشاعر
docker run -d -p 8000:8000 \
  huggingface/text-transformers-query-classifier
```

2. الربط مع n8n عبر HTTP Request
3. معايرة درجات الجدية

---

## الأسبوع 3: التنفيذ والشفافية

### الأهداف
- [ ] تفعيل F13 Golden Chain
- [ ] تفعيل F14 Live Stream Certifier
- [ ] تسجيل 10 منفذين تجريبيين
- [ ] تنفيذ 5 عمرات اختبارية

### المهام الرئيسية

#### F13 - السلسلة الذهبية
1. استيراد `F13_Golden_Chain.json`
2. تسجيل المنفذين في قاعدة البيانات
```sql
INSERT INTO executors (name, telegram_id, phone, location_city)
VALUES ('أحمد محمد', '123456789', '+966501234567', 'مكة');
```

3. اختبار تدفق التوثيق:
   - بدء الجلسة
   - إرسال الموقع المباشر
   - رفع صور الطواف
   - توثيق في قاعدة البيانات

#### F14 - البث المباشر
**التقنية:**
- استخدام OBS للبث من هاتف المنفذ
- ربط بـ YouTube Unlisted أو Vimeo Private
- تخزين رابط البث في قاعدة البيانات
- إرسال للموكل لحظياً

---

## الأسبوع 4: النمو الفيروسي

### الأهداف
- [ ] تفعيل F22 Referral Portal
- [ ] إطلاق حملة الإحالات الأولى
- [ ] تحقيق معدل تحويل 20%+ من الإحالات

### F22 - بوابة الإحالات
**الميزات:**
- كل عميل يحصل على referral code فريد
- نقاط ثواب لكل إحالة ناجحة (100 نقطة)
- خصم 10% بعد 5 إحالات
- لوحة تتبع للإحالات

**تنفيذ SQL:**
```sql
-- إنشاء كود إحالة تلقائي لكل عميل جديد
CREATE OR REPLACE FUNCTION generate_referral_code()
RETURNS TRIGGER AS $$
BEGIN
    NEW.referral_code := 'REF' || NEW.id || '-' || 
                         SUBSTRING(MD5(RANDOM()::text) FROM 1 FOR 8);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_referral_code
BEFORE INSERT ON clients
FOR EACH ROW EXECUTE FUNCTION generate_referral_code();
```

---

## الأسبوع 5: البنية الذاتية

### الأهداف
- [ ] تفعيل F30 Self-Evolving AI
- [ ] تفعيل F32 Unified Notifications
- [ ] تحقيق 95% uptime

### F30 - التحسين الذاتي
**آلية العمل:**
1. مراقبة أداء كل Workflow
2. تحليل الأخطاء الشائعة
3. اقتراح تحسينات لـ Prompts
4. تطبيق التحسينات تلقائياً (بعد الموافقة)

**جدول المراقبة:**
```sql
CREATE TABLE workflow_performance (
    workflow_name VARCHAR(100),
    execution_time TIMESTAMP,
    duration_ms INTEGER,
    success BOOLEAN,
    error_message TEXT,
    tokens_used INTEGER,
    cost_usd DECIMAL(10,6)
);
```

---

## الأسبوع 6: الخدمات المباشرة

### الأهداف
- [ ] تفعيل F41 Visa Processor (حسب الموسم)
- [ ] تفعيل F47 Ihram Guide
- [ ] تفعيل F54 Prayer Times Sync

### F47 - دليل الإحرام التفاعلي
**المحتوى:**
- خطوات الإحرام بالترتيب
- الأدعية الصوتية
- المحظورات على المُحرم
- الأسئلة الشائعة

**التنفيذ:**
- Telegram Mini App
- أو Web App بسيط

---

## 📊 مقاييس النجاح الأسبوعية

| الأسبوع | المقياس | الهدف | الفعلي |
|---------|---------|-------|--------|
| 1 | Leads مجمعة | 1000 | ___ |
| 2 | دقة التصنيف | 85% | ___ |
| 3 | عمرات موثقة | 5 | ___ |
| 4 | إحالات ناجحة | 20 | ___ |
| 5 | Uptime | 95% | ___ |
| 6 | رضا العملاء | 4.5/5 | ___ |

---

## 🔄 عملية التحسين المستمر

### المراجعة الأسبوعية (كل جمعة)
1. **مراجعة الأداء:**
   - عدد الـ Leads وجودتها
   - تكلفة الـ API لكل Lead
   - معدل التحويل

2. **ضبط النظام:**
   - تحسين Keywords
   - تعديل Prompts
   - إصلاح الأخطاء

3. **التخطيط للأسبوع التالي:**
   - تحديد الأولويات
   - تخصيص الموارد
   - وضع أهداف قابلة للقياس

### التقرير الشهري
```markdown
# تقرير شهر 1

## الإنجازات
- ✅ تشغيل 6 أنظمة من 56
- ✅ جمع 5000 Lead
- ✅ تنفيذ 50 عمرة بنجاح

## التكاليف
- OpenAI API: $45
- Apify: $0 (الخطة المجانية)
- VPS: $15
- الإجمالي: $60

## العائد
- 50 عمرة × $100 = $5000
- ROI: 8233%

## التحديات
- [ذكر التحديات والحلول]

## الخطط القادمة
- [تحديد الأهداف للشهر التالي]
```

---

## ⚠️ إدارة المخاطر

| الخطر | الاحتمال | التأثير | الخطة البديلة |
|-------|----------|---------|---------------|
| توقف OpenAI API | منخفض | عالي | استخدام HuggingFace محلياً |
| حظر Apify | متوسط | متوسط | استخدام SpiderFoot + Scrapy |
| زيادة التكلفة | متوسط | منخفض | تقليل استخدام GPT-4 |
| خطأ شرعي | منخفض | عالي | مراجعة بشرية إلزامية |
| تسرب بيانات | منخفض | عالي | تشفير كامل + Backup يومي |

---

**آخر تحديث:** يونيو 2024  
**الحالة:** الأسبوع 1 مكتمل ✅  
**التالي:** الأسبوع 2 (الذكاء والفرز)
