import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';

// =============================================================================
// EmergencyButton - Tombol Panggil Bantuan Darurat
// =============================================================================
//
// WIDGET LAYOUT YANG DIGUNAKAN: Align
//
// === MENGAPA ALIGN? ===
// Align memposisikan SATU child di dalam area parentnya menggunakan
// koordinat fraksional. Sistem koordinatnya:
//
//   (-1, -1)  ←  top-left       (0, -1)  ←  top-center     (1, -1)  ←  top-right
//   (-1,  0)  ←  center-left    (0,  0)  ←  center         (1,  0)  ←  center-right
//   (-1,  1)  ←  bottom-left    (0,  1)  ←  bottom-center  (1,  1)  ←  bottom-right
//
// Alignment.bottomRight = Alignment(1.0, 1.0) = pojok kanan bawah.
//
// === ALIGN vs POSITIONED ===
// - Positioned HARUS berada di dalam Stack — menggunakan pixel offset (top, left, dll)
// - Align bisa digunakan di MANA SAJA — menggunakan koordinat fraksional (-1 s/d 1)
// - Align lebih fleksibel karena tidak bergantung pada parent tertentu
//
// Untuk tombol emergency yang harus "mengambang" di pojok kanan bawah dashboard,
// Align lebih tepat karena ia memposisikan dirinya relatif terhadap PARENT APAPUN
// yang membungkusnya, tanpa memerlukan Stack sebagai ancestor langsung.
//
// === ALIGN vs CENTER ===
// Center sebenarnya adalah Align dengan alignment: Alignment.center.
// Center adalah "shorthand" — Align memberikan kontrol penuh atas posisi.
//
// === MENGAPA MainAxisSize.min pada Row di dalam tombol? ===
// Tanpa MainAxisSize.min, Row akan mengembang mengisi seluruh lebar parent.
// Dengan min, Row hanya selebar kontennya (ikon + teks), sehingga tombol
// berukuran compact dan tidak memakan seluruh lebar layar.
// =============================================================================

class EmergencyButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const EmergencyButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------
    // ALIGN — Memposisikan tombol di pojok kanan bawah parent
    //
    // Ini adalah demonstrasi utama widget Align. Tombol emergency secara logis
    // harus SELALU terlihat dan mudah dijangkau — pojok kanan bawah adalah
    // posisi alami karena dekat dengan ibu jari pengguna pada smartphone.
    //
    // Alignment.bottomRight adalah convenience constant untuk Alignment(1.0, 1.0).
    // Jika ingin offset custom, bisa gunakan Alignment(0.8, 0.9) misalnya.
    // -------------------------------------------------------------------------
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildButton(context),
      ),
    );
  }

  /// Membangun visual tombol emergency dengan gradient dan shadow.
  Widget _buildButton(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      // Shadow merah di bawah tombol untuk efek "glow" — menarik perhatian
      shadowColor: AppTheme.emergencyRed.withValues(alpha: 0.4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            // Gradient merah — dari terang ke gelap, memberi kesan kedalaman
            gradient: const LinearGradient(
              colors: [AppTheme.emergencyRed, Color(0xFFB71C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),

          // -------------------------------------------------------------------
          // ROW dengan MainAxisSize.min — tombol hanya selebar kontennya
          //
          // MainAxisSize.min adalah kunci di sini. Tanpa ini, Row akan expand
          // mengisi seluruh lebar yang diberikan Align, membuat tombol
          // memanjang ke kiri-kanan selebar layar.
          //
          // Dengan min, Row "membungkus" (shrink-wrap) kontennya saja.
          // -------------------------------------------------------------------
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emergency,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Emergency Call',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
