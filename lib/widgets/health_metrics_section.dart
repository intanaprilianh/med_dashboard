import 'package:flutter/material.dart';
import 'package:flutter_application_5/models/patient_model.dart';
import 'package:flutter_application_5/widgets/health_metric_card.dart';

// =============================================================================
// HealthMetricsSection - Grid Responsif Metrik Kesehatan
// =============================================================================
//
// WIDGET LAYOUT YANG DIGUNAKAN: Row & Column (+ Wrap untuk responsivitas)
//
// === MENGAPA ROW? ===
// Row menyusun widget secara HORIZONTAL (kiri ke kanan). Di sini, 4 kartu metrik
// ditampilkan berdampingan karena:
// - Perbandingan cepat: dokter/perawat bisa scan semua vital sign sekaligus
// - Memanfaatkan lebar layar tablet/desktop secara optimal
// - Jumlah item tetap (4) dan diketahui saat compile time
//
// Row vs ListView horizontal:
// - Row: untuk jumlah item TETAP dan SEDIKIT, tidak scroll
// - ListView: untuk jumlah item DINAMIS atau BANYAK, bisa scroll
//
// === MENGAPA COLUMN? ===
// Column membungkus seluruh section secara vertikal: judul "Health Metrics"
// di atas, lalu grid kartu di bawah. Ini adalah pola umum untuk section layout.
//
// === MENGAPA LayoutBuilder? ===
// LayoutBuilder memberikan CONSTRAINTS dari parent widget, bukan ukuran layar.
// Ini lebih akurat dari MediaQuery karena memperhitungkan padding, sidebar, dll.
// - >= 600px: Row dengan 4 Expanded children (bagi rata horizontal)
// - < 600px: Wrap dengan 2 kartu per baris (responsif untuk HP)
//
// === MENGAPA Expanded di dalam Row? ===
// Tanpa Expanded, setiap kartu akan meminta lebar sesuai kontennya, dan jika
// total melebihi lebar Row, terjadi OVERFLOW (garis kuning-hitam).
// Expanded memastikan setiap kartu mendapat PORSI SAMA dari sisa ruang.
// Flex factor default = 1, sehingga 4 Expanded = masing-masing dapat 25%.
// =============================================================================

class HealthMetricsSection extends StatelessWidget {
  final List<HealthMetric> metrics;

  const HealthMetricsSection({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------
    // COLUMN — Menyusun judul section dan grid metrik secara vertikal
    //
    // crossAxisAlignment: start → judul rata kiri (bukan center)
    // mainAxisSize: min → Column tidak memaksa tinggi penuh,
    //   hanya setinggi kontennya. Penting di dalam ScrollView.
    // -------------------------------------------------------------------------
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Judul section
        Text(
          'Health Metrics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // LayoutBuilder mendeteksi lebar yang tersedia dari parent
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return _buildWideLayout();
            }
            return _buildNarrowLayout(constraints.maxWidth);
          },
        ),
      ],
    );
  }

  /// Layout LEBAR (>= 600px): Satu Row dengan 4 kartu berdampingan.
  ///
  /// ```
  /// | Heart Rate | Temperature | Blood Pressure | SpO2 |
  /// ```
  ///
  /// ROW mengatur distribusi horizontal. Setiap kartu dibungkus EXPANDED
  /// agar mendapat porsi lebar yang sama (25% masing-masing).
  Widget _buildWideLayout() {
    // -------------------------------------------------------------------------
    // IntrinsicHeight memberikan Row tinggi terbatas berdasarkan child tertinggi.
    //
    // MENGAPA PERLU IntrinsicHeight?
    // Row dengan crossAxisAlignment: stretch membutuhkan tinggi TERBATAS dari parent.
    // Tapi di dalam SingleChildScrollView → Column, tinggi = INFINITY.
    // IntrinsicHeight mengukur tinggi intrinsik children terlebih dahulu,
    // lalu memberikan constraint tinggi terbatas ke Row.
    //
    // CATATAN: IntrinsicHeight sedikit lebih "mahal" karena melakukan dua
    // pass layout (measure + layout). Untuk 4 kartu ini, performanya negligible.
    // -------------------------------------------------------------------------
    return IntrinsicHeight(
      child: Row(
        // ---------------------------------------------------------------------
        // ROW — Menyusun 4 kartu metrik secara HORIZONTAL
        //
        // crossAxisAlignment: stretch → semua kartu memiliki TINGGI SAMA
        //   (mengikuti kartu tertinggi). Ini membuat grid terlihat rapi.
        //
        // Tanpa crossAxisAlignment: stretch, kartu dengan label pendek
        // akan lebih pendek dari kartu dengan label panjang.
        // ---------------------------------------------------------------------
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildCardsWithSpacing(useExpanded: true),
      ),
    );
  }

  /// Layout SEMPIT (< 600px): Wrap menampilkan 2 kartu per baris.
  ///
  /// ```
  /// | Heart Rate  | Temperature    |
  /// | Blood Press | SpO2           |
  /// ```
  ///
  /// WRAP vs Column of Rows:
  /// Wrap secara otomatis memindahkan item ke baris berikutnya ketika
  /// tidak cukup ruang. Tidak perlu hitung manual berapa item per baris.
  Widget _buildNarrowLayout(double maxWidth) {
    // Lebar per kartu = setengah lebar tersedia dikurangi jarak antar kartu
    final cardWidth = (maxWidth - 12) / 2;

    return Wrap(
      spacing: 12,      // jarak horizontal antar kartu
      runSpacing: 12,   // jarak vertikal antar baris
      children: metrics.map((metric) {
        return SizedBox(
          width: cardWidth,
          child: HealthMetricCard(metric: metric),
        );
      }).toList(),
    );
  }

  /// Membuat list kartu dengan SizedBox sebagai spacer di antaranya.
  /// [useExpanded] = true membungkus setiap kartu dengan Expanded.
  List<Widget> _buildCardsWithSpacing({required bool useExpanded}) {
    final List<Widget> children = [];

    for (int i = 0; i < metrics.length; i++) {
      if (i > 0) {
        // SizedBox sebagai spacer horizontal — lebih ringan dari Padding
        children.add(const SizedBox(width: 12));
      }

      final card = HealthMetricCard(metric: metrics[i]);

      if (useExpanded) {
        // -------------------------------------------------------------------
        // EXPANDED — Memastikan setiap kartu mendapat bagian SAMA dari
        // sisa ruang di Row setelah spacer dihitung.
        //
        // Expanded flex: 1 (default) berarti semua kartu mendapat porsi sama.
        // Jika satu kartu perlu 2x lebih lebar, gunakan flex: 2.
        // -------------------------------------------------------------------
        children.add(Expanded(child: card));
      } else {
        children.add(card);
      }
    }

    return children;
  }
}
