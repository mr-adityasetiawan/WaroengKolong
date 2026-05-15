import 'package:flutter/material.dart';

void main() {
  runApp(const WaroengKolongApp());
}

enum AppRole { customer, staff, admin }

enum OrderStatus { baru, dibayar, diproses, siapDiambil, selesai, batal }

const int minimumPortionPerMenu = 20;

class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.available = true,
  });

  final String id;
  final String name;
  final int price;
  final String description;
  final bool available;

  MenuItem copyWith({bool? available}) {
    return MenuItem(
      id: id,
      name: name,
      price: price,
      description: description,
      available: available ?? this.available,
    );
  }
}

class CartLine {
  CartLine({required this.item, this.qty = minimumPortionPerMenu});

  final MenuItem item;
  int qty;

  int get subtotal => item.price * qty;
  bool get validMinimum => qty >= minimumPortionPerMenu;
}

class OrderItem {
  const OrderItem({required this.name, required this.qty, required this.price});

  final String name;
  final int qty;
  final int price;

  int get subtotal => qty * price;
}

class Order {
  Order({
    required this.code,
    required this.customerName,
    required this.phone,
    required this.note,
    required this.items,
    required this.createdAt,
    required this.readyDate,
    this.status = OrderStatus.baru,
    this.paymentMethod = 'Transfer BCA / ShopeePay',
    this.paymentProofLabel = 'Bukti bayar terlampir',
  });

  final String code;
  final String customerName;
  final String phone;
  final String note;
  final List<OrderItem> items;
  final DateTime createdAt;
  final DateTime readyDate;
  OrderStatus status;
  String paymentMethod;
  String paymentProofLabel;

  int get total => items.fold(0, (sum, item) => sum + item.subtotal);
  int get totalPortions => items.fold(0, (sum, item) => sum + item.qty);
}

class WaroengKolongApp extends StatefulWidget {
  const WaroengKolongApp({super.key});

  @override
  State<WaroengKolongApp> createState() => _WaroengKolongAppState();
}

class _WaroengKolongAppState extends State<WaroengKolongApp> {
  AppRole _role = AppRole.customer;
  int _tabIndex = 0;
  bool _paymentProofSelected = false;

  final TextEditingController _nameController = TextEditingController(
    text: 'Aditya',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '08xxxxxxxxxx',
  );
  final TextEditingController _noteController = TextEditingController();
  final List<CartLine> _cart = <CartLine>[];

  final List<MenuItem> _menu = <MenuItem>[
    const MenuItem(
      id: 'mie-rebus-medan',
      name: 'Mie Rebus Medan',
      price: 17000,
      description:
          'Kuah khas Medan, bumbu meresap, fresh cooked untuk order acara.',
    ),
    const MenuItem(
      id: 'lontong-medan',
      name: 'Lontong Medan',
      price: 15000,
      description: 'Lontong Medan halal dengan cita rasa Waroeng Kolong.',
    ),
  ];

  final List<Order> _orders = <Order>[
    Order(
      code: 'WK-001',
      customerName: 'Rian',
      phone: '0812xxxx111',
      note: 'Mie dipisah, pedas sedang',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      readyDate: DateTime.now().add(const Duration(days: 3)),
      status: OrderStatus.diproses,
      items: const <OrderItem>[
        OrderItem(name: 'Mie Rebus Medan', qty: 20, price: 17000),
      ],
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waroeng Kolong',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC2410C),
          primary: const Color(0xFFC2410C),
          secondary: const Color(0xFFFACC15),
          surface: const Color(0xFFFFF7ED),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF431407),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WAROENG KOLONG'),
          centerTitle: true,
          backgroundColor: const Color(0xFF1C120B),
          foregroundColor: const Color(0xFFFFF7ED),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<AppRole>(
                  value: _role,
                  dropdownColor: const Color(0xFF431407),
                  iconEnabledColor: const Color(0xFFFFF7ED),
                  style: const TextStyle(
                    color: Color(0xFFFFF7ED),
                    fontWeight: FontWeight.w800,
                  ),
                  items: const <DropdownMenuItem<AppRole>>[
                    DropdownMenuItem(
                      value: AppRole.customer,
                      child: Text('Customer'),
                    ),
                    DropdownMenuItem(value: AppRole.staff, child: Text('POS')),
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
          backgroundColor: const Color(0xFFFFF7ED),
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
            label: 'Order',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
        ];
      case AppRole.staff:
        return const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.point_of_sale),
            label: 'Order Masuk',
          ),
          NavigationDestination(icon: Icon(Icons.check_circle), label: 'Siap'),
        ];
      case AppRole.admin:
        return const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Menu'),
          NavigationDestination(icon: Icon(Icons.analytics), label: 'Laporan'),
        ];
    }
  }

  Widget _buildBody() {
    switch (_role) {
      case AppRole.customer:
        return <Widget>[_customerOrderPage(), _customerOrders()][_tabIndex];
      case AppRole.staff:
        return <Widget>[_posOrders(), _readyOrders()][_tabIndex];
      case AppRole.admin:
        return <Widget>[_adminMenu(), _salesSummary()][_tabIndex];
    }
  }

  Widget _customerOrderPage() {
    final DateTime readyDate = _readyDate();
    final int total = _cart.fold(
      0,
      (int sum, CartLine line) => sum + line.subtotal,
    );
    final int portions = _cart.fold(
      0,
      (int sum, CartLine line) => sum + line.qty,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        _webLikeHero(),
        const SizedBox(height: 16),
        const Text(
          'ORDER ONLINE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFFF7ED),
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pilih menu kesukaan Anda di bawah ini',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFFED7AA)),
        ),
        const SizedBox(height: 14),
        ..._menu.map(_webMenuCard),
        const SizedBox(height: 12),
        _cartPanel(total: total, portions: portions, readyDate: readyDate),
      ],
    );
  }

  Widget _webLikeHero() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF1C120B),
            Color(0xFF7C2D12),
            Color(0xFFC2410C),
          ],
        ),
        border: Border.all(color: const Color(0xFFFACC15), width: 1.4),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFACC15),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'WAROENG KOLONG',
              style: TextStyle(
                color: Color(0xFF431407),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Cita Rasa Meresap Sampai ke Hati',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFFFEDD5)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Mie Rebus Medan',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            '&',
            style: TextStyle(
              color: Color(0xFFFACC15),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'Lontong Medan',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: const <Widget>[
              _HeroBadge('🌙 100% Halal'),
              _HeroBadge('🔥 Fresh Cooked'),
              _HeroBadge('💎 Premium Taste'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _webMenuCard(MenuItem item) {
    final bool inCart = _cart.any((CartLine line) => line.item.id == item.id);
    return InkWell(
      onTap: item.available ? () => _addToCart(item) : null,
      borderRadius: BorderRadius.circular(22),
      child: Card(
        color: const Color(0xFFFFF7ED),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xFFFED7AA),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFF97316)),
                ),
                child: const Icon(
                  Icons.ramen_dining,
                  color: Color(0xFFC2410C),
                  size: 34,
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
                        color: Color(0xFF431407),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(color: Color(0xFF7C2D12)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _rupiah(item.price),
                      style: const TextStyle(
                        color: Color(0xFFC2410C),
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      inCart ? 'Klik untuk tambah 1 porsi' : 'Klik untuk pesan',
                      style: const TextStyle(
                        color: Color(0xFF9A3412),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.add_circle, color: Color(0xFFC2410C)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cartPanel({
    required int total,
    required int portions,
    required DateTime readyDate,
  }) {
    final bool canSubmit = _canSubmitOrder;
    return Card(
      color: const Color(0xFFFFF7ED),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '🛒 Keranjang Anda',
              style: TextStyle(
                color: Color(0xFF431407),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            if (_cart.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      color: Color(0xFF9A3412),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            else
              ..._cart.map(_cartLine),
            const Divider(height: 28),
            _InfoRow(label: 'Total:', value: _rupiah(total), bold: true),
            const SizedBox(height: 12),
            _orderRules(readyDate: readyDate, portions: portions),
            const SizedBox(height: 14),
            _paymentBox(),
            const SizedBox(height: 14),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap Anda',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'No. WhatsApp Anda (Cth: 0812...)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Catatan (Cth: Pedes dikit aja, mie dipisah)',
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => setState(
                () => _paymentProofSelected = !_paymentProofSelected,
              ),
              icon: Icon(
                _paymentProofSelected ? Icons.check_circle : Icons.upload_file,
              ),
              label: Text(
                _paymentProofSelected
                    ? 'Bukti bayar / screenshot sudah dipilih'
                    : 'Wajib Upload Bukti Bayar / Screenshot',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'MVP Android: upload file asli akan disambungkan ke API. Saat ini tombol ini menandai bukti bayar sudah dipilih untuk validasi order.',
              style: TextStyle(fontSize: 12, color: Color(0xFF7C2D12)),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: canSubmit ? _submitOrder : null,
                icon: const Icon(Icons.payments),
                label: const Text('BUAT PESANAN & BAYAR 📲'),
              ),
            ),
            if (!canSubmit) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                _submitHint,
                style: const TextStyle(
                  color: Color(0xFFB91C1C),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _cartLine(CartLine line) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: line.validMinimum
              ? const Color(0xFFFED7AA)
              : const Color(0xFFDC2626),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  line.item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF431407),
                  ),
                ),
              ),
              IconButton(
                onPressed: () =>
                    setState(() => line.qty = (line.qty - 1).clamp(1, 999)),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                '${line.qty}',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
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
          _InfoRow(label: 'Subtotal', value: _rupiah(line.subtotal)),
          if (!line.validMinimum)
            const Text(
              'Minimal 20 porsi untuk menu ini.',
              style: TextStyle(
                color: Color(0xFFB91C1C),
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }

  Widget _orderRules({required DateTime readyDate, required int portions}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDD5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Info order online:',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF431407),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Minimal 20 porsi per menu dan pemesanan H-3.',
            style: TextStyle(color: Color(0xFF7C2D12)),
          ),
          Text(
            'Ready paling cepat ${_dateLabel(readyDate)}.',
            style: const TextStyle(
              color: Color(0xFF7C2D12),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Jumlah pesanan: $portions porsi. Setiap menu yang dipesan minimal 20 porsi.',
            style: const TextStyle(color: Color(0xFF7C2D12)),
          ),
        ],
      ),
    );
  }

  Widget _paymentBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Silakan melakukan pembayaran melalui Transfer Bank atau E-Wallet di bawah ini:',
            style: TextStyle(color: Color(0xFF431407)),
          ),
          SizedBox(height: 8),
          Text(
            '🏦 Bank Transfer:',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF431407),
            ),
          ),
          Text('BCA: 0461964345\na/n Atika Zuharniaty Kesuma'),
          SizedBox(height: 8),
          Text(
            '📱 E-Wallet:',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF431407),
            ),
          ),
          Text('ShopeePay: 082179717972\na/n Atika Zuharniaty Kesuma'),
        ],
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

  bool get _canSubmitOrder {
    return _cart.isNotEmpty &&
        _cart.every((CartLine line) => line.validMinimum) &&
        _nameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _paymentProofSelected;
  }

  String get _submitHint {
    if (_cart.isEmpty) {
      return 'Pilih menu dulu.';
    }
    if (_cart.any((CartLine line) => !line.validMinimum)) {
      return 'Setiap menu yang dipesan minimal 20 porsi.';
    }
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      return 'Nama dan WhatsApp wajib diisi.';
    }
    if (!_paymentProofSelected) {
      return 'Bukti bayar / screenshot wajib ditandai dulu.';
    }
    return '';
  }

  void _submitOrder() {
    final String code = 'WK-${(_orders.length + 1).toString().padLeft(3, '0')}';
    final Order order = Order(
      code: code,
      customerName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      note: _noteController.text.trim(),
      createdAt: DateTime.now(),
      readyDate: _readyDate(),
      items: _cart
          .map(
            (CartLine line) => OrderItem(
              name: line.item.name,
              qty: line.qty,
              price: line.item.price,
            ),
          )
          .toList(),
    );
    setState(() {
      _orders.insert(0, order);
      _cart.clear();
      _paymentProofSelected = false;
      _tabIndex = 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pesanan $code dibuat atas nama ${order.customerName}'),
      ),
    );
  }

  Widget _customerOrders() {
    final String name = _nameController.text.trim().toLowerCase();
    final List<Order> customerOrders = _orders
        .where((Order order) => order.customerName.toLowerCase() == name)
        .toList();
    return _pageShell(
      title: 'Pesanan Saya',
      children: <Widget>[
        if (customerOrders.isEmpty)
          const _EmptyState(
            icon: Icons.receipt_long,
            title: 'Belum ada pesanan',
            message: 'Pesanan yang dibuat dari app akan tampil di sini.',
          ),
        ...customerOrders.map(_orderCard),
      ],
    );
  }

  Widget _posOrders() {
    return _pageShell(
      title: 'POS - Order Masuk',
      subtitle: 'Cari kode/nama dari pelanggan, lalu update status pesanan.',
      children: _orders
          .where(
            (Order order) =>
                order.status != OrderStatus.selesai &&
                order.status != OrderStatus.batal,
          )
          .map(_orderCard)
          .toList(),
    );
  }

  Widget _readyOrders() {
    final List<Order> ready = _orders
        .where((Order order) => order.status == OrderStatus.siapDiambil)
        .toList();
    return _pageShell(
      title: 'Order Siap Diambil',
      children: <Widget>[
        if (ready.isEmpty)
          const _EmptyState(
            icon: Icons.check_circle_outline,
            title: 'Belum ada order siap',
            message: 'Order status Siap Diambil akan tampil di sini.',
          ),
        ...ready.map(_orderCard),
      ],
    );
  }

  Widget _orderCard(Order order) {
    return Card(
      color: const Color(0xFFFFF7ED),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      color: Color(0xFF431407),
                    ),
                  ),
                ),
                Chip(label: Text(_statusLabel(order.status))),
              ],
            ),
            Text('WA: ${order.phone} • Ready ${_dateLabel(order.readyDate)}'),
            if (order.note.isNotEmpty) Text('Catatan: ${order.note}'),
            const SizedBox(height: 8),
            ...order.items.map(
              (OrderItem item) => Text('• ${item.qty}x ${item.name}'),
            ),
            const Divider(),
            _InfoRow(label: 'Total', value: _rupiah(order.total), bold: true),
            _InfoRow(label: 'Pembayaran', value: order.paymentMethod),
            _InfoRow(label: 'Bukti bayar', value: order.paymentProofLabel),
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
    return _pageShell(
      title: 'Admin - Menu Web',
      subtitle: 'Menu mengikuti landing/order page Waroeng Kolong.',
      children: _menu.asMap().entries.map((MapEntry<int, MenuItem> entry) {
        final int index = entry.key;
        final MenuItem item = entry.value;
        return Card(
          color: const Color(0xFFFFF7ED),
          child: SwitchListTile(
            title: Text(
              item.name,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF431407),
              ),
            ),
            subtitle: Text('${_rupiah(item.price)} • minimal 20 porsi/menu'),
            value: item.available,
            onChanged: (bool value) =>
                setState(() => _menu[index] = item.copyWith(available: value)),
          ),
        );
      }).toList(),
    );
  }

  Widget _salesSummary() {
    final int doneRevenue = _orders
        .where((Order order) => order.status == OrderStatus.selesai)
        .fold(0, (int sum, Order order) => sum + order.total);
    final int activeRevenue = _orders
        .where((Order order) => order.status != OrderStatus.batal)
        .fold(0, (int sum, Order order) => sum + order.total);
    return _pageShell(
      title: 'Ringkasan Penjualan',
      children: <Widget>[
        _MetricCard(
          label: 'Order aktif',
          value:
              '${_orders.where((Order order) => order.status != OrderStatus.selesai && order.status != OrderStatus.batal).length}',
        ),
        _MetricCard(
          label: 'Porsi aktif',
          value:
              '${_orders.where((Order order) => order.status != OrderStatus.batal).fold(0, (int sum, Order order) => sum + order.totalPortions)}',
        ),
        _MetricCard(label: 'Omzet potensial', value: _rupiah(activeRevenue)),
        _MetricCard(label: 'Omzet selesai', value: _rupiah(doneRevenue)),
      ],
    );
  }

  Widget _pageShell({
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFFFF7ED),
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Color(0xFFFED7AA))),
        ],
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  DateTime _readyDate() => DateTime.now().add(const Duration(days: 3));

  String _rupiah(int value) {
    final String raw = value.toString();
    final StringBuffer out = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      final int remaining = raw.length - i;
      out.write(raw[i]);
      if (remaining > 1 && remaining % 3 == 1) out.write('.');
    }
    return 'Rp $out';
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

  String _dateLabel(DateTime value) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${value.day} ${months[value.month - 1]} ${value.year}';
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFFFF7ED),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
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
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
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
      color: const Color(0xFFFFF7ED),
      child: ListTile(
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFFC2410C),
          ),
        ),
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
      color: const Color(0xFFFFF7ED),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 48, color: const Color(0xFFC2410C)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Color(0xFF431407),
              ),
            ),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
