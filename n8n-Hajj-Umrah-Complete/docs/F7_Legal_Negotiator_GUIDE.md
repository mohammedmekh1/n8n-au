# ⚖️ F7 Legal Negotiator - دليل التشغيل الشامل
## الوكيل الشرعي الذكي للفتاوى

---

## 🎯 نظرة عامة

**F7 Legal Negotiator** هو النظام الشرعي الذكي المسؤول عن الإجابة على الاستفسارات الشرعية المتعلقة بالحج والعمرة بالإنابة، مع نظام مراجعة مزدوج يضمن الدقة والأمان الشرعي.

### الوظائف الرئيسية:
- ✅ الإجابة على الفتاوى بناءً على المذاهب الأربعة
- ✅ نظام مراجعة مزدوج (AI أولي + AI مدقق)
- ✅ تحويل الأسئلة المعقدة لعلماء بشريين تلقائياً
- ✅ توثيق جميع الاستفسارات في قاعدة البيانات
- ✅ دعم 80+ لغة مع قاموس شرعي متخصص
- ✅ حساب درجة الثقة وتحديد الحاجة لمراجعة بشرية

---

## 🏗️ البنية التقنية

### العقد المستخدمة في Workflow:

| # | العقدة | النوع | الوظيفة |
|---|--------|-------|---------|
| 1 | Webhook Trigger | Webhook | استقبال الاستفسارات الشرعية |
| 2 | OpenAI Sharia Scholar | LangChain AI | الإجابة الأولية على السؤال |
| 3 | Sharia Reviewer AI | LangChain AI | مراجعة وتصحيح الإجابة |
| 4 | PostgreSQL Save Query | Database | توثيق الاستفتاء |
| 5 | Check Human Review Needed | IF Node | تحديد الحاجة لمراجعة بشرية |
| 6 | Telegram Alert Scholar | HTTP Request | تنبيه العلماء للمراجعات الضرورية |
| 7 | Return Answer to User | Respond to Webhook | إرجاع الإجابة للمستخدم |

### التدفق العام:
```
Webhook → AI Scholar → AI Reviewer → PostgreSQL → [Human Review?] → Response
```

---

## 📋 المتطلبات المسبقة

### 1. المفاتيح والبيانات المطلوبة:

| المفتاح | المصدر | طريقة الحصول |
|---------|--------|---------------|
| `OPENAI_API_KEY` | OpenAI Platform | https://platform.openai.com/api-keys |
| `TELEGRAM_BOT_TOKEN` | BotFather | محادثة @BotFather على Telegram |
| `TELEGRAM_SCHOLAR_CHAT_ID` | Telegram | ID العالم أو اللجنة الشرعية |
| `POSTGRES_HOST` | خادمك المحلي | عادة `postgres` في Docker |
| `POSTGRES_PORT` | خادمك المحلي | `5432` |
| `POSTGRES_USER` | إعدادات قاعدة البيانات | من ملف `.env` |
| `POSTGRES_PASSWORD` | إعدادات قاعدة البيانات | من ملف `.env` |
| `POSTGRES_DB` | إعدادات قاعدة البيانات | `hajj_db` |

### 2. متطلبات الخادم:

```yaml
CPU: 2 cores (minimum)
RAM: 4 GB (recommended 8 GB for complex fatwas)
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
OPENAI_MAX_TOKENS=1000

# Telegram Configuration
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz
TELEGRAM_SCHOLAR_CHAT_ID=987654321  # ID العالم أو اللجنة

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

تحقق من الحالة:
```bash
docker-compose ps
```

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

#### 4.2 إضافة PostgreSQL Credentials:

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
3. اختر الملف: `/workspace/n8n-Hajj-Umrah-Complete/workflows/F7_Legal_Negotiator.json`
4. سيظهر الـ Workflow مع جميع العقد

### الخطوة 6: تفعيل وتشغيل الـ Workflow

1. انقر على التبويب **Settings** في الـ Workflow
2. غيّر **Active** إلى `ON`
3. عد إلى تبويب **Canvas**
4. انقر على **Execute Workflow** لاختباره

---

## 🧪 الاختبار العملي

### اختبار 1: سؤال بسيط

```bash
curl -X POST http://localhost:5678/webhook/f7-legal-negotiator \
  -H "Content-Type: application/json" \
  -d '{
    "question": "هل يجوز الحج عن المتوفي الذي لم يحج في حياته؟",
    "language": "ar",
    "user_id": "user_123"
  }'
```

**الاستجابة المتوقعة:**
```json
{
  "success": true,
  "answer": "نعم، يجوز الحج عن المتوفي إذا كان لم يحج في حياته...",
  "confidence": "92",
  "disclaimer": "هذه إجابة آلية بناءً على الفتاوى المعتمدة..."
}
```

### اختبار 2: سؤال معقد (يحتاج مراجعة بشرية)

```bash
curl -X POST http://localhost:5678/webhook/f7-legal-negotiator \
  -H "Content-Type: application/json" \
  -d '{
    "question": "شخص حج عن أمه ثم اكتشف أنها كانت قد أوصت بعدم الحج عنها، فما الحكم؟",
    "language": "ar",
    "user_id": "user_456"
  }'
```

يجب أن تصل رسالة تنبيه للعالم عبر Telegram.

### اختبار 3: التحقق من قاعدة البيانات

```bash
docker exec -it n8n-hajj-umrah-complete-postgres-1 psql -U hajj_admin -d hajj_db -c \
  "SELECT question_raw, reviewed_answer, confidence_score, needs_human_review FROM legal_queries ORDER BY created_at DESC LIMIT 5;"
```

---

## 🔧 الاستكشاف والأخطاء الشائعة

### المشكلة 1: الإجابات غير دقيقة شرعياً

**الحل:** تحسين System Prompt:

```
أنت وكيل شرعي ذكي متخصص في فتاوى الحج والعمرة بالإنابة. تدريبك يشمل:

1. المذاهب الأربعة (حنفي، مالكي، شافعي، حنبلي)
2. فتاوى معاصرة من هيئات كبار العلماء
3. أحكام النيابة في الحج والعمرة
4. شروط صحة الإنابة وأنواعها

منهجيتك:
- ابدأ بذكر الحكم الراجح عند جمهور العلماء
- إن وجد خلاف، اذكره باختصار دون ترجيح إلا بدليل قوي
- استخدم عبارات مثل: "قال أكثر أهل العلم"، "الراجح والله أعلم"
- احذر من الجزم في المسائل الاجتهادية

تحذيرات:
- لا تفتِ في مسائل اختلف فيها العلماء إلا بذكر الخلاف
- لا تجزم في مسألة فيها احتمال إلا بقرينة قوية
- أحلْ إلى عالم بشري إذا كانت المسألة دقيقة أو فيها نزاع
```

### المشكلة 2: كثرة الحالات المحولة للمراجعة البشرية

**الحل:** ضبط عتبة الثقة:

في عقدة `Sharia Reviewer AI`، عدّل prompt المراجعة:

```
أنت مدقق شرعي. مهمتك مراجعة الإجابة السابقة والتأكد من:
1. عدم وجود أخطاء شرعية واضحة
2. مناسبة الإجابة للسؤال
3. وضوح العبارة

معايير تحويل الإجابة لمراجعة بشرية:
- المسألة فيها خلاف معتبر بين المذاهب
- الإجابة تحتوي على جزْم بدون دليل نصي
- السؤال يتعلق بحالة معقدة أو نادرة
- الثقة أقل من 75%

إذا كانت الإجابة صحيحة وواضحة، فلا تحولها للمراجعة البشرية.
```

### المشكلة 3: بطء الاستجابة

**الحل:** 
1. استخدام نموذج أخف للأسئلة البسيطة (`gpt-4o-mini`)
2. خفض `maxTokens` للإجابات القصيرة
3. رفع `temperature` قليلاً (0.3 بدلاً من 0.2) لتسريع التوليد

---

## 📊 المراقبة والتحليلات

### لوحات Metabase المقترحة:

#### لوحة 1: عدد الفتاوى يومياً
```sql
SELECT 
  DATE(created_at) as date,
  COUNT(*) as total_fatwas,
  SUM(CASE WHEN needs_human_review THEN 1 ELSE 0 END) as human_reviews,
  AVG(confidence_score) as avg_confidence
FROM legal_queries
GROUP BY DATE(created_at)
ORDER BY date DESC;
```

#### لوحة 2: نسبة المراجعات البشرية
```sql
SELECT 
  DATE_TRUNC('week', created_at) as week,
  ROUND(
    SUM(CASE WHEN needs_human_review THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2
  ) as human_review_percentage
FROM legal_queries
GROUP BY DATE_TRUNC('week', created_at)
ORDER BY week DESC;
```

#### لوحة 3: توزيع درجات الثقة
```sql
SELECT 
  CASE 
    WHEN confidence_score >= 90 THEN 'عالية جداً (90+)'
    WHEN confidence_score >= 75 THEN 'عالية (75-89)'
    WHEN confidence_score >= 60 THEN 'متوسطة (60-74)'
    ELSE 'منخفضة (<60)'
  END as confidence_level,
  COUNT(*) as count
FROM legal_queries
GROUP BY confidence_level
ORDER BY count DESC;
```

---

## 🔄 التكامل مع أنظمة أخرى

### التكامل مع F1 Global Radar:

عندما يكتشف F1 عميلاً محتملاً يسأل سؤالاً شرعياً:

```json
{
  "webhook_url": "http://localhost:5678/webhook/f7-legal-negotiator",
  "payload": {
    "question": "{{ $json.content }}",
    "language": "{{ $json.detected_language }}",
    "source": "F1_Global_Radar",
    "lead_id": "{{ $json.id }}"
  }
}
```

### التكامل مع F13 Golden Chain:

عندما يحتاج المنفذ إلى فتوى أثناء التنفيذ:

```bash
curl -X POST http://localhost:5678/webhook/f7-legal-negotiator \
  -H "Content-Type: application/json" \
  -d '{
    "question": "هل يجوز تأخير الطواف للعمرة عن المتوفي بسبب الزحام؟",
    "language": "ar",
    "executor_id": "exec_789",
    "session_id": "session_abc"
  }'
```

---

## 📈 التطوير والتحسين

### إضافة قاعدة معرفة شرعية (RAG):

لتحسين الدقة، أضف قاعدة معرفية:

1. أنشئ جدول `sharia_knowledge_base`:
```sql
CREATE TABLE sharia_knowledge_base (
  id SERIAL PRIMARY KEY,
  question_pattern TEXT NOT NULL,
  answer_template TEXT NOT NULL,
  madhhab VARCHAR(50),
  source_reference TEXT,
  confidence_weight DECIMAL(3,2) DEFAULT 1.0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

2. أضف بيانات مرجعية:
```sql
INSERT INTO sharia_knowledge_base (question_pattern, answer_template, madhhab, source_reference) VALUES
('%حج%عن%متوفي%', 'نعم، يجوز الحج عن المتوفي باتفاق المذاهب الأربعة...', 'all', 'صحيح البخاري، مسلم'),
('%عمرة%عن%مريض%', 'تجوز العمرة عن المريض العجز...', 'all', 'فتاوى اللجنة الدائمة');
```

3. في Workflow، أضف عقدة بحث قبل OpenAI:
```json
{
  "operation": "select",
  "table": "sharia_knowledge_base",
  "where": "question_pattern LIKE %{{ $json.question }}%",
  "orderBy": "confidence_weight DESC",
  "limit": 3
}
```

4. استخدم النتائج كـ context لـ OpenAI:
```
استخدم المعرفة التالية كمرجع أساسي:
{{ $json.knowledge_base_results }}

ثم أجب على السؤال: {{ $json.question }}
```

### إضافة تعدد المذاهب:

اسمح للمستخدم باختيار مذهبه:

```json
{
  "question": "...",
  "madhhab": "hanafi",  // hanafi, maliki, shafi'i, hanbali
  "language": "ar"
}
```

في System Prompt:
```
المستخدم يتبع المذهب {{ $json.madhhab }}.
ركز على أقوال هذا المذهب أولاً، ثم اذكر الخلاف إن وجد.
```

---

## 💰 تقدير التكاليف

### التكلفة الشهرية المتوقعة:

| البند | الاستخدام الشهري | التكلفة |
|-------|------------------|---------|
| OpenAI API | 10,000 فتوى | $20-40 |
| VPS | تشغيل مستمر | $10-20 |
| **الإجمالي** | | **$30-60** |

### تقليل التكاليف:

1. **استخدام gpt-4o-mini للأسئلة الروتينية:** توفير 80%
2. **التخزين المؤقت للإجابات المتكررة:** تجنب إعادة التحليل
3. **تحديد طول الإجابة:** خفض `maxTokens` للأسئلة البسيطة
4. **استخدام RAG:** تقليل اعتماد OpenAI على التدريب العام

---

## 🛡️ الأمان والخصوصية

### أفضل الممارسات:

1. **تشفير الأسئلة الحساسة:**
```sql
ALTER TABLE legal_queries 
ADD COLUMN encrypted_question BYTEA;
```

2. **سجل تدقيق للمراجعات البشرية:**
```sql
CREATE TABLE human_review_log (
  id SERIAL PRIMARY KEY,
  query_id INTEGER REFERENCES legal_queries(id),
  scholar_id INTEGER,
  review_decision VARCHAR(50),
  corrections_made TEXT,
  reviewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

3. **صلاحيات محدودة:**
```sql
CREATE ROLE fatwa_reader WITH LOGIN PASSWORD 'secure_password';
GRANT SELECT ON legal_queries TO fatwa_reader;
GRANT INSERT ON legal_queries TO fatwa_writer;
```

---

## ✅ قائمة التحقق النهائية

قبل الانتقال للإنتاج:

- [ ] جميع Credentials مُعدة بشكل صحيح
- [ ] نظام المراجعة المزدوجة يعمل بكفاءة
- [ ] التنبيهات للع علماء تصل عبر Telegram
- [ ] قاعدة البيانات تسجل جميع الاستفسارات
- [ ] نسبة المراجعات البشرية < 20%
- [ ] متوسط وقت الاستجابة < 10 ثوانٍ
- [ ] دقة الإجابات > 90% (بالقياس على عينات)
- [ ] توثيق كامل للفريق الشرعي

---

## 📚 مراجع شرعية معتمدة

### المصادر الأساسية:
- القرآن الكريم
- صحيح البخاري ومسلم
- سنن أبي داود، الترمذي، النسائي، ابن ماجه
- موطأ مالك

### كتب الفقه:
- **الحنفية:** الهداية للمرغيناني، فتح القدير لابن الهمام
- **المالكية:** المدونة الكبرى، مواهب الجليل للحطاب
- **الشافعية:** الأم للشافعي، مغني المحتاج للشربيني
- **الحنابلة:** المغني لابن قدامة، كشاف القناع للبهوتي

### الفتاوى المعاصرة:
- فتاوى اللجنة الدائمة للبحوث العلمية والإفتاء
- فتاوى مجلس الإفتاء الأعلى (الأزهر)
- فتاوى هيئة كبار العلماء (السعودية)
- موقع الإسلام (IslamQA.info)

---

## 📞 الدعم والصيانة

### السجلات (Logs):

```bash
# سجلات n8n
docker logs n8n-hajj-umrah-complete-n8n-1 -f

# مراقبة الاستفسارات الجديدة
watch -n 5 "docker exec n8n-hajj-umrah-complete-postgres-1 psql -U hajj_admin -d hajj_db -c 'SELECT COUNT(*) FROM legal_queries WHERE created_at > NOW() - INTERVAL ''1 hour'''"
```

### مقاييس الأداء:

راقب المؤشرات التالية يومياً:
- عدد الفتاوى المُجابة
- نسبة المراجعات البشرية
- متوسط درجة الثقة
- وقت الاستجابة المتوسط
- رضا المستخدمين (إن وجد تقييم)

---

**الإصدار:** 1.0  
**آخر تحديث:** 2024  
**الحالة:** جاهز للإنتاج ✅
