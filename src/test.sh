#!/bin/bash

# test.sh - سكربت لاختبار التطبيق

# الألوان للعرض الجميل
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ملف السجل
LOG_FILE="test_results.log"

# دالة للطباعة
print_message() {
    echo -e "${2}${1}${NC}"
    echo "$(date): $1" >> $LOG_FILE
}

# دالة لاختبار API
test_api() {
    local url=$1
    local expected_code=$2
    local test_name=$3
    
    print_message "🔍 اختبار: $test_name" "$BLUE"
    
    # تنفيذ الطلب
    response=$(curl -s -w "\n%{http_code}" $url)
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" -eq "$expected_code" ]; then
        print_message "✅ نجح: $test_name (HTTP $http_code)" "$GREEN"
        echo "   الرد: $body" | head -c 200
        echo ""
        return 0
    else
        print_message "❌ فشل: $test_name (توقع $expected_code ولكن حصل $http_code)" "$RED"
        echo "   الرد: $body" | head -c 200
        echo ""
        return 1
    fi
}

# بدء الاختبارات
clear
print_message "========================================" "$YELLOW"
print_message "     بدء اختبار التطبيق البسيط" "$YELLOW"
print_message "========================================" "$YELLOW"
echo ""

# التحقق من تشغيل السيرفر
print_message "📡 التحقق من تشغيل السيرفر..." "$BLUE"
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    print_message "✅ السيرفر يعمل على http://localhost:3000" "$GREEN"
else
    print_message "⚠️ السيرفر لا يعمل. يرجى تشغيله أولاً باستخدام: node app.js" "$RED"
    exit 1
fi

echo ""

# اختبارات API
test_api "http://localhost:3000/" 200 "الصفحة الرئيسية"
echo ""

test_api "http://localhost:3000/api/user" 200 "معلومات المستخدم"
echo ""

test_api "http://localhost:3000/api/add/15/7" 200 "عملية الجمع (15+7)"
echo ""

test_api "http://localhost:3000/api/add/abc/5" 400 "عملية جمع بأرقام غير صحيحة"
echo ""

# اختبار POST
print_message "🔍 اختبار: إرسال بيانات (POST)" "$BLUE"
post_response=$(curl -s -X POST http://localhost:3000/api/data \
    -H "Content-Type: application/json" \
    -d '{"name":"Yacin","message":"مرحباً من الاختبار"}' \
    -w "\n%{http_code}")
post_code=$(echo "$post_response" | tail -n1)
post_body=$(echo "$post_response" | sed '$d')

if [ "$post_code" -eq "200" ]; then
    print_message "✅ نجح: إرسال بيانات (HTTP $post_code)" "$GREEN"
    echo "   الرد: $post_body"
else
    print_message "❌ فشل: إرسال بيانات (HTTP $post_code)" "$RED"
fi

echo ""
print_message "========================================" "$YELLOW"
print_message "     انتهت الاختبارات" "$YELLOW"
print_message "========================================" "$YELLOW"
echo ""
print_message "📄 تم حفظ النتائج في: $LOG_FILE" "$BLUE"

# عرض إحصائيات
total_tests=$(grep -c "🔍 اختبار:" test_results.log 2>/dev/null || echo 0)
success_tests=$(grep -c "✅ نجح:" test_results.log 2>/dev/null || echo 0)
fail_tests=$(grep -c "❌ فشل:" test_results.log 2>/dev/null || echo 0)

echo ""
print_message "📊 الإحصائيات:" "$YELLOW"
print_message "   - إجمالي الاختبارات: $total_tests" "$NC"
print_message "   - ✅ نجحت: $success_tests" "$GREEN"
print_message "   - ❌ فشلت: $fail_tests" "$RED"

if [ $fail_tests -eq 0 ] && [ $total_tests -gt 0 ]; then
    echo ""
    print_message "🎉 جميع الاختبارات نجحت!" "$GREEN"
fi