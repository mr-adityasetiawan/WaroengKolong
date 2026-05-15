const http = require('node:http');
const { randomUUID } = require('node:crypto');

const port = Number(process.env.PORT || 8080);

const minimumPortionPerMenu = 20;
const orderLeadDays = 3;

const menu = [
  { id: 'mie-rebus-medan', name: 'Mie Rebus Medan', category: 'Makanan', price: 17000, available: true },
  { id: 'lontong-medan', name: 'Lontong Medan', category: 'Makanan', price: 15000, available: true },
];

const orders = [];

function sendJson(res, status, body) {
  res.writeHead(status, {
    'content-type': 'application/json; charset=utf-8',
    'access-control-allow-origin': '*',
    'access-control-allow-methods': 'GET,POST,PATCH,OPTIONS',
    'access-control-allow-headers': 'content-type,authorization',
  });
  res.end(JSON.stringify(body));
}

function readBody(req) {
  return new Promise((resolve, reject) => {
    let raw = '';
    req.on('data', (chunk) => {
      raw += chunk;
      if (raw.length > 1_000_000) {
        req.destroy();
        reject(new Error('Payload too large'));
      }
    });
    req.on('end', () => {
      try {
        resolve(raw ? JSON.parse(raw) : {});
      } catch (error) {
        reject(error);
      }
    });
  });
}

function makeOrderCode() {
  return `WK-${String(orders.length + 1).padStart(3, '0')}`;
}

function orderTotal(items) {
  return items.reduce((sum, item) => sum + item.qty * item.price, 0);
}

async function handler(req, res) {
  const url = new URL(req.url, `http://${req.headers.host}`);

  if (req.method === 'OPTIONS') {
    return sendJson(res, 204, {});
  }

  if (req.method === 'GET' && url.pathname === '/api/health') {
    return sendJson(res, 200, { ok: true, service: 'waroengkolong-backend' });
  }

  if (req.method === 'GET' && url.pathname === '/api/menu') {
    return sendJson(res, 200, { data: menu });
  }

  if (req.method === 'GET' && url.pathname === '/api/orders') {
    return sendJson(res, 200, { data: orders });
  }

  if (req.method === 'POST' && url.pathname === '/api/orders') {
    const body = await readBody(req);
    if (!body.customerName || !Array.isArray(body.items) || body.items.length === 0) {
      return sendJson(res, 400, { error: 'customerName and items are required' });
    }

    const items = body.items.map((item) => {
      const source = menu.find((menuItem) => menuItem.id === item.menuItemId);
      if (!source) throw new Error(`Unknown menu item: ${item.menuItemId}`);
      const qty = Math.max(1, Number(item.qty || 1));
      if (qty < minimumPortionPerMenu) {
        throw new Error(`Minimal ${minimumPortionPerMenu} porsi per menu untuk ${source.name}`);
      }
      return {
        menuItemId: source.id,
        name: source.name,
        qty,
        price: source.price,
        note: String(item.note || ''),
      };
    });

    const readyDate = new Date();
    readyDate.setDate(readyDate.getDate() + orderLeadDays);

    const order = {
      id: randomUUID(),
      code: makeOrderCode(),
      customerName: String(body.customerName),
      phone: String(body.phone || ''),
      diningMode: String(body.diningMode || 'Order online H-3'),
      status: 'baru',
      paymentMethod: String(body.paymentMethod || 'Transfer BCA / ShopeePay'),
      paymentProofLabel: String(body.paymentProofLabel || 'Bukti bayar terlampir'),
      items,
      total: orderTotal(items),
      minimumPortionPerMenu,
      readyDate: readyDate.toISOString(),
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    orders.unshift(order);
    return sendJson(res, 201, { data: order });
  }

  const statusMatch = url.pathname.match(/^\/api\/orders\/([^/]+)\/status$/);
  if (req.method === 'PATCH' && statusMatch) {
    const body = await readBody(req);
    const order = orders.find((item) => item.id === statusMatch[1] || item.code === statusMatch[1]);
    if (!order) return sendJson(res, 404, { error: 'Order not found' });

    const allowed = ['baru', 'dibayar', 'diproses', 'siap_diambil', 'selesai', 'batal'];
    if (!allowed.includes(body.status)) return sendJson(res, 400, { error: `status must be one of: ${allowed.join(', ')}` });

    order.status = body.status;
    order.updatedAt = new Date().toISOString();
    return sendJson(res, 200, { data: order });
  }

  return sendJson(res, 404, { error: 'Not found' });
}

const server = http.createServer((req, res) => {
  handler(req, res).catch((error) => sendJson(res, 500, { error: error.message }));
});

if (require.main === module) {
  server.listen(port, () => {
    console.log(`Waroeng Kolong API listening on :${port}`);
  });
}

module.exports = { server, menu, orders, minimumPortionPerMenu, orderLeadDays };
