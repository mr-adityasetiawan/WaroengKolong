# API Contract MVP

Base URL development: `http://localhost:8080`

## GET /api/health

Response:

```json
{
  "ok": true,
  "service": "waroengkolong-backend"
}
```

## GET /api/menu

Response:

```json
{
  "data": [
    {
      "id": "m1",
      "name": "Nasi Ayam Kolong",
      "category": "Makanan",
      "price": 18000,
      "available": true
    }
  ]
}
```

## POST /api/orders

Request:

```json
{
  "customerName": "Aditya",
  "phone": "08123456789",
  "diningMode": "Ambil di stan",
  "paymentMethod": "Bayar di kasir / QRIS manual",
  "items": [
    {
      "menuItemId": "m1",
      "qty": 2,
      "note": "Sambal dipisah"
    }
  ]
}
```

Response:

```json
{
  "data": {
    "id": "uuid",
    "code": "WK-001",
    "customerName": "Aditya",
    "status": "baru",
    "total": 36000
  }
}
```

## GET /api/orders

Dipakai POS staff/admin untuk melihat daftar order.

## PATCH /api/orders/:idOrCode/status

Request:

```json
{
  "status": "diproses"
}
```

Status valid:

- `baru`
- `dibayar`
- `diproses`
- `siap_diambil`
- `selesai`
- `batal`
