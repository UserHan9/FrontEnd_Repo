# 📘 API Documentation — Niagapulse API v1.0

**Base URL:**  
`http://localhost:8080`

## 🔐 Authentication System Overview
API ini menggunakan JWT Token.

---

## 1️⃣ POST /api/auth/register
Mendaftar user baru.

### Request
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "securePassword123"
}
```

### Response
```json
{
  "token": "xxx",
  "username": "john_doe",
  "message": "Registration successful"
}
```

---

## 2️⃣ POST /api/auth/login
Login user.

### Request
```json
{
  "username": "john_doe",
  "password": "securePassword123"
}
```

### Response
```json
{
  "token": "xxx",
  "username": "john_doe",
  "message": "Login successful"
}
```

---

## 3️⃣ POST /api/tracking/update
Update lokasi vendor.

### Request
```json
{
  "vendorId": "VENDOR_001",
  "latitude": -6.1754,
  "longitude": 106.8272
}
```

### Response
```
Location received and logged
```

---

## 4️⃣ POST /api/sales/record
Catat penjualan vendor.

### Request
```json
{
  "vendorId": "VENDOR_001"
}
```

### Response
```
Counter ++ Success
```

---

## 5️⃣ GET /api/route/advice?vendorId=VENDOR_001
AI memberi rekomendasi rute.

### Response
```json
{
  "vendorId": "VENDOR_001",
  "currentArea": "Jakarta, Indonesia",
  "currentWeather": "Clear",
  "aiRecommendation": "Segera menuju ke arah barat daya untuk meningkatkan penjualan Anda",
  "aiModelUsed": "Claude Sonnet 4.5"
}
```

---

## 6️⃣ GET /api/hello
```
{ "message": "Hello World" }
```

---

## 7️⃣ GET /api/hello/user
Contoh:
```
{ "message": "Hello john_doe" }
```

---

## ❗ Error Structure
### 400
```json
{
  "status": 400,
  "error": "Bad Request",
  "message": "Invalid data"
}
```

### 401
```json
{
  "status": 401,
  "error": "Unauthorized",
  "message": "Invalid token"
}
```

### 500
```json
{
  "status": 500,
  "error": "Internal Server Error",
  "message": "Database error"
}
```
