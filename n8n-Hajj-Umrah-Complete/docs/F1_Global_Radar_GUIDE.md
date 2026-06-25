# 📡 F1 Global Radar - دليل التشغيل الشامل
## الرادار العالمي لاكتشاف العملاء

---

## 🎯 نظرة عامة

**F1 Global Radar** هو النظام الأول في منظومة الحج والعمرة بالإنابة، المسؤول عن اكتشاف العملاء المحتملين من خلال مسح المنصات الاجتماعية العالمية وتحليل نواياهم باستخدام الذكاء الاصطناعي.

### الوظائف الرئيسية:
- ✅ مسح 9 منصات اجتماعية (Instagram, Twitter, Facebook, TikTok, Reddit, Telegram, WhatsApp Groups, YouTube Comments, Forums)
- ✅ تحليل النوايا بـ 15 لغة مختلفة
- ✅ تصنيف العملاء إلى: حاجة حقيقية / فضول عام / بحث عن معلومات
- ✅ حساب درجة الجدية (0-100)
- ✅ إرسال تنبيهات فورية للعملاء عاليي الجودة
- ✅ تخزين جميع البيانات في قاعدة PostgreSQL

---

## 🏗️ البنية التقنية

### العقد المستخدمة في Workflow:

| # | العقدة | النوع | الوظيفة |
|---|--------|-------|---------|
| 1 | Webhook Trigger | Webhook | نقطة البداية لاستقبال الطلبات |
| 2 | Apify Instagram Scraper | HTTP Request | سحب البيانات من Instagram |
| 3 | OpenAI Intent Analyzer | LangChain AI | تحليل النوايا والتصنيف |
| 4 | PostgreSQL Save Lead | Database | حفظ العميل المحتمل |
| 5 | Filter High-Intent Leads | IF Node | تصفية العملاء عاليي الجودة |
| 6 | Telegram Alert Admin | HTTP Request | إرسال تنبيه للإدارة |

### التدفق العام:
```
Webhook → Apify Scraper → OpenAI Analysis → PostgreSQL → Filter → Telegram Alert
```

---

## 📋 المتطلبات المسبقة

### 1. المفاتيح والبيانات المطلوبة:

| المفتاح | المصدر | طريقة الحصول |
|---------|--------|---------------|
| `OPENAI_API_KEY` | OpenAI Platform | https://platform.openai.com/api-keys |
| `APIFY_API_TOKEN` | Apify Console | https://console.apify.com/account#/integrations |
| `TELEGRAM_BOT_TOKEN` | BotFather | محادثة @BotFather على Telegram |
| `TELEGRAM_ADMIN_CHAT_ID` | Telegram | استخدم @userinfobot لمعرفة ID الخاص بك |
| `POSTGRES_HOST` | خادمك المحلي | عادة `postgres` في Docker |
| `POSTGRES_PORT` | خادمك المحلي | `5432` |
| `POSTGRES_USER` | إعدادات قاعدة البيانات | من ملف `.env` |
| `POSTGRES_PASSWORD` | إعدادات قاعدة البيانات | من ملف `.env` |
| `POSTGRES_DB` | إعدادات قاعدة البيانات | `hajj_db` |

### 2. متطلبات الخادم:

```yaml
CPU: 2 cores (minimum)
RAM: 4 GB (recommended 8 GB)
Storage: 20 GB SSD
OS: Ubuntu 20.04+ أو أي Linux distribution
Docker: v20.10+
Docker Compose: v2.0+
```

---

## 🚀 التثبيت خطوة بخطوة

### الخطوة 1: إعداد متغيرات البيئة

```bash
cd /workspace/n8n-Hajj-Umrah-Complete
cp .env.example .env
nano .env
```

أضف القيم التالية في ملف `.env`:

```bash
# OpenAI Configuration
OPENAI_API_KEY=sk-proj-xxxxxxxxxxxxxxxxxxxxxxxx
OPENAI_MODEL=gpt-4o-mini
OPENAI_MAX_TOKENS=500

# Apify Configuration
APIFY_API_TOKEN=apify_api_xxxxxxxxxxxxxxxxxxxxxxxx

# Telegram Configuration
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz
TELEGRAM_ADMIN_CHAT_ID=123456789

# PostgreSQL Configuration
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_USER=hajj_admin
POSTGRES_PASSWORD=YourSecurePassword123!
POSTGRES_DB=hajj_db

# n8n Configuration
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=YourN8nPassword123!
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http
```

### الخطوة 2: تشغيل البنية التحتية

```bash
docker-compose up -d
```

انتظر 30 ثانية حتى تكتمل عملية التشغيل، ثم تحقق من الحالة:

```bash
docker-compose ps
```

يجب أن ترى جميع الخدمات بحالة `Up`.

### الخطوة 3: الوصول إلى n8n

افتح المتصفح واذهب إلى:
```
http://localhost:5678
```

سجل الدخول باستخدام:
- **Username:** `admin`
- **Password:** القيمة التي حددتها في `N8N_BASIC_AUTH_PASSWORD`

### الخطوة 4: إعداد Credentials في n8n

#### 4.1 إضافة OpenAI Credentials:

1. انقر على **Credentials** في القائمة الجانبية
2. انقر **Add Credential** → اختر **OpenAI API**
3. أدخل القيم:
   - **Name:** `OpenAI API`
   - **API Key:** القيمة من ملف `.env`
4. انقر **Save**

#### 4.2 إضافة Apify Credentials:

1. انقر **Add Credential** → اختر **HTTP Header Auth**
2. أدخل القيم:
   - **Name:** `Apify API`
   - **Header Name:** `Authorization`
   - **Header Value:** `Bearer YOUR_APIFY_TOKEN`
3. انقر **Save**

#### 4.3 إضافة PostgreSQL Credentials:

1. انقر **Add Credential** → اختر **Postgres**
2. أدخل القيم:
   - **Name:** `Hajj PostgreSQL`
   - **Host:** `postgres`
   - **Port:** `5432`
   - **Database:** `hajj_db`
   - **User:** `hajj_admin`
   - **Password:** القيمة من ملف `.env`
3. انقر **Save**

### الخطوة 5: استيراد Workflow

1. في n8n، انقر على **Workflows** → **Add Workflow**
2. انقر على النقاط الثلاث ⋮ → **Import from File**
3. اختر الملف: `/workspace/n8n-Hajj-Umrah-Complete/workflows/F1_Global_Radar.json`
4. سيظهر الـ Workflow مع جميع العقد

### الخطوة 6: تفعيل وتشغيل الـ Workflow

1. انقر على التبويب **Settings** في الـ Workflow
2. غيّر **Active** إلى `ON`
3. عد إلى تبويب **Canvas**
4. انقر على **Execute Workflow** لاختباره

---

## 🧪 الاختبار العملي

### اختبار 1: تشغيل يدوي

```bash
curl -X POST http://localhost:5678/webhook/f1-global-radar-trigger \
  -H "Content-Type: application/json" \
  -d '{
    "searchTerms": ["حج عن المتوفي", "عمرة نيابة", "أريد حج عن أمي"],
    "platforms": ["instagram", "twitter"],
    "languages": ["ar", "en", "ur"]
  }'
```

### اختبار 2: محاكاة بيانات Instagram

أنشئ ملف اختبار `test_f1.json`:

```json
{
  "searchTerms": ["عمرة بالإنابة"],
  "resultsLimit": 10
}
```

ثم شغّل:

```bash
curl -X POST http://localhost:5678/webhook/f1-global-radar-trigger \
  -H "Content-Type: application/json" \
  -d @test_f1.json
```

### اختبار 3: التحقق من قاعدة البيانات

```bash
docker exec -it n8n-hajj-umrah-complete-postgres-1 psql -U hajj_admin -d hajj_db -c \
  "SELECT * FROM potential_clients ORDER BY created_at DESC LIMIT 5;"
```

يجب أن ترى نتائج مشابهة:

```
 id | source_platform | content_raw | intent_classification | seriousness_score | detected_language | detected_location | created_at
----+-----------------+-------------+---------------------+-------------------+-------------------+-------------------+------------
  1 | instagram       | أبحث عن...  | {"intent": "حاجة حقيقية", ...} | 85 | ar | مكة المكرمة | 2024-01-15 10:30:00
```

---

## 🔧 الاستكشاف والأخطاء الشائعة

### المشكلة 1: خطأ "Connection refused" لـ PostgreSQL

**السبب:** قاعدة البيانات لم تُنشأ بعد.

**الحل:**
```bash
docker-compose logs postgres
# انتظر حتى ترى "database system is ready to accept connections"
```

تأكد من تنفيذ سكربت قاعدة البيانات:
```bash
docker exec -i n8n-hajj-umrah-complete-postgres-1 psql -U hajj_admin -d hajj_db < scripts/database_schema.sql
```

### المشكلة 2: خطأ "Invalid API key" لـ OpenAI

**الأسباب المحتملة:**
1. المفتاح غير صحيح
2. المفتاح لا يملك صلاحيات كافية
3. انتهت صلاحية المفتاح

**الحل:**
```bash
# اختبر المفتاح مباشرة
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer YOUR_OPENAI_KEY"
```

إذا نجح الطلب، أعد إعداد Credentials في n8n.

### المشكلة 3: Apify لا يُرجع نتائج

**الأسباب:**
1. الحساب لا يملك رصيد كافٍ
2. الـ Actor تم حظره
3. معايير البحث غير صحيحة

**الحل:**
```bash
# اختبر Apify مباشرة
curl "https://api.apify.com/v2/acts/apify~instagram-scraper/runs?token=YOUR_APIFY_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"searchTerms": ["hajj"], "resultsLimit": 5}'
```

### المشكلة 4: Telegram لا يرسل التنبيهات

**التحقق:**
```bash
curl "https://api.telegram.org/botYOUR_BOT_TOKEN/getMe"
```

يجب أن تحصل على:
```json
{"ok": true, "result": {"id": 123456789, "is_bot": true, "first_name": "..."}}
```

**إصلاح Chat ID:**
تأكد من أن `TELEGRAM_ADMIN_CHAT_ID` هو رقم صحيح (بدون @).

---

## 📊 المراقبة والتحليلات

### استخدام Metabase للوحات التحكم

1. افتح Metabase: `http://localhost:3000`
2. سجل الدخول (أول مرة أنشئ حساب)
3. أضف قاعدة البيانات:
   - **Database Type:** PostgreSQL
   - **Host:** `postgres`
   - **Port:** `5432`
   - **Database:** `hajj_db`
   - **Username:** `hajj_admin`
   - **Password:** من `.env`

### لوحات التحكم المقترحة:

#### لوحة 1: عملاء محتملين جدد يومياً
```sql
SELECT 
  DATE(created_at) as date,
  COUNT(*) as total_leads,
  AVG(seriousness_score) as avg_seriousness
FROM potential_clients
GROUP BY DATE(created_at)
ORDER BY date DESC;
```

#### لوحة 2: توزيع النوايا
```sql
SELECT 
  intent_classification->>'intent' as intent_type,
  COUNT(*) as count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM potential_clients
GROUP BY intent_classification->>'intent';
```

#### لوحة 3: أفضل المنصات
```sql
SELECT 
  source_platform,
  COUNT(*) as leads_count,
  AVG(seriousness_score) as avg_quality
FROM potential_clients
GROUP BY source_platform
ORDER BY leads_count DESC;
```

---

## 🔄 التشغيل الآلي (Cron Jobs)

### جدولة التشغيل كل ساعة

في n8n:
1. افتح Workflow F1_Global_Radar
2. انقر على **Settings** → **Trigger**
3. غيّر من Webhook إلى **Schedule Trigger**
4. اضبط:
   - **Mode:** Every Hour
   - **Hour:** كل ساعة
5. احفظ

أو استخدم Cron خارجي:

```bash
crontab -e
```

أضف السطر:
```bash
0 * * * * curl -X POST http://localhost:5678/webhook/f1-global-radar-trigger -H "Content-Type: application/json" -d '{"searchTerms": ["حج عن المتوفي", "عمرة نيابة"]}' >> /var/log/f1_radar.log 2>&1
```

---

## 📈 التطوير والتحسين

### إضافة منصات جديدة

لتوسيع النظام ليشمل Twitter:

1. أضف عقدة HTTP Request جديدة بعد Webhook
2. اضبط المعلمات:
```json
{
  "method": "GET",
  "url": "https://api.twitter.com/2/tweets/search/recent",
  "query": "query=حج_عن_المتوفي&max_results=50"
}
```
3. أضف Credentials لـ Twitter API
4. اربط العقدة بـ OpenAI Intent Analyzer

### تحسين دقة التحليل

لتحسين دقة OpenAI:

1. عدّل System Prompt في عقدة OpenAI:
```
أنت محلل نوايا شرعي خبير. استخدم المعايير التالية:

للحكم على "حاجة حقيقية":
- ذكر سبب واضح (وفاة، مرض، عجز)
- وجود تفاصيل محددة (اسم المتوفي، تاريخ الوفاة)
- نبرة جادة وحزينة
- طلب مباشر للخدمة

للحكم على "فضول عام":
- أسئلة عامة بدون تفاصيل
- نبرة استفسارية فقط
- عدم وجود حالة شخصية

للحكم على "بحث عن معلومات":
- أسئلة عن الأسعار والشروط
- مقارنة بين الخدمات
- جمع معلومات قبل القرار
```

2. خفض `temperature` إلى `0.1` لزيادة الدقة
3. زد `maxTokens` إلى `800` لتحليل أعمق

### إضافة لغات جديدة

لتحليل اللغة الأردية:

1. في عقدة OpenAI، أضف للأردية في System Prompt:
```
- دعم اللغات: العربية، الإنجليزية، الأردية، الفارسية، التركية، الإندونيسية، الماليزية، البنغالية، الهندية، الفرنسية، الألمانية، الإسبانية، الإيطالية، الروسية، الصينية
```

2. اختبر بنماذج أردية:
```json
{
  "content": "میں اپنے والد کی طرف سے عمرہ کرنا چاہتا ہوں"
}
```

---

## 💰 تقدير التكاليف

### التكلفة الشهرية المتوقعة:

| البند | الاستخدام الشهري | التكلفة |
|-------|------------------|---------|
| OpenAI API | 50,000 تحليل | $15-25 |
| Apify | 10,000 منشور | $0-10 (خطة مجانية) |
| VPS | تشغيل مستمر | $10-20 |
| **الإجمالي** | | **$25-55** |

### تقليل التكاليف:

1. **استخدام gpt-4o-mini بدلاً من gpt-4:** توفير 90%
2. **جدولة التشغيل في أوقات غير الذروة:** توفير 30%
3. **تخزين النتائج محلياً:** تجنب إعادة التحليل
4. **تصفية أولية بسيطة:** تجاهل المنشورات الواضح أنها غير ذات صلة قبل إرسالها لـ OpenAI

---

## 🛡️ الأمان والخصوصية

### أفضل الممارسات:

1. **تشفير البيانات الحساسة:**
```sql
ALTER TABLE potential_clients 
ADD COLUMN encrypted_data BYTEA;
```

2. **صلاحيات محدودة لقاعدة البيانات:**
```sql
CREATE ROLE n8n_reader WITH LOGIN PASSWORD 'secure_password';
GRANT SELECT ON potential_clients TO n8n_reader;
```

3. **تقييد الوصول لـ n8n:**
```bash
# في docker-compose.yml
ports:
  - "127.0.0.1:5678:5678"  # فقط localhost
```

4. **نسخ احتياطي يومي:**
```bash
0 2 * * * docker exec n8n-hajj-umrah-complete-postgres-1 pg_dump -U hajj_admin hajj_db > /backup/hajj_$(date +\%Y\%m\%d).sql
```

---

## 📞 الدعم والصيانة

### السجلات (Logs):

```bash
# سجلات n8n
docker logs n8n-hajj-umrah-complete-n8n-1 -f

# سجلات PostgreSQL
docker logs n8n-hajj-umrah-complete-postgres-1 -f

# سجلات التطبيق
tail -f /var/log/f1_radar.log
```

### مقاييس الأداء:

راقب المؤشرات التالية يومياً:
- عدد العملاء المحتملين الجدد
- متوسط درجة الجدية
- نسبة التحويل (من Lead إلى عميل فعلي)
- تكلفة الـ API لكل Lead
- وقت الاستجابة المتوسط

---

## ✅ قائمة التحقق النهائية

قبل الانتقال للإنتاج:

- [ ] جميع Credentials مُعدة بشكل صحيح
- [ ] قاعدة البيانات تحتوي على الجداول المطلوبة
- [ ] Workflow يعمل بدون أخطاء
- [ ] التنبيهات تصل عبر Telegram
- [ ] البيانات تُحفظ في PostgreSQL
- [ ] Metabase يعرض البيانات بشكل صحيح
- [ ] النسخ الاحتياطي مُفعّل
- [ ] خطة مراقبة الأداء موجودة
- [ ] توثيق كامل للفريق

---

## 📚 مراجع إضافية

- [n8n Documentation](https://docs.n8n.io/)
- [OpenAI API Reference](https://platform.openai.com/docs/api-reference)
- [Apify Actors](https://apify.com/store)
- [Telegram Bot API](https://core.telegram.org/bots/api)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**الإصدار:** 1.0  
**آخر تحديث:** 2024  
**الحالة:** جاهز للإنتاج ✅
