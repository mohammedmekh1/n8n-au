# 🔌 دليل APIs والمفاتيح المطلوبة

## نظرة عامة

تتطلب المنظومة العالمية للحج والعمرة المفاتيح والاشتراكات التالية للتشغيل. تم تصميم النظام ليعمل بأقل تكلفة ممكنة باستخدام الاشتراكات الحالية والأدوات المجانية.

---

## 📋 قائمة المفاتيح المطلوبة

### 1. OpenAI API ✅ مطلوب

**الغرض:** تحليل النوايا، الإجابة على الاستفسارات الشرعية، الترجمة، توليد المحتوى

**المستوى المطلوب:** اشتراك مدفوع (Pay-as-you-go)

**التكلفة المتوقعة:** $10-50/شهر (باستخدام gpt-4o-mini)

**الحصول على المفتاح:**
1. اذهب إلى https://platform.openai.com
2. سجل الدخول أو أنشئ حساباً جديداً
3. اذهب إلى Settings → Billing
4. أضف بطاقة دفع (لا يوجد حد أدنى)
5. اذهب إلى API Keys → Create new secret key
6. انسخ المفتاح (يبدأ بـ `sk-...`)

**النماذج المستخدمة:**
```yaml
gpt-4o-mini:
  الاستخدام: المهام الروتينية (90% من الطلبات)
  التكلفة: ~$0.15 / مليون مدخلات
  الأمثلة: تصنيف، ترجمة، تحليل مشاعر

gpt-4o:
  الاستخدام: الأسئلة الشرعية المعقدة (10% من الطلبات)
  التكلفة: ~$2.50 / مليون مدخلات
  الأمثلة: فتاوى، مراجعة شرعية، نزاعات
```

**إضافة المفتاح في n8n:**
1. الدخول إلى n8n
2. Credentials → Add Credential
3. ابحث عن "OpenAI API"
4. الصق المفتاح في حقل "API Key"
5. احفظ

---

### 2. Apify API ✅ مطلوب

**الغرض:** جمع البيانات من وسائل التواصل الاجتماعي (Instagram, Facebook, TikTok)

**المستوى المطلوب:** خطة مجانية ($5 رصيد شهري) أو اشتراك مدفوع

**التكلفة المتوقعة:** $0-20/شهر

**الحصول على المفتاح:**
1. اذهب إلى https://apify.com
2. Sign up بحساب Google أو GitHub
3. اذهب إلى Settings → Integrations
4. انسخ "API Token"

**الـ Actors المستخدمة:**
```yaml
apify/instagram-scraper:
  الحالة: مجاني حتى 1000 نتيجة/شهر
  الاستخدام: البحث عن هاشتاجات ومنشورات

apify/facebook-search:
  الحالة: مجاني حتى 500 نتيجة/شهر
  الاستخدام: البحث في مجموعات Facebook العامة

apify/twitter-scraper:
  الحالة: يتطلب اشتراك ($49/شهر)
  الاستخدام: اختياري - يمكن الاستغناء عنه
```

**نصائح لتقليل التكلفة:**
- استخدم `addRequestDelay: true` لتجنب الحظر
- خزن النتائج محلياً في PostgreSQL
- أعد استخدام البيانات المخزنة بدلاً من scraping متكرر
- جدولة التشغيل في أوقات غير الذروة

---

### 3. Telegram Bot API ✅ مجاني تماماً

**الغرض:** الإشعارات، التواصل مع المنفذين والعملاء، واجهة المستخدم

**المستوى المطلوب:** مجاني تماماً

**التكلفة المتوقعة:** $0

**إنشاء البوت:**
1. افتح Telegram وابحث عن @BotFather
2. أرسل `/newbot`
3. اتبع التعليمات:
   - اختر اسماً للبوت (مثلاً: HajjUmrahBot)
   - اختر username (ينتهي بـ _bot، مثلاً: hajj_umrah_bot)
4. ستحصل على Token (يشبه: `1234567890:ABCdefGHIjklMNOpqrsTUVwxyz`)

**الحصول على Chat ID الخاص بك:**
1. ابحث عن البوت الذي أنشأته وابدأ محادثة (أرسل /start)
2. ابحث عن @userinfobot وأرسل له أي رسالة
3. سيرسل لك معلوماتك بما فيها Chat ID (رقم مثل: 123456789)

**إضافة في .env:**
```env
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz
TELEGRAM_ADMIN_CHAT_ID=123456789
```

**اختبار البوت:**
```bash
curl "https://api.telegram.org/bot<YOUR_TOKEN>/getMe"
curl "https://api.telegram.org/bot<YOUR_TOKEN>/sendMessage?chat_id=<YOUR_CHAT_ID>&text=Hello"
```

---

### 4. قاعدة البيانات (PostgreSQL) ✅ مجاني

**الغرض:** تخزين جميع البيانات (العملاء، المنفذين، الجلسات، السجلات)

**المستوى المطلوب:** Self-hosted على VPS الخاص بك

**التكلفة المتوقعة:** $0 (مشمولة في تكلفة VPS)

**بيانات الاتصال الافتراضية:**
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=hajj_umrah_db
DB_USER=hajj_admin
DB_PASSWORD=<كلمة_سر_قوية>
```

**الوصول إلى قاعدة البيانات:**
```bash
docker exec -it hajj_postgres psql -U hajj_admin -d hajj_umrah_db
```

---

### 5. MinIO (تخزين الملفات) ✅ مجاني

**الغرض:** تخزين الصور، الفيديوهات، الوثائق الممسوحة

**المستوى المطلوب:** Self-hosted على VPS الخاص بك

**التكلفة المتوقعة:** $0 (مشمولة في تكلفة VPS)

**بيانات الاتصال الافتراضية:**
```env
MINIO_ENDPOINT=localhost:9000
MINIO_ROOT_USER=minio_admin
MINIO_ROOT_PASSWORD=<كلمة_سر_قوية>
MINIO_BUCKET=hajj-media
```

**الوصول للواجهة:**
- Console: http://your-ip:9001
- API: http://your-ip:9000

---

## 🔐 مفاتيح اختيارية (للتوسع المستقبلي)

### 6. HuggingFace API ⏳ اختياري

**الغرض:** نماذج ذكاء اصطناعي مفتوحة المصدر بديلة عن OpenAI

**المستوى المطلوب:** خطة مجانية متاحة

**التكلفة المتوقعة:** $0-10/شهر

**متى تحتاجه:**
- إذا أردت تقليل تكاليف OpenAI
- لنماذج متخصصة (تحليل مشاعر، OCR)

**الحصول على المفتاح:**
1. https://huggingface.co/settings/tokens
2. Create new token (نوع: Read)

---

### 7. Google Maps API ⏳ اختياري

**الغرض:** تحديد المواقع الجغرافية، حساب المسافات

**المستوى المطلوب:** $200 رصيد مجاني شهرياً

**التكلفة المتوقعة:** $0 للاستخدام المتوسط

**متى تحتاجه:**
- لتحسين دقة locations في F6 Geo-Shadow
- لحساب مسافات المنفذين من الحرمين

---

### 8. Blockchain (Polygon) ⏳ اختياري

**الغرض:** العقود الذكية، توثيق المعاملات، نظام الوقف الرقمي

**المستوى المطلوب:** شبكة اختبار مجانية (Mumbai Testnet)

**التكلفة المتوقعة:** $0 (Testnet) → $10-50/شهر (Mainnet)

**متى تحتاجه:**
- عند تفعيل F18 Smart Contract
- عند تفعيل F19 Waqf Blockchain

---

## 📊 ملخص التكاليف الشهرية

| الخدمة | الخطة المجانية | الحد الأدنى | المتوسط المتوقع |
|--------|----------------|-------------|-----------------|
| OpenAI API | ❌ | $10 | $30-50 |
| Apify | ✅ $5 رصيد | $0 | $0-20 |
| Telegram | ✅ مجاني | $0 | $0 |
| PostgreSQL | ✅ مجاني | $0 | $0 |
| MinIO | ✅ مجاني | $0 | $0 |
| VPS | ❌ | $10 | $15-25 |
| **الإجمالي** | - | **$20** | **$45-95** |

---

## 🔧 إعداد_credentials في n8n

بعد تشغيل n8n، اتبع الخطوات التالية:

### 1. OpenAI API
```
Settings → Credentials → Add Credential
Type: OpenAI API
Name: OpenAI Main Account
API Key: sk-...
```

### 2. Apify API
```
Settings → Credentials → Add Credential
Type: HTTP Header Auth
Name: Apify Account
Header Name: Authorization
Header Value: Bearer <YOUR_APIFY_TOKEN>
```

### 3. PostgreSQL
```
Settings → Credentials → Add Credential
Type: PostgreSQL
Name: Hajj PostgreSQL Database
Host: postgres
Port: 5432
Database: hajj_umrah_db
User: hajj_admin
Password: <DB_PASSWORD>
SSL: Disable (للشبكة الداخلية)
```

### 4. Telegram Bot
```
لا يحتاج Credential منفصل
يستخدم مباشرة عبر HTTP Request node
استخدم المتغيرات البيئية:
{{ $env.TELEGRAM_BOT_TOKEN }}
{{ $env.TELEGRAM_ADMIN_CHAT_ID }}
```

---

## ⚠️ نصائح الأمان

### حماية المفاتيح

1. **لا تشارك المفاتيح أبداً**
   - لا تضعها في Git
   - لا تنشرها في كود عام
   - استخدم دائماً `.env` file

2. **تدوير المفاتيح دورياً**
   ```bash
   # كل 3 أشهر، أنشئ مفاتيح جديدة
   # واحذف القديمة من لوحة التحكم
   ```

3. **استخدم صلاحيات محدودة**
   - OpenAI: حدد quota شهري
   - Apify: استخدم فقط Actors المطلوبة

### حماية VPS

```bash
# تحديث النظام بانتظام
apt update && apt upgrade -y

# تفعيل جدار الحماية
ufw allow 22/tcp    # SSH
ufw allow 5678/tcp  # n8n
ufw allow 3000/tcp  # Metabase
ufw enable

# استخدام SSH Keys بدلاً من passwords
ssh-keygen -t ed25519
ssh-copy-id root@your-vps-ip
```

---

## 🆘 استكشاف الأخطاء

### المشكلة: OpenAI API لا يعمل

**الأعراض:** خطأ 401 Unauthorized

**الحلول:**
1. تأكد من أن المفتاح يبدأ بـ `sk-`
2. تحقق من وجود رصيد في حساب OpenAI
3. تأكد من عدم انتهاء صلاحية المفتاح

```bash
# اختبار المفتاح
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer sk-YOUR-KEY"
```

### المشكلة: Apify يستهلك الكثير من الرصيد

**الأعراض:** رصيد Apify ينفد بسرعة

**الحلول:**
1. قلل `resultsLimit` في الإعدادات
2. فعل `addRequestDelay`
3. خزن النتائج محلياً وأعد استخدامها

### المشكلة: Telegram Bot لا يرسل رسائل

**الأعراض:** خطأ 400 Bad Request

**الحلول:**
1. تأكد من أن Chat ID صحيح
2. تأكد من أن البوت ليس محظوراً
3. أرسل `/start` للبوت أولاً

---

## 📞 روابط مفيدة

- [OpenAI Documentation](https://platform.openai.com/docs)
- [Apify Documentation](https://docs.apify.com)
- [Telegram Bot API](https://core.telegram.org/bots/api)
- [n8n Credentials Guide](https://docs.n8n.io/hosting/credentials/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**آخر تحديث:** يونيو 2024  
**الحالة:** جميع المفاتيح المطلوبة محددة ✅
