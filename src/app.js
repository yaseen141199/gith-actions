// app.js - تطبيق ويب بسيط مع Express

const express = require("express");
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware لقراءة JSON
app.use(express.json());

// API بسيط للترحيب
app.get("/", (req, res) => {
  res.json({
    message: "مرحباً بك في التطبيق البسيط!",
    status: "success",
    timestamp: new Date().toISOString(),
  });
});

// API لإرجاع معلومات المستخدم
app.get("/api/user", (req, res) => {
  res.json({
    name: "Yacin Ahmed",
    email: "yacin@example.com",
    role: "developer",
  });
});

// API لإجراء عمليات حسابية بسيطة
app.get("/api/add/:a/:b", (req, res) => {
  const a = parseFloat(req.params.a);
  const b = parseFloat(req.params.b);

  if (isNaN(a) || isNaN(b)) {
    return res.status(400).json({
      error: "الرجاء إدخال أرقام صحيحة",
    });
  }

  res.json({
    operation: "add",
    a: a,
    b: b,
    result: a + b,
  });
});

// POST API لإرسال البيانات
app.post("/api/data", (req, res) => {
  const { name, message } = req.body;

  if (!name || !message) {
    return res.status(400).json({
      error: "الرجاء إرسال name و message",
    });
  }

  res.json({
    received: true,
    name: name,
    message: message,
    receivedAt: new Date().toISOString(),
  });
});

// تشغيل السيرفر
app.listen(PORT, () => {
  console.log(`🚀 السيرفر يعمل على http://localhost:${PORT}`);
  console.log(`📝 اختبر التطبيق:
    - GET  http://localhost:${PORT}/
    - GET  http://localhost:${PORT}/api/user
    - GET  http://localhost:${PORT}/api/add/10/5
    - POST http://localhost:${PORT}/api/data`);
});
