import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/models/patient_model.dart';

// =============================================================================
// HealthMetricCard - Kartu Satuan Metrik Kesehatan
// =============================================================================
//
// WIDGET LAYOUT YANG DIGUNAKAN: Column
//
// MENGAPA COLUMN?
// Setiap kartu metrik menyusun elemen secara VERTIKAL: ikon di atas, lalu nilai,
// lalu unit dan label di bawah. Column adalah pilihan tepat karena:
// - Jumlah children TETAP dan SEDIKIT (5-6 widget) — tidak perlu scrolling
// - Urutan vertikal dari atas ke bawah sesuai hierarki informasi medis:
//   ikon → angka (paling penting) → unit → label → status
// - mainAxisAlignment: center memastikan konten terpusat vertikal dalam kartu
//
// MENGAPA BUKAN ListView?
// ListView cocok untuk daftar panjang yang perlu di-scroll. Di sini hanya ada
// 5-6 elemen tetap, sehingga Column lebih ringan dan tidak memerlukan scroll.
// =============================================================================

class HealthMetricCard extends StatelessWidget {
  final HealthMetric metric;

  const HealthMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // COLUMN — Menyusun elemen vertikal di dalam kartu
      //
      // mainAxisAlignment: center → konten terpusat secara vertikal
      // mainAxisSize: MainAxisSize.min → Column hanya setinggi kontennya,
      //   tidak memaksakan tinggi penuh. Ini penting karena kartu di dalam
      //   Row/Wrap yang sudah mengatur tinggi via crossAxisAlignment.
      // -----------------------------------------------------------------------
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ikon dalam lingkaran berwarna — visual cue untuk jenis metrik
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: metric.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(metric.icon, color: metric.color, size: 28),
          ),
          const SizedBox(height: 12),

          // Nilai metrik — elemen paling penting, font paling besar
          Text(
            metric.value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),

          // Unit pengukuran — lebih kecil dari nilai, warna sekunder
          Text(
            metric.unit,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),

          // Label metrik — nama parameter yang diukur
          Text(
            metric.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Badge status — indikator visual hijau/oranye/merah
          _buildStatusBadge(context),
        ],
      ),
    );
  }

  /// Membuat badge kecil yang menunjukkan status metrik.
  /// Warna badge disesuaikan: hijau = normal, oranye = warning, merah = critical.
  Widget _buildStatusBadge(BuildContext context) {
    final Color badgeColor;
    switch (metric.status) {
      case 'normal':
        badgeColor = AppTheme.healthyGreen;
      case 'warning':
        badgeColor = AppTheme.warningOrange;
      case 'critical':
        badgeColor = AppTheme.emergencyRed;
      default:
        badgeColor = AppTheme.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        metric.status.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
