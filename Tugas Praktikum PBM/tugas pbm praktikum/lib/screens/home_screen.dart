import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_model.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import 'login_screen.dart';
import 'add_product_screen.dart';
import 'submit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String _userName = '';
  String _userNim = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final name = await AuthService.getUserName() ?? '';
    final nim = await AuthService.getUserNim() ?? '';
    setState(() {
      _userName = name;
      _userNim = nim;
    });
    await _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await ProductService.getProducts();
      setState(() => _products = products);
    } catch (e) {
      _showSnack('Gagal memuat produk: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteProduct(ProductModel p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Hapus Produk',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Yakin ingin menghapus "${p.name}"?',
          style: GoogleFonts.plusJakartaSans(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal',
                style: GoogleFonts.plusJakartaSans(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus',
                style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final result = await ProductService.deleteProduct(p.id);
      if (result['success'] == true) {
        _showSnack('Produk dihapus');
        _fetchProducts();
      } else {
        _showSnack('Gagal menghapus', isError: true);
      }
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.plusJakartaSans()),
        backgroundColor:
            isError ? const Color(0xFFEF4444) : const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildStats(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Draft Produk',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${_products.length} item',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6C63FF),
                      ),
                    )
                  : _products.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _fetchProducts,
                          color: const Color(0xFF6C63FF),
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: _products.length,
                            itemBuilder: (_, i) =>
                                _buildProductCard(_products[i]),
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'submit',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubmitScreen()),
              );
            },
            backgroundColor: const Color(0xFF3ECFCF),
            foregroundColor: const Color(0xFF0F0F1A),
            icon: const Icon(Icons.send_rounded),
            label: Text(
              'Submit',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () async {
              final added = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const AddProductScreen()),
              );
              if (added == true) _fetchProducts();
            },
            backgroundColor: const Color(0xFF6C63FF),
            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'NIM: $_userNim',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white38,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final totalHarga = _products.fold(0.0, (sum, p) => sum + p.price);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _statItem(
              label: 'Total Produk',
              value: '${_products.length}',
              icon: Icons.inventory_2_outlined,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white24,
          ),
          Expanded(
            child: _statItem(
              label: 'Total Nilai',
              value: 'Rp ${_formatNumber(totalHarga.toInt())}',
              icon: Icons.monetization_on_outlined,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    final s = n.toString();
    final result = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) result.write('.');
      result.write(s[i]);
      count++;
    }
    return result.toString().split('').reversed.join();
  }

  Widget _statItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada produk',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white38,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + untuk menambah produk',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white24,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A3E), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF6C63FF),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.formattedPrice,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3ECFCF),
                    ),
                  ),
                  if (p.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      p.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.white38,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: () => _deleteProduct(p),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white24,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
