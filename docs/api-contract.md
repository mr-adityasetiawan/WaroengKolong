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
      "id": "mie-rebus-medan",
      "name": "Mie Rebus Medan",
      "category": "Makanan",
      "price": 17000,
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
  "diningMode": "Order online H-3",
  "paymentMethod": "Transfer BCA / ShopeePay",
  "paymentProofLabel": "Bukti bayar terlampir",
  "items": [
    {
      "menuItemId": "mie-rebus-medan",
      "qty": 20,
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
    "minimumPortionPerMenu": 20,
    "readyDate": "iso-date-H+3",
    "total": 340000
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
