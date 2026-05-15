import 'package:flutter/material.dart';

void main() {
  runApp(const WaroengKolongApp());
}

enum AppRole { customer, staff, admin }

enum OrderStatus { baru, dibayar, diproses, siapDiambil, selesai, batal }

class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    this.available = true,
  });

  final String id;
  final String name;
  final String category;
  final int price;
  final String description;
  final bool available;

  MenuItem copyWith({String? name, int? price, bool? available}) {
    return MenuItem(
      id: id,
      name: name ?? this.name,
      category: category,
      price: price ?? this.price,
      description: description,
      available: available ?? this.available,
    );
  }
}

class CartLine {
  CartLine({required this.item, this.qty = 1, this.note = ''});

  final MenuItem item;
  int qty;
  String note;

  int get subtotal => item.price * qty;
}

class OrderItem {
  const OrderItem({
    required this.name,
    required this.qty,
    required this.price,
    this.note = '',
  });

  final String name;
  final int qty;
  final int price;
  final String note;

  int get subtotal => qty * price;
}

class Order {
  Order({
    required this.code,
    required this.customerName,
    required this.phone,
    required this.items,
    required this.diningMode,
    required this.createdAt,
    this.status = OrderStatus.baru,
    this.paymentMethod = 'Bayar di kasir / QRIS manual',
  });

  final String code;
  final String customerName;
  final String phone;
  final List<OrderItem> items;
  final String diningMode;
  final DateTime createdAt;
  OrderStatus status;
  String paymentMethod;

  int get total => items.fold(0, (sum, item) => sum + item.subtotal);
}

class WaroengKolongApp extends StatefulWidget {
  const WaroengKolongApp({super.key});

  @override
  State<WaroengKolongApp> createState() => _WaroengKolongAppState();
}

class _WaroengKolongAppState extends State<WaroengKolongApp> {
  AppRole _role = AppRole.customer;
  int _tabIndex = 0;
  String _customerName = 'Aditya';
  String _phone = '08xxxxxxxxxx';
  String _diningMode = 'Ambil di stan';
  final List<CartLine> _cart = <CartLine>[];

  final List<MenuItem> _menu = <MenuItem>[
    const MenuItem(
      id: 'm1',
      name: 'Nasi Ayam Kolong',
      category: 'Makanan',
      price: 18000,
      description: 'Nasi hangat, ayam bumbu, sambal, lalap.',
    ),
    const MenuItem(
      id: 'm2',
      name: 'Mie Goreng Stan',
      category: 'Makanan',
      price: 15000,
      description: 'Mie goreng cepat saji dengan topping telur.',
    ),
    const MenuItem(
      id: 'm3',
      name: 'Pisang Coklat',
      category: 'Cemilan',
      price: 12000,
      description: 'Cemilan manis untuk teman nongkrong.',
    ),
    const MenuItem(
      id: 'd1',
      name: 'Es Teh Manis',
      category: 'Minuman',
      price: 5000,
      description: 'Teh manis dingin.',
    ),
    const MenuItem(
      id: 'd2',
      name: 'Kopi Tubruk',
      category: 'Minuman',
      price: 8000,
      description: 'Kopi panas khas stan.',
    ),
  ];

  final List<Order> _orders = <Order>[
    Order(
      code: 'WK-001',
      customerName: 'Rian',
      phone: '0812xxxx111',
      diningMode: 'Ambil di stan',
      createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      status: OrderStatus.diproses,
      items: const <OrderItem>[
        OrderItem(
          name: 'Nasi Ayam Kolong',
          qty: 2,
          price: 18000,
          note: 'Sambal dipisah',
        ),
        OrderItem(name: 'Es Teh Manis', qty: 2, price: 5000),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waroeng Kolong',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9A3412),
          primary: const Color(0xFF9A3412),
          secondary: const Color(0xFFF59E0B),
          surface: const Color(0xFFFFFBEB),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFBEB),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Waroeng Kolong'),
          backgroundColor: const Color(0xFF431407),
          foregroundColor: Colors.white,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<AppRole>(
                  value: _role,
                  dropdownColor: const Color(0xFF7C2D12),
                  iconEnabledColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  items: const <DropdownMenuItem<AppRole>>[
                    DropdownMenuItem(
                      value: AppRole.customer,
                      child: Text('Customer'),
                    ),
                    DropdownMenuItem(
                      value: AppRole.staff,
                      child: Text('POS Staff'),
                    ),
                    DropdownMenuItem(
                      value: AppRole.admin,
                      child: Text('Admin'),
                    ),
                  ],
                  onChanged: (AppRole? value) {
                    if (value == null) return;
                    setState(() {
                      _role = value;
                      _tabIndex = 0;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(child: _buildBody()),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tabIndex,
          onDestinationSelected: (int index) =>
              setState(() => _tabIndex = index),
          destinations: _destinations,
        ),
      ),
    );
  }

  List<NavigationDestination> get _destinations {
    switch (_role) {
      case AppRole.customer:
        return const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Order Saya',
          ),
        ];
      case AppRole.staff:
        return const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.point_of_sale), label: 'POS'),
          NavigationDestination(icon: Icon(Icons.check_circle), label: 'Siap'),
          NavigationDestination(
            icon: Icon(Icons.summarize),
            label: 'Ringkasan',
          ),
        ];
      case AppRole.admin:
        return const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Menu'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Staf'),
          NavigationDestination(icon: Icon(Icons.analytics), label: 'Laporan'),
        ];
    }
  }

  Widget _buildBody() {
    switch (_role) {
      case AppRole.customer:
        return <Widget>[
          _customerMenu(),
          _cartPage(),
          _customerOrders(),
        ][_tabIndex];
      case AppRole.staff:
        return <Widget>[
          _posOrders(),
          _readyOrders(),
          _salesSummary(),
        ][_tabIndex];
      case AppRole.admin:
        return <Widget>[_adminMenu(), _staffPage(), _salesSummary()][_tabIndex];
    }
  }

  Widget _customerMenu() {
    final Map<String, List<MenuItem>> grouped = <String, List<MenuItem>>{};
    for (final MenuItem item in _menu) {
      grouped.putIfAbsent(item.category, () => <MenuItem>[]).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        _heroCard(),
        const SizedBox(height: 16),
        ...grouped.entries.expand((MapEntry<String, List<MenuItem>> entry) {
          return <Widget>[
            Text(
              entry.key,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            ...entry.value.map(_menuCard),
            const SizedBox(height: 12),
          ];
        }),
      ],
    );
  }

  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF431407), Color(0xFF9A3412)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            'Order dari app, ambil di stan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pilih menu, dapat kode order, lalu sebut kode + atas nama saat sampai di Waroeng Kolong.',
            style: TextStyle(color: Color(0xFFFFEDD5)),
          ),
        ],
      ),
    );
  }

  Widget _menuCard(MenuItem item) {
    final bool inCart = _cart.any((CartLine line) => line.item.id == item.id);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 28,
              backgroundColor: item.available
                  ? const Color(0xFFFED7AA)
                  : Colors.grey.shade300,
              child: Icon(
                item.category == 'Minuman'
                    ? Icons.local_drink
                    : Icons.ramen_dining,
                color: const Color(0xFF9A3412),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  Text(item.description),
                  const SizedBox(height: 6),
                  Text(
                    _rupiah(item.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF9A3412),
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: item.available ? () => _addToCart(item) : null,
              icon: Icon(inCart ? Icons.add_task : Icons.add),
              label: Text(inCart ? 'Tambah' : 'Order'),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(MenuItem item) {
    setState(() {
      final int index = _cart.indexWhere(
        (CartLine line) => line.item.id == item.id,
      );
      if (index >= 0) {
        _cart[index].qty += 1;
      } else {
        _cart.add(CartLine(item: item));
      }
    });
  }

  Widget _cartPage() {
    final int total = _cart.fold(
      0,
      (int sum, CartLine line) => sum + line.subtotal,
    );
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const Text(
          'Keranjang Order',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Atas nama',
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: _customerName),
          onChanged: (String value) => _customerName = value,
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Nomor HP',
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: _phone),
          keyboardType: TextInputType.phone,
          onChanged: (String value) => _phone = value,
        ),
        const SizedBox(height: 10),
        SegmentedButton<String>(
          segments: const <ButtonSegment<String>>[
            ButtonSegment(
              value: 'Ambil di stan',
              label: Text('Ambil di stan'),
              icon: Icon(Icons.storefront),
            ),
            ButtonSegment(
              value: 'Makan di tempat',
              label: Text('Makan di tempat'),
              icon: Icon(Icons.table_restaurant),
            ),
          ],
          selected: <String>{_diningMode},
          onSelectionChanged: (Set<String> value) =>
              setState(() => _diningMode = value.first),
        ),
        const SizedBox(height: 16),
        if (_cart.isEmpty)
          const _EmptyState(
            icon: Icons.shopping_cart_outlined,
            title: 'Keranjang masih kosong',
            message: 'Pilih menu dulu dari tab Menu.',
          ),
        ..._cart.map(_cartLine),
        const Divider(height: 28),
        _InfoRow(label: 'Total', value: _rupiah(total), bold: true),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _cart.isEmpty ? null : _submitOrder,
          icon: const Icon(Icons.qr_code_2),
          label: const Text('Submit Order & Buat Kode'),
        ),
      ],
    );
  }

  Widget _cartLine(CartLine line) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    line.item.name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      setState(() => line.qty = (line.qty - 1).clamp(1, 99)),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('${line.qty}'),
                IconButton(
                  onPressed: () => setState(() => line.qty += 1),
                  icon: const Icon(Icons.add_circle_outline),
                ),
                IconButton(
                  onPressed: () => setState(() => _cart.remove(line)),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Catatan item, contoh: pedas sedang / tanpa sayur',
              ),
              onChanged: (String value) => line.note = value,
            ),
            const SizedBox(height: 6),
            Text(
              _rupiah(line.subtotal),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  void _submitOrder() {
    final String code = 'WK-${(_orders.length + 1).toString().padLeft(3, '0')}';
    final Order order = Order(
      code: code,
      customerName: _customerName.trim().isEmpty
          ? 'Pelanggan'
          : _customerName.trim(),
      phone: _phone,
      diningMode: _diningMode,
      createdAt: DateTime.now(),
      items: _cart
          .map(
            (CartLine line) => OrderItem(
              name: line.item.name,
              qty: line.qty,
              price: line.item.price,
              note: line.note,
            ),
          )
          .toList(),
    );
    setState(() {
      _orders.insert(0, order);
      _cart.clear();
      _tabIndex = 2;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order $code dibuat atas nama ${order.customerName}'),
      ),
    );
  }

  Widget _customerOrders() {
    final List<Order> customerOrders = _orders
        .where(
          (Order order) =>
              order.customerName.toLowerCase() == _customerName.toLowerCase(),
        )
        .toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const Text(
          'Order Saya',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        if (customerOrders.isEmpty)
          const _EmptyState(
            icon: Icons.receipt_long,
            title: 'Belum ada order',
            message: 'Order yang dibuat dari keranjang akan tampil di sini.',
          ),
        ...customerOrders.map(_orderCard),
      ],
    );
  }

  Widget _posOrders() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const Text(
          'POS - Order Masuk',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        const Text(
          'Staf bisa cari kode/nama dari pelanggan, lalu update status order.',
        ),
        const SizedBox(height: 12),
        ..._orders
            .where(
              (Order order) =>
                  order.status != OrderStatus.selesai &&
                  order.status != OrderStatus.batal,
            )
            .map(_orderCard),
      ],
    );
  }

  Widget _readyOrders() {
    final List<Order> ready = _orders
        .where((Order order) => order.status == OrderStatus.siapDiambil)
        .toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const Text(
          'Order Siap Diambil',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        if (ready.isEmpty)
          const _EmptyState(
            icon: Icons.check_circle_outline,
            title: 'Belum ada order siap',
            message: 'Order yang statusnya Siap Diambil akan tampil di sini.',
          ),
        ...ready.map(_orderCard),
      ],
    );
  }

  Widget _orderCard(Order order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${order.code} • ${order.customerName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Chip(label: Text(_statusLabel(order.status))),
              ],
            ),
            Text('${order.diningMode} • ${_shortTime(order.createdAt)}'),
            const SizedBox(height: 8),
            ...order.items.map(
              (OrderItem item) => Text(
                '• ${item.qty}x ${item.name}${item.note.isEmpty ? '' : ' — ${item.note}'}',
              ),
            ),
            const Divider(),
            _InfoRow(label: 'Total', value: _rupiah(order.total), bold: true),
            _InfoRow(label: 'Pembayaran', value: order.paymentMethod),
            if (_role != AppRole.customer) ...<Widget>[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: OrderStatus.values.map((OrderStatus status) {
                  return ChoiceChip(
                    label: Text(_statusLabel(status)),
                    selected: order.status == status,
                    onSelected: (_) => setState(() => order.status = status),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _adminMenu() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const Text(
          'Admin - Kelola Menu',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        const Text(
          'MVP awal: ubah status tersedia/habis dari app. Edit harga/nama penuh nanti tersambung API admin.',
        ),
        const SizedBox(height: 12),
        ..._menu.asMap().entries.map((MapEntry<int, MenuItem> entry) {
          final int index = entry.key;
          final MenuItem item = entry.value;
          return Card(
            child: SwitchListTile(
              title: Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text('${item.category} • ${_rupiah(item.price)}'),
              value: item.available,
              onChanged: (bool value) => setState(
                () => _menu[index] = item.copyWith(available: value),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _staffPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const <Widget>[
        Text(
          'Admin - User Staf',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 12),
        _InfoTile(
          icon: Icons.person,
          title: 'Kasir Stan',
          subtitle: 'Role: staff/POS • akses order masuk dan update status',
        ),
        _InfoTile(
          icon: Icons.admin_panel_settings,
          title: 'Owner',
          subtitle: 'Role: admin • akses menu, staf, laporan',
        ),
      ],
    );
  }

  Widget _salesSummary() {
    final int doneRevenue = _orders
        .where((Order order) => order.status == OrderStatus.selesai)
        .fold(0, (int sum, Order order) => sum + order.total);
    final int activeRevenue = _orders
        .where((Order order) => order.status != OrderStatus.batal)
        .fold(0, (int sum, Order order) => sum + order.total);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const Text(
          'Ringkasan Penjualan',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        _MetricCard(
          label: 'Order aktif',
          value:
              '${_orders.where((Order order) => order.status != OrderStatus.selesai && order.status != OrderStatus.batal).length}',
        ),
        _MetricCard(label: 'Omzet potensial', value: _rupiah(activeRevenue)),
        _MetricCard(label: 'Omzet selesai', value: _rupiah(doneRevenue)),
        _MetricCard(
          label: 'Menu tersedia',
          value:
              '${_menu.where((MenuItem item) => item.available).length}/${_menu.length}',
        ),
      ],
    );
  }

  String _rupiah(int value) {
    final String raw = value.toString();
    final StringBuffer out = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      final int remaining = raw.length - i;
      out.write(raw[i]);
      if (remaining > 1 && remaining % 3 == 1) out.write('.');
    }
    return 'Rp$out';
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.baru:
        return 'Baru';
      case OrderStatus.dibayar:
        return 'Dibayar';
      case OrderStatus.diproses:
        return 'Diproses';
      case OrderStatus.siapDiambil:
        return 'Siap Diambil';
      case OrderStatus.selesai:
        return 'Selesai';
      case OrderStatus.batal:
        return 'Batal';
    }
  }

  String _shortTime(DateTime value) {
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 48, color: const Color(0xFF9A3412)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
