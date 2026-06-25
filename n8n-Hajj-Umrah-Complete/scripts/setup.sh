#!/bin/bash

# ============================================
# سكربت التشغيل السريع - المنظومة العالمية للحج والعمرة
# ============================================

set -e  # إيقاف عند أي خطأ

# الألوان للطباعة
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# دالة الطباعة الملونة
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# التحقق من وجود Docker
check_docker() {
    print_status "التحقق من تثبيت Docker..."
    if ! command -v docker &> /dev/null; then
        print_error "Docker غير مثبت. جاري التثبيت..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        print_success "تم تثبيت Docker بنجاح"
    else
        print_success "Docker مثبت (الإصدار: $(docker --version))"
    fi
}

# التحقق من وجود Docker Compose
check_docker_compose() {
    print_status "التحقق من تثبيت Docker Compose..."
    if ! command -v docker compose &> /dev/null && ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose غير مثبت"
        print_warning "يرجى تثبيت Docker Compose يدوياً"
        exit 1
    else
        print_success "Docker Compose مثبت"
    fi
}

# إعداد ملف .env
setup_env() {
    print_status "إعداد ملف البيئة (.env)..."
    
    if [ -f .env ]; then
        print_warning "ملف .env موجود مسبقاً"
        read -p "هل تريد إعادة تعيينه؟ (y/n): " reset_choice
        if [ "$reset_choice" != "y" ]; then
            print_status "تخطي إعداد .env"
            return
        fi
    fi
    
    cp .env.example .env
    print_success "تم نسخ .env.example إلى .env"
    
    echo ""
    print_warning "⚠️  مهم: قم بتحرير ملف .env وإضافة مفاتيح API الحقيقية"
    echo ""
    echo "القيم المطلوبة:"
    echo "  - OPENAI_API_KEY"
    echo "  - APIFY_API_KEY"
    echo "  - TELEGRAM_BOT_TOKEN"
    echo "  - TELEGRAM_ADMIN_CHAT_ID"
    echo "  - DB_PASSWORD (كلمة سر قوية)"
    echo ""
    
    read -p "هل قمت بتحديث ملف .env؟ (y/n): " env_updated
    if [ "$env_updated" != "y" ]; then
        print_error "يجب تحديث ملف .env قبل المتابعة"
        exit 1
    fi
}

# تشغيل الخدمات
start_services() {
    print_status "جاري تشغيل الخدمات..."
    
    docker compose up -d
    
    print_success "تم تشغيل الخدمات بنجاح"
    echo ""
    echo "الخدمات النشطة:"
    docker compose ps
}

# انتظار جاهزية الخدمات
wait_for_services() {
    print_status "انتظار جاهزية الخدمات (60 ثانية)..."
    
    sleep 10
    
    # انتظار PostgreSQL
    print_status "التحقق من جاهزية PostgreSQL..."
    for i in {1..30}; do
        if docker exec hajj_postgres pg_isready -U hajj_admin &> /dev/null; then
            print_success "PostgreSQL جاهز"
            break
        fi
        if [ $i -eq 30 ]; then
            print_error "فشل الاتصال بـ PostgreSQL"
            exit 1
        fi
        echo -n "."
        sleep 2
    done
    
    # انتظار n8n
    print_status "التحقق من جاهزية n8n..."
    for i in {1..30}; do
        if curl -s http://localhost:5678/healthz &> /dev/null; then
            print_success "n8n جاهز"
            break
        fi
        if [ $i -eq 30 ]; then
            print_warning "n8n قد يحتاج وقت إضافي"
        fi
        echo -n "."
        sleep 2
    done
}

# إعداد قاعدة البيانات
setup_database() {
    print_status "إعداد قاعدة البيانات..."
    
    docker exec -i hajj_postgres psql -U hajj_admin -d hajj_umrah_db < scripts/database_schema.sql
    
    print_success "تم إنشاء جداول قاعدة البيانات بنجاح"
}

# عرض معلومات الوصول
show_access_info() {
    echo ""
    print_success "=========================================="
    print_success "   اكتمل التثبيت بنجاح! 🎉"
    print_success "=========================================="
    echo ""
    echo "📌 روابط الوصول:"
    echo ""
    echo "   🤖 n8n (الأتمتة):"
    echo "      URL: http://localhost:5678"
    echo "      ملاحظة: سيتم إنشاء حساب المسؤول عند أول دخول"
    echo ""
    echo "   📊 Metabase (التحليلات):"
    echo "      URL: http://localhost:3000"
    echo "      Login: admin"
    echo "      Password: password (غيّرها فوراً!)"
    echo ""
    echo "   💾 MinIO (تخزين الملفات):"
    echo "      Console: http://localhost:9001"
    echo "      Login: minio_admin"
    echo "      Password: minio_secure_password"
    echo ""
    echo "🔧 الخطوات التالية:"
    echo ""
    echo "   1. استيراد Workflows من مجلد workflows/"
    echo "   2. إضافة Credentials في n8n:"
    echo "      - OpenAI API"
    echo "      - Apify API"
    echo "      - PostgreSQL"
    echo "      - Telegram Bot"
    echo ""
    echo "   3. تفعيل F1_Global_Radar workflow"
    echo "   4. ضبط Cron Job للعمل كل ساعة"
    echo ""
    echo "📚 للمزيد من المعلومات، راجع README.md"
    echo ""
}

# السكربت الرئيسي
main() {
    echo ""
    echo "=========================================="
    echo " 🕌 المنظومة العالمية للحج والعمرة"
    echo "    سكربت التثبيت السريع"
    echo "=========================================="
    echo ""
    
    check_docker
    check_docker_compose
    setup_env
    start_services
    wait_for_services
    setup_database
    show_access_info
}

# تشغيل السكربت
main "$@"
