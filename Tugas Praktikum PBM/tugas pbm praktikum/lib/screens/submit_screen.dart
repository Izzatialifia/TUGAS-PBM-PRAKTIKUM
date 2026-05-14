import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/product_service.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _githubController = TextEditingController();
  bool _isLoading = false;
  bool _submitted = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Konfirmasi Submit',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Pastikan data sudah benar. Submit tidak dapat diubah setelah dikirim.',
          style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal',
                style: GoogleFonts.plusJakartaSans(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3ECFCF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Submit',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF0F0F1A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    setState(() => _isLoading = true);

    try {
      final result = await ProductService.submitTugas(
        name: _nameController.text.trim(),
        price: int.parse(_priceController.text.trim()),
        description: _descController.text.trim(),
        githubUrl: _githubController.text.trim(),
      );

      if (!mounted) return;

      if (result['success'] == true) {
        setState(() => _submitted = true);
      } else {
        _showError(result['message'] ?? 'Submit gagal');
      }
    } catch (e) {
      _showError('Terjadi kesalahan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.plusJakartaSans()),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Submit Tugas',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: _submitted ? _buildSuccessView() : _buildForm(),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF22C55E), Color(0xFF3ECFCF)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22C55E).withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 28),
            Text(
              'Tugas Berhasil Disubmit!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Waktu submit telah tercatat otomatis oleh sistem.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.white54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'Kembali ke Beranda',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF3ECFCF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFF3ECFCF).withOpacity(0.3), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: Color(0xFF3ECFCF), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Data tidak dapat diubah setelah submit. Pastikan data sudah benar!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF3ECFCF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildLabel('Nama Produk'),
            const SizedBox(height: 8),
            _buildField(
              controller: _nameController,
              hint: 'Nama produk untuk submit',
              icon: Icons.label_outline_rounded,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Nama tidak boleh kosong' : null,
            ),
            const SizedBox(height: 20),
            _buildLabel('Harga (Rp)'),
            const SizedBox(height: 8),
            _buildField(
              controller: _priceController,
              hint: 'cth. 35000',
              icon: Icons.attach_money_rounded,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Harga tidak boleh kosong';
                if (int.tryParse(v) == null) return 'Angka tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildLabel('Deskripsi'),
            const SizedBox(height: 8),
            _buildField(
              controller: _descController,
              hint: 'Deskripsi produk...',
              icon: Icons.description_outlined,
              maxLines: 3,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
            ),
            const SizedBox(height: 20),
            _buildLabel('Link GitHub Repository'),
            const SizedBox(height: 8),
            _buildField(
              controller: _githubController,
              hint: 'https://github.com/username/repo',
              icon: Icons.link_rounded,
              validator: (v) {
                if (v == null || v.isEmpty) return 'GitHub URL tidak boleh kosong';
                if (!v.startsWith('https://github.com/')) {
                  return 'Masukkan URL GitHub yang valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3ECFCF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Color(0xFF0F0F1A), strokeWidth: 2.5),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send_rounded,
                              color: Color(0xFF0F0F1A), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Submit Tugas',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF0F0F1A),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 15),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(color: Colors.white24, fontSize: 14),
        prefixIcon: maxLines == 1
            ? Icon(icon, color: Colors.white38, size: 20)
            : null,
        filled: true,
        fillColor: const Color(0xFF1C1C2E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2A2A3E), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3ECFCF), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
