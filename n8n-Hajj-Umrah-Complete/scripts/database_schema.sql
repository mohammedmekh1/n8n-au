-- ============================================
-- قاعدة بيانات المنظومة العالمية للحج والعمرة
-- الإصدار: 2.0 - مع دعم الأنظمة F1, F2, F7, F8, F9, F13
-- ============================================

-- جدول العملاء المحتملين (من الرادار العالمي)
CREATE TABLE IF NOT EXISTS potential_clients (
    id SERIAL PRIMARY KEY,
    source_platform VARCHAR(100),
    content_raw TEXT,
    intent_classification VARCHAR(50),
    seriousness_score INTEGER,
    detected_language VARCHAR(20),
    detected_location VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE,
    converted_to_client BOOLEAN DEFAULT FALSE
);

-- جدول الاستفسارات الشرعية
CREATE TABLE IF NOT EXISTS legal_queries (
    id SERIAL PRIMARY KEY,
    question_raw TEXT,
    ai_answer TEXT,
    reviewed_answer TEXT,
    confidence_score INTEGER,
    needs_human_review BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_language VARCHAR(20),
    resolved_by_scholar BOOLEAN DEFAULT FALSE,
    scholar_notes TEXT
);

-- جدول الجلسات النشطة للعمرة
CREATE TABLE IF NOT EXISTS active_umrah_sessions (
    session_id VARCHAR(100) PRIMARY KEY,
    client_id INTEGER,
    deceased_name VARCHAR(200),
    executor_name VARCHAR(200),
    executor_telegram_id VARCHAR(100),
    client_telegram_id VARCHAR(100),
    status VARCHAR(50) DEFAULT 'pending',
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    current_step VARCHAR(50),
    executor_lat DECIMAL(10, 8),
    executor_lng DECIMAL(11, 8)
);

-- جدول توثيق الأدلة (السلسلة الذهبية)
CREATE TABLE IF NOT EXISTS umrah_documentation_log (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(100),
    step_name VARCHAR(50),
    media_url TEXT,
    media_type VARCHAR(20),
    location_lat DECIMAL(10, 8),
    location_lng DECIMAL(11, 8),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified BOOLEAN DEFAULT FALSE,
    blockchain_hash VARCHAR(100),
    FOREIGN KEY (session_id) REFERENCES active_umrah_sessions(session_id)
);

-- جدول المنفذين
CREATE TABLE IF NOT EXISTS executors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200),
    telegram_id VARCHAR(100),
    phone VARCHAR(50),
    location_city VARCHAR(100),
    location_lat DECIMAL(10, 8),
    location_lng DECIMAL(11, 8),
    rating DECIMAL(3, 2) DEFAULT 5.00,
    completed_umrahs INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول العملاء
CREATE TABLE IF NOT EXISTS clients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200),
    email VARCHAR(200),
    telegram_id VARCHAR(100),
    phone VARCHAR(50),
    country VARCHAR(100),
    language VARCHAR(20),
    total_umrahs_booked INTEGER DEFAULT 0,
    total_spent DECIMAL(10, 2) DEFAULT 0.00,
    referral_code VARCHAR(50),
    referred_by INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_vip BOOLEAN DEFAULT FALSE
);

-- جدول الإحالات (نظام النمو الفيروسي)
CREATE TABLE IF NOT EXISTS referrals (
    id SERIAL PRIMARY KEY,
    referrer_id INTEGER,
    referred_client_id INTEGER,
    referral_code VARCHAR(50),
    status VARCHAR(20) DEFAULT 'pending',
    reward_amount DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (referrer_id) REFERENCES clients(id),
    FOREIGN KEY (referred_client_id) REFERENCES clients(id)
);

-- ============================================
-- جداول جديدة للأنظمة F2, F8, F9
-- ============================================

-- جدول العملاء الخام من جميع المصادر (F1, F2)
CREATE TABLE IF NOT EXISTS leads_raw (
    id SERIAL PRIMARY KEY,
    source_platform VARCHAR(100) NOT NULL,
    content_text TEXT,
    analysis_result JSONB,
    confidence_score INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE,
    converted_to_lead BOOLEAN DEFAULT FALSE
);

-- إنشاء فهرس لتحسين الأداء
CREATE INDEX IF NOT EXISTS idx_leads_source ON leads_raw(source_platform);
CREATE INDEX IF NOT EXISTS idx_leads_created ON leads_raw(created_at);
CREATE INDEX IF NOT EXISTS idx_leads_confidence ON leads_raw(confidence_score);

-- جدول تحليل النوايا (F9)
CREATE TABLE IF NOT EXISTS intent_analyses (
    id SERIAL PRIMARY KEY,
    lead_id INTEGER,
    original_text TEXT,
    intent_type VARCHAR(50),
    urgency_level VARCHAR(20),
    case_type VARCHAR(50),
    sincerity_score INTEGER,
    emotional_state VARCHAR(50),
    conversion_probability INTEGER,
    recommended_action VARCHAR(50),
    red_flags JSONB,
    priority_score INTEGER,
    classification VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lead_id) REFERENCES leads_raw(id)
);

-- إنشاء فهارس لتحسين الأداء
CREATE INDEX IF NOT EXISTS idx_intent_type ON intent_analyses(intent_type);
CREATE INDEX IF NOT EXISTS idx_intent_classification ON intent_analyses(classification);
CREATE INDEX IF NOT EXISTS idx_intent_priority ON intent_analyses(priority_score DESC);

-- جدول التحقق من الوثائق (F8)
CREATE TABLE IF NOT EXISTS document_verifications (
    id SERIAL PRIMARY KEY,
    lead_id INTEGER,
    document_type VARCHAR(100),
    ocr_text TEXT,
    extracted_data JSONB,
    verification_result JSONB,
    confidence_score INTEGER,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_by INTEGER,
    reviewed_at TIMESTAMP,
    FOREIGN KEY (lead_id) REFERENCES leads_raw(id)
);

-- إنشاء فهارس لتحسين الأداء
CREATE INDEX IF NOT EXISTS idx_doc_verification_status ON document_verifications(status);
CREATE INDEX IF NOT EXISTS idx_doc_confidence ON document_verifications(confidence_score);
CREATE INDEX IF NOT EXISTS idx_doc_type ON document_verifications(document_type);

-- ============================================
-- Views للوحات التحكم (Metabase)
-- ============================================

-- عرض ملخص النظام اليومي
CREATE OR REPLACE VIEW daily_system_summary AS
SELECT 
    DATE(created_at) as report_date,
    (SELECT COUNT(*) FROM leads_raw WHERE DATE(created_at) = DATE(now())) as new_leads_today,
    (SELECT COUNT(*) FROM intent_analyses WHERE DATE(created_at) = DATE(now()) AND classification = 'HOT_LEAD') as hot_leads_today,
    (SELECT COUNT(*) FROM document_verifications WHERE DATE(created_at) = DATE(now()) AND status = 'approved') as docs_approved_today,
    (SELECT COUNT(*) FROM legal_queries WHERE DATE(created_at) = DATE(now())) as legal_queries_today,
    (SELECT COUNT(*) FROM active_umrah_sessions WHERE DATE(started_at) = DATE(now())) as umrahs_started_today,
    (SELECT COUNT(*) FROM umrah_documentation_log WHERE DATE(timestamp) = DATE(now())) as documentation_entries_today;

-- عرض أفضل المصادر
CREATE OR REPLACE VIEW leads_by_source AS
SELECT 
    source_platform,
    COUNT(*) as total_leads,
    AVG(confidence_score) as avg_confidence,
    COUNT(CASE WHEN processed = TRUE THEN 1 END) as processed_count
FROM leads_raw
GROUP BY source_platform
ORDER BY total_leads DESC;

-- عرض توزيع النوايا
CREATE OR REPLACE VIEW intent_distribution AS
SELECT 
    intent_type,
    classification,
    COUNT(*) as count,
    AVG(sincerity_score) as avg_sincerity,
    AVG(conversion_probability) as avg_conversion_prob
FROM intent_analyses
GROUP BY intent_type, classification
ORDER BY count DESC;

-- عرض حالة التحقق من الوثائق
CREATE OR REPLACE VIEW document_verification_stats AS
SELECT 
    status,
    COUNT(*) as count,
    AVG(confidence_score) as avg_confidence,
    document_type
FROM document_verifications
GROUP BY status, document_type
ORDER BY count DESC;

-- ============================================
-- دوال مساعدة
-- ============================================

-- دالة تحديث حالة العميل المحتمل
CREATE OR REPLACE FUNCTION update_lead_status(p_lead_id INTEGER, p_processed BOOLEAN, p_converted BOOLEAN)
RETURNS VOID AS $$
BEGIN
    UPDATE leads_raw
    SET processed = p_processed, converted_to_lead = p_converted
    WHERE id = p_lead_id;
END;
$$ LANGUAGE plpgsql;

-- دالة إضافة عميل محتمل جديد مع التحليل التلقائي
CREATE OR REPLACE FUNCTION add_new_lead(
    p_source VARCHAR(100),
    p_content TEXT,
    p_confidence INTEGER
) RETURNS INTEGER AS $$
DECLARE
    v_lead_id INTEGER;
BEGIN
    INSERT INTO leads_raw (source_platform, content_text, confidence_score)
    VALUES (p_source, p_content, p_confidence)
    RETURNING id INTO v_lead_id;
    
    RETURN v_lead_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- بيانات أولية للتجربة
-- ============================================

INSERT INTO executors (name, telegram_id, phone, location_city, location_lat, location_lng)
VALUES 
    ('أحمد محمد', 'executor_001', '+966501234567', 'مكة المكرمة', 21.4225, 39.8262),
    ('محمد عبدالله', 'executor_002', '+966502345678', 'المدينة المنورة', 24.5247, 39.5692)
ON CONFLICT DO NOTHING;

-- منح صلاحيات الوصول
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO hajj_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO hajj_admin;
    referral_code VARCHAR(50),
    status VARCHAR(50) DEFAULT 'pending',
    reward_points INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    converted_at TIMESTAMP,
    FOREIGN KEY (referrer_id) REFERENCES clients(id),
    FOREIGN KEY (referred_client_id) REFERENCES clients(id)
);

-- جدول النقاط والثواب (الاقتصاد الروحي)
CREATE TABLE IF NOT EXISTS reward_points (
    id SERIAL PRIMARY KEY,
    client_id INTEGER,
    points INTEGER DEFAULT 0,
    reason VARCHAR(200),
    transaction_type VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

-- جدول المحتوى التسويقي التلقائي
CREATE TABLE IF NOT EXISTS auto_generated_content (
    id SERIAL PRIMARY KEY,
    content_type VARCHAR(50),
    title_ar VARCHAR(300),
    content_ar TEXT,
    title_en VARCHAR(300),
    content_en TEXT,
    platforms TEXT[],
    scheduled_for TIMESTAMP,
    published BOOLEAN DEFAULT FALSE,
    performance_metrics JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول المراقبة والتحسين الذاتي
CREATE TABLE IF NOT EXISTS system_monitoring (
    id SERIAL PRIMARY KEY,
    workflow_name VARCHAR(100),
    execution_count INTEGER DEFAULT 0,
    success_rate DECIMAL(5, 2),
    avg_execution_time_ms INTEGER,
    last_error TEXT,
    last_checked TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    auto_improvements_applied TEXT[]
);

-- إنشاء فهارس لتحسين الأداء
CREATE INDEX idx_potential_clients_seriousness ON potential_clients(seriousness_score);
CREATE INDEX idx_potential_clients_processed ON potential_clients(processed);
CREATE INDEX idx_legal_queries_needs_review ON legal_queries(needs_human_review);
CREATE INDEX idx_active_sessions_status ON active_umrah_sessions(status);
CREATE INDEX idx_documentation_session ON umrah_documentation_log(session_id);
CREATE INDEX idx_executors_active ON executors(is_active);
CREATE INDEX idx_clients_referral ON clients(referral_code);
CREATE INDEX idx_rewards_client ON reward_points(client_id);

-- إدخال بيانات تجريبية
INSERT INTO executors (name, telegram_id, phone, location_city, location_lat, location_lng) 
VALUES 
    ('أحمد محمد', '123456789', '+966501234567', 'مكة', 21.4225, 39.8262),
    ('خالد عبدالله', '987654321', '+966509876543', 'المدينة', 24.5247, 39.5692)
ON CONFLICT DO NOTHING;

-- عرض إحصائيات سريعة
CREATE OR REPLACE VIEW dashboard_stats AS
SELECT 
    (SELECT COUNT(*) FROM potential_clients WHERE created_at >= NOW() - INTERVAL '24 hours') as new_leads_24h,
    (SELECT COUNT(*) FROM active_umrah_sessions WHERE status = 'in_progress') as active_umrahs,
    (SELECT COUNT(*) FROM clients) as total_clients,
    (SELECT SUM(points) FROM reward_points) as total_rewards_distributed,
    (SELECT COUNT(*) FROM referrals WHERE converted_at IS NOT NULL) as successful_referrals;

COMMENT ON TABLE potential_clients IS 'العملاء المحتملين من نظام الرادار العالمي';
COMMENT ON TABLE legal_queries IS 'سجل الاستفسارات الشرعية ومعالجاتها';
COMMENT ON TABLE active_umrah_sessions IS 'جلسات العمرة النشطة حاليًا';
COMMENT ON TABLE umrah_documentation_log IS 'سجل توثيق أدلة العمرة (السلسلة الذهبية)';
COMMENT ON TABLE referrals IS 'نظام الإحالات للنمو الفيروسي';
COMMENT ON TABLE reward_points IS 'نقاط الثواب للاقتصاد الروحي';
