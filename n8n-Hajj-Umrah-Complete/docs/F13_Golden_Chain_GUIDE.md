# 🔗 F13 Golden Chain - دليل التشغيل الشامل
## السلسلة الذهبية لتوثيق العمرة

---

## 🎯 نظرة عامة

**F13 Golden Chain** هو نظام التوثيق الشامل المسؤول عن تسجيل كل خطوة من خطوات عمرة الإنابة وإرسالها للموكل لحظياً، مع إثباتات لا تقبل الشك (GPS، صور، فيديو، توقيت).

### الوظائف الرئيسية:
- ✅ بدء جلسة عمرة موثقة برمز فريد
- ✅ إرسال موقع GPS مباشر للمنفيذ
- ✅ توثيق كل مرحلة (إحرام، طواف، سعي، حلق)
- ✅ إرسال صور وفيديوهات لحظية للموكل
- ✅ سجل أدلة غير قابل للتلاعب في قاعدة البيانات
- ✅ إشعارات تلقائية لكل مرحلة
- ✅ شهادة إتمام رقمية في النهاية

---

## 🏗️ البنية التقنية

### العقد المستخدمة في Workflow:

| # | العقدة | النوع | الوظيفة |
|---|--------|-------|---------|
| 1 | Webhook Start Umrah | Webhook | بدء جلسة العمرة |
| 2 | PostgreSQL Get Session | Database | جلب بيانات الجلسة والموكل |
| 3 | Telegram Notify Client Start | HTTP Request | إشعار الموكل بالبدء |
| 4 | Telegram Send Live Location | HTTP Request | إرسال موقع مباشر |
| 5 | Wait 5 Minutes | Wait Node | انتظار بين التحديثات |
| 6 | Telegram Status Update | HTTP Request | تحديث الحالة |
| 7 | Check Tawaf Complete | IF Node | التحقق من اكتمال الطواف |
| 8 | Telegram Send Tawaf Photo | HTTP Request | إرسال صورة الكعبة |
| 9 | PostgreSQL Log Evidence | Database | توثيق الدليل |
| 10 | Return Success | Respond to Webhook | تأكيد النجاح |

### التدفق العام:
```
Webhook Start → Get Session → Notify Client → Send Location → 
[Wait → Update] × مراحل → Log Evidence → Complete
```

### المراحل الموثقة:

| المرحلة | الوصف | الإثبات المطلوب |
|---------|-------|-----------------|
| 1. Ihram | الإحرام من الميقات | صورة + موقع GPS |
| 2. Tawaf | الطواف 7 أشواط | صورة للكعبة + عداد |
| 3. Sa'i | السعي بين الصفا والمروة | صورة + موقع |
| 4. Halq/Taqsir | الحلق أو التقصير | صورة/فيديو |
| 5. Completion | الإتمام | شهادة رقمية |

---

## 📋 المتطلبات المسبقة

### 1. المفاتيح والبيانات المطلوبة:

| المفتاح | المصدر | طريقة الحصول |
|---------|--------|---------------|
| `TELEGRAM_BOT_TOKEN` | BotFather | محادثة @BotFather على Telegram |
| `POSTGRES_HOST` | خادمك المحلي | عادة `postgres` في Docker |
| `POSTGRES_PORT` | خادمك المحلي | `5432` |
| `POSTGRES_USER` | إعدادات قاعدة البيانات | من ملف `.env` |
| `POSTGRES_PASSWORD` | إعدادات قاعدة البيانات | من ملف `.env` |
| `POSTGRES_DB` | إعدادات قاعدة البيانات | `hajj_db` |
| `MINIO_ENDPOINT` | خادم MinIO | عادة `minio:9000` |
| `MINIO_ACCESS_KEY` | إعدادات MinIO | من ملف `.env` |
| `MINIO_SECRET_KEY` | إعدادات MinIO | من ملف `.env` |

### 2. متطلبات الخادم:

```yaml
CPU: 2 cores (minimum)
RAM: 4 GB (recommended 8 GB for media handling)
Storage: 50 GB SSD (للصور والفيديو)
OS: Ubuntu 20.04+ أو أي Linux distribution
Docker: v20.10+
Docker Compose: v2.0+
Internet: اتصال مستقر للمنفذين في مكة
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
# Telegram Configuration
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz

# PostgreSQL Configuration
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_USER=hajj_admin
POSTGRES_PASSWORD=YourSecurePassword123!
POSTGRES_DB=hajj_db

# MinIO Configuration (لتخزين الصور والفيديو)
MINIO_ENDPOINT=minio:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadminpassword
MINIO_BUCKET=hajj-evidence

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

#### 4.1 إضافة Telegram Credentials:

1. انقر على **Credentials** في القائمة الجانبية
2. انقر **Add Credential** → اختر **HTTP Header Auth** (لـ Telegram API)
3. أدخل القيم:
   - **Name:** `Telegram API`
   - **Header Name:** لا يوجد (Telegram لا يحتاج header خاص)
4. احفظ Token في متغيرات البيئة فقط

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
3. اختر الملف: `/workspace/n8n-Hajj-Umrah-Complete/workflows/F13_Golden_Chain.json`
4. سيظهر الـ Workflow مع جميع العقد

### الخطوة 6: تفعيل وتشغيل الـ Workflow

1. انقر على التبويب **Settings** في الـ Workflow
2. غيّر **Active** إلى `ON`
3. عد إلى تبويب **Canvas**
4. انقر على **Execute Workflow** لاختباره

---

## 🧪 الاختبار العملي

### اختبار 1: بدء جلسة عمرة جديدة

```bash
curl -X POST http://localhost:5678/webhook/f13-golden-chain-start \
  -H "Content-Type: application/json" \
  -d '{
    "session_id": "umrah_001",
    "client_telegram_id": "123456789",
    "deceased_name": "محمد أحمد علي",
    "executor_name": "أحمد المنفذ",
    "executor_lat": 21.4225,
    "executor_lng": 39.8262,
    "current_step": "ihram_started"
  }'
```

**الاستجابة المتوقعة:**
```json
{
  "success": true,
  "message": "تم بدء جلسة العمرة وإشعار الموكل",
  "session_id": "umrah_001"
}
```

يجب أن يتلقى الموكل رسالة على Telegram:
```
🕋 بدأت عمرة محمد أحمد علي

المنفذ: أحمد المنفذ
التوقيت: 2024-01-15 10:30:00

سنتابع معك كل خطوة بإذن الله
```

### اختبار 2: تحديث موقع المنفذ

```bash
curl -X POST http://localhost:5678/webhook/f13-golden-chain-update \
  -H "Content-Type: application/json" \
  -d '{
    "session_id": "umrah_001",
    "executor_lat": 21.4228,
    "executor_lng": 39.8265,
    "elapsed_minutes": 15,
    "current_step": "tawaf_in_progress"
  }'
```

### اختبار 3: إكمال الطواف

```bash
curl -X POST http://localhost:5678/webhook/f13-golden-chain-tawaf \
  -H "Content-Type: application/json" \
  -d '{
    "session_id": "umrah_001",
    "client_telegram_id": "123456789",
    "kaaba_photo_url": "https://example.com/kaaba_001.jpg",
    "executor_lat": 21.4225,
    "executor_lng": 39.8262,
    "current_step": "tawaf_completed",
    "elapsed_minutes": 45
  }'
```

يجب أن يتلقى الموكل:
- صورة للكعبة مع تعليق
- تحديث بقية الأشواط

### اختبار 4: التحقق من قاعدة البيانات

```bash
docker exec -it n8n-hajj-umrah-complete-postgres-1 psql -U hajj_admin -d hajj_db -c \
  "SELECT session_id, step_name, media_url, timestamp, verified FROM umrah_documentation_log ORDER BY timestamp DESC LIMIT 10;"
```

---

## 🔧 الاستكشاف والأخطاء الشائعة

### المشكلة 1: Telegram لا يرسل الموقع المباشر

**السبب:** إحداثيات GPS غير صحيحة أو ناقصة.

**الحل:** تأكد من تنسيق الإحداثيات:
```json
{
  "executor_lat": 21.4225,  // يجب أن يكون رقم عشري
  "executor_lng": 39.8262   // يجب أن يكون رقم عشري
}
```

نطاق الإحداثيات الصحيح لمكة:
- Latitude: 21.35 إلى 21.50
- Longitude: 39.75 إلى 39.90

### المشكلة 2: الصور لا تُرفع بشكل صحيح

**الحل:** استخدام MinIO لتخزين الصور:

1. تأكد من تشغيل خدمة MinIO:
```bash
docker-compose ps minio
```

2. أنشئ Bucket مخصص:
```bash
docker exec -it n8n-hajj-umrah-complete-minio-1 mc alias set myminio http://localhost:9000 minioadmin minioadminpassword
docker exec n8n-hajj-umrah-complete-minio-1 mc mb myminio/hajj-evidence
```

3. في Workflow، أضف عقدة رفع قبل إرسال الصورة:
```json
{
  "method": "PUT",
  "url": "http://minio:9000/hajj-evidence/{{ $json.session_id }}_{{ $json.step }}.jpg",
  "body": "={{ $json.image_binary }}"
}
```

### المشكلة 3: انقطاع الاتصال أثناء التنفيذ

**الحل:** إضافة نظام إعادة المحاولة:

في n8n، فعّل خيار **Retry on Failure** في عقد HTTP Request:
- Max Retries: 3
- Retry Interval: 30 seconds

أو استخدم Wait Node لإعادة الجدولة:
```json
{
  "waitMode": "interval",
  "interval": "5m",
  "maxRetries": 3
}
```

---

## 📊 المراقبة والتحليلات

### لوحات Metabase المقترحة:

#### لوحة 1: جلسات العمرة النشطة
```sql
SELECT 
  session_id,
  deceased_name,
  executor_name,
  current_step,
  started_at,
  EXTRACT(EPOCH FROM (NOW() - started_at))/60 as elapsed_minutes
FROM active_umrah_sessions
WHERE status = 'active'
ORDER BY started_at DESC;
```

#### لوحة 2: إحصائيات التوثيق
```sql
SELECT 
  step_name,
  COUNT(*) as completions,
  AVG(EXTRACT(EPOCH FROM (timestamp - LAG(timestamp) OVER (PARTITION BY session_id ORDER BY timestamp))))/60 as avg_duration_minutes
FROM umrah_documentation_log
WHERE verified = true
GROUP BY step_name;
```

#### لوحة 3: أداء المنفذين
```sql
SELECT 
  executor_id,
  executor_name,
  COUNT(DISTINCT session_id) as total_umrahs,
  AVG(total_duration_minutes) as avg_duration,
  COUNT(CASE WHEN verified = true THEN 1 END) * 100.0 / COUNT(*) as verification_rate
FROM umrah_documentation_log ud
JOIN active_umrah_sessions aus ON ud.session_id = aus.session_id
GROUP BY executor_id, executor_name
ORDER BY total_umrahs DESC;
```

---

## 🔄 التكامل مع أنظمة أخرى

### التكامل مع F7 Legal Negotiator:

عندما يواجه المنفذ مشكلة شرعية:

```bash
curl -X POST http://localhost:5678/webhook/f7-legal-negotiator \
  -H "Content-Type: application/json" \
  -d '{
    "question": "هل يجوز الجمع بين طواف العمرة وطواف القدوم؟",
    "language": "ar",
    "executor_id": "exec_789",
    "session_id": "umrah_001"
  }'
```

### التكامل مع F1 Global Radar:

عند تحويل عميل محتمل لعمرة فعلية:

```json
{
  "webhook_url": "http://localhost:5678/webhook/f13-golden-chain-start",
  "payload": {
    "session_id": "umrah_{{ $json.lead_id }}",
    "client_telegram_id": "{{ $json.telegram_id }}",
    "deceased_name": "{{ $json.deceased_name }}",
    "executor_name": "{{ $json.assigned_executor }}",
    "executor_lat": 21.4225,
    "executor_lng": 39.8262,
    "current_step": "initiated"
  }
}
```

---

## 📈 التطوير والتحسين

### إضافة بث مباشر (Live Streaming):

لتحقيق البث المباشر (F14):

1. استخدم OBS Studio على هاتف المنفذ
2. اربط بـ YouTube Live أو Twitch
3. أرسل رابط البث للموكل عبر Telegram:

```json
{
  "method": "POST",
  "url": "https://api.telegram.org/bot{{ $env.TELEGRAM_BOT_TOKEN }}/sendMessage",
  "jsonBody": {
    "chat_id": "{{ $json.client_telegram_id }}",
    "text": "🔴 بث مباشر للطواف:\n\nhttps://youtube.com/live/{{ $json.stream_id }}"
  }
}
```

### إضافة عداد أشواط ذكي:

استخدم AI لحساب الأشواط تلقائياً:

1. المنفذ يصور فيديو قصير للطواف
2. أرسل الفيديو لـ OpenAI Vision:
```json
{
  "model": "gpt-4-vision-preview",
  "messages": [
    {
      "role": "user",
      "content": [
        {"type": "text", "text": "كم شوطاً من الطواف يظهر في هذا الفيديو؟"},
        {"type": "image_url", "image_url": "{{ $json.video_frame_url }}"}
      ]
    }
  ]
}
```

### إضافة شهادة إتمام رقمية:

في نهاية العمرة، أنشئ شهادة PDF:

```python
from reportlab.pdfgen import canvas

def create_certificate(session_id, deceased_name, executor_name, completion_date):
    c = canvas.Canvas(f"/tmp/certificate_{session_id}.pdf")
    c.drawString(100, 750, f"شهادة إتمام عمرة")
    c.drawString(100, 700, f"اسم المتوفي: {deceased_name}")
    c.drawString(100, 650, f"المنفذ: {executor_name}")
    c.drawString(100, 600, f"تاريخ الإتمام: {completion_date}")
    c.save()
```

ثم أرسل الشهادة عبر Telegram:
```json
{
  "method": "POST",
  "url": "https://api.telegram.org/bot{{ $env.TELEGRAM_BOT_TOKEN }}/sendDocument",
  "jsonBody": {
    "chat_id": "{{ $json.client_telegram_id }}",
    "document": "@/tmp/certificate_{{ $json.session_id }}.pdf",
    "caption": "✅ تم إتمام العمرة بنجاح\n\nاللهم تقبل منا ومنكم"
  }
}
```

---

## 💰 تقدير التكاليف

### التكلفة الشهرية المتوقعة:

| البند | الاستخدام الشهري | التكلفة |
|-------|------------------|---------|
| VPS (مع تخزين أكبر) | 50 GB SSD | $15-25 |
| Telegram Bot API | غير محدود | $0 (مجاني) |
| MinIO Storage | محلي على VPS | $0 |
| نقل البيانات | 100 GB/month | $5-10 |
| **الإجمالي** | | **$20-35** |

### تقليل التكاليف:

1. **ضغط الصور تلقائياً:** استخدام TinyPNG API المجاني
2. **تخزين هرمي:** الاحتفاظ بالصور الحديثة فقط على السريع
3. **جدولة uploads:** تجنب أوقات الذروة للنقل

---

## 🛡️ الأمان والخصوصية

### أفضل الممارسات:

1. **تشفير الأدلة:**
```sql
ALTER TABLE umrah_documentation_log 
ADD COLUMN encrypted_media_hash BYTEA;
```

2. **تواقيع رقمية:**
```python
import hashlib

def sign_evidence(session_id, media_url, timestamp):
    data = f"{session_id}:{media_url}:{timestamp}"
    return hashlib.sha256(data.encode()).hexdigest()
```

3. **صلاحيات محدودة:**
```sql
CREATE ROLE executor_reader WITH LOGIN PASSWORD 'secure_password';
GRANT SELECT ON active_umrah_sessions TO executor_reader;
GRANT INSERT ON umrah_documentation_log TO executor_reader;
```

4. **سجل تدقيق:**
```sql
CREATE TABLE audit_log (
  id SERIAL PRIMARY KEY,
  session_id INTEGER REFERENCES active_umrah_sessions(session_id),
  action VARCHAR(100),
  performed_by VARCHAR(100),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## ✅ قائمة التحقق النهائية

قبل الانتقال للإنتاج:

- [ ] جميع Credentials مُعدة بشكل صحيح
- [ ] Telegram Bot يعمل ويرسل الرسائل
- [ ] قاعدة البيانات تسجل جميع الأدلة
- [ ] GPS يُحدّث بدقة
- [ ] الصور تُرفع وتُخزن بشكل آمن
- [ ] الإشعارات تصل في الوقت المناسب
- [ ] نظام إعادة المحاولة مُفعّل
- [ ] النسخ الاحتياطي للأدلة مُؤمّن
- [ ] شهادة الإتمام تُولّد تلقائياً

---

## 📞 الدعم والصيانة

### السجلات (Logs):

```bash
# سجلات n8n
docker logs n8n-hajj-umrah-complete-n8n-1 -f

# مراقبة الجلسات النشطة
watch -n 10 "docker exec n8n-hajj-umrah-complete-postgres-1 psql -U hajj_admin -d hajj_db -c 'SELECT COUNT(*) FROM active_umrah_sessions WHERE status = '\''active'\'''"
```

### مقاييس الأداء:

راقب المؤشرات التالية يومياً:
- عدد الجلسات النشطة
- متوسط وقت إتمام العمرة
- نسبة التوثيق الناجح
- عدد المحاولات الفاشلة
- رضا الموكلين (إن وجد تقييم)

---

## 📋 نموذج سير العمل الكامل

```
1. بدء الجلسة
   └─> Webhook استقبال الطلب
   └─> PostgreSQL جلب بيانات الموكل
   └─> Telegram إشعار الموكل بالبدء

2. الإحرام
   └─> GPS تحديد الموقع (الميقات)
   └─> Photo صورة للإحرام
   └─> Telegram إرسال للموكل
   └─> PostgreSQL توثيق

3. الطواف
   └─> GPS تتبع الحركة حول الكعبة
   └─> Counter عداد الأشواط
   └─> Photo صورة للكعبة بعد كل شوط
   └─> Telegram تحديثات مستمرة
   └─> PostgreSQL توثيق كل شوط

4. السعي
   └─> GPS تحديد الموقع بين الصفا والمروة
   └─> Counter عداد الأشواط
   └─> Photo صورة من المسعى
   └─> Telegram إرسال للموكل
   └─> PostgreSQL توثيق

5. الحلق/التقصير
   └─> Photo صورة/فيديو
   └─> Telegram إرسال للموكل
   └─> PostgreSQL توثيق

6. الإتمام
   └─> Certificate إنشاء الشهادة
   └─> Telegram إرسال الشهادة
   └─> PostgreSQL تحديث الحالة
   └─> Archive أرشفة الجلسة
```

---

**الإصدار:** 1.0  
**آخر تحديث:** 2024  
**الحالة:** جاهز للإنتاج ✅
