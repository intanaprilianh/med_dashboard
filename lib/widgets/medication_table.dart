import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/models/patient_model.dart';

// =============================================================================
// MedicationTable - Tabel Jadwal Obat dan Hasil Laboratorium
// =============================================================================
//
// WIDGET LAYOUT YANG DIGUNAKAN: Table
//
// === MENGAPA TABLE? ===
// Table adalah widget yang dirancang khusus untuk data TABULAR — informasi
// yang memiliki BARIS dan KOLOM yang harus sejajar secara vertikal.
//
// Keunggulan Table dibanding alternatif:
//
// Table vs Row-di-dalam-Column (manual grid):
//   - Table OTOMATIS menyejajarkan kolom di semua baris.
//   - Jika kita pakai Row per baris, setiap Row menghitung lebar sendiri-sendiri,
//     dan kolom tidak akan sejajar kecuali kita hardcode lebar setiap sel.
//   - Table mendukung columnWidths untuk mengatur proporsi per kolom.
//
// Table vs GridView:
//   - GridView untuk grid HOMOGEN (semua sel ukuran sama), seperti galeri foto.
//   - Table untuk data HETEROGEN di mana setiap kolom bisa punya lebar berbeda.
//   - Table tidak scroll — cocok untuk data yang jumlahnya diketahui dan sedikit.
//
// Table vs DataTable:
//   - DataTable adalah wrapper Material di atas Table, menambahkan sorting,
//     checkbox, dan styling bawaan. Bagus untuk data interaktif.
//   - Table murni lebih ringan dan fleksibel untuk styling custom.
//   - Kita pakai Table murni agar demonstrasi widget lebih jelas.
//
// === MENGAPA FlexColumnWidth? ===
// FlexColumnWidth mendistribusikan lebar secara PROPORSIONAL.
// Contoh: jika kolom A = FlexColumnWidth(2) dan kolom B = FlexColumnWidth(1),
// maka kolom A mendapat 2x lebar kolom B. Ini membuat tabel responsif
// karena proporsi terjaga di berbagai ukuran layar.
//
// Alternatif:
// - FixedColumnWidth(100) → lebar absolut 100px, TIDAK responsif
// - IntrinsicColumnWidth() → lebar mengikuti konten terlebar, bisa mahal
// =============================================================================

class MedicationTable extends StatelessWidget {
  final List<Medication> medications;
  final List<LabResult> labResults;

  const MedicationTable({
    super.key,
    required this.medications,
    required this.labResults,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan tab selector
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                'Medical Records',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // TabBar untuk beralih antara Medications dan Lab Results
            const TabBar(
              labelColor: AppTheme.primaryBlue,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.primaryBlue,
              padding: EdgeInsets.symmetric(horizontal: 12),
              tabs: [
                Tab(text: 'Medications'),
                Tab(text: 'Lab Results'),
              ],
              dividerHeight: 0,
            ),

            // Konten tab — tinggi tetap agar layout stabil
            SizedBox(
              height: _calculateTableHeight(),
              child: TabBarView(
                children: [
                  _buildMedicationTab(context),
                  _buildLabResultsTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Hitung tinggi tabel berdasarkan jumlah data terbanyak.
  double _calculateTableHeight() {
    final maxRows = medications.length > labResults.length
        ? medications.length
        : labResults.length;
    // Header (48) + setiap baris (48) + padding (32)
    return 48 + (maxRows * 48) + 32;
  }

  // ===========================================================================
  // TAB 1: Tabel Jadwal Obat
  // ===========================================================================
  Widget _buildMedicationTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Table(
        // -------------------------------------------------------------------
        // columnWidths — Mendefinisikan PROPORSI lebar setiap kolom.
        //
        // FlexColumnWidth(2.5) berarti kolom ini mendapat 2.5 "bagian" dari
        // total ruang. Jika total flex = 2.5 + 1.0 + 1.0 + 1.5 = 6.0,
        // maka kolom pertama mendapat 2.5/6.0 = ~42% lebar tabel.
        //
        // Kolom nama obat paling lebar karena nama obat bisa panjang.
        // Kolom waktu paling sempit karena hanya berisi "08:00".
        // -------------------------------------------------------------------
        columnWidths: const {
          0: FlexColumnWidth(2.5),  // Nama obat — perlu ruang terbanyak
          1: FlexColumnWidth(1.0),  // Dosis
          2: FlexColumnWidth(1.0),  // Waktu
          3: FlexColumnWidth(1.5),  // Status
        },

        // -------------------------------------------------------------------
        // border — Table mendukung border antar sel, fitur yang TIDAK ada
        // di Row/Column. Ini penting untuk tabel data agar mata pembaca
        // bisa mengikuti baris dengan benar (terutama tabel lebar).
        //
        // Kita hanya pakai horizontalInside agar tampilan bersih dan modern
        // (tanpa garis vertikal dan border luar).
        // -------------------------------------------------------------------
        border: TableBorder(
          horizontalInside: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),

        // Penyelarasan vertikal sel — semua sel terpusat secara vertikal
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,

        children: [
          // Header row
          _buildMedicationHeader(context),
          // Data rows
          ...medications.map(
            (med) => _buildMedicationRow(med, context),
          ),
        ],
      ),
    );
  }

  /// Header tabel obat — background abu-abu untuk membedakan dari data.
  TableRow _buildMedicationHeader(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(
        color: AppTheme.backgroundGray,
        borderRadius: BorderRadius.circular(8),
      ),
      children: [
        _buildHeaderCell('Medication', context),
        _buildHeaderCell('Dose', context),
        _buildHeaderCell('Time', context),
        _buildHeaderCell('Status', context),
      ],
    );
  }

  /// Satu baris data obat di dalam tabel.
  TableRow _buildMedicationRow(Medication med, BuildContext context) {
    return TableRow(
      children: [
        // Nama obat dengan ikon pil
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.medication,
                size: 16,
                color: AppTheme.primaryBlue.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  med.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Dosis
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            med.dose,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        // Waktu pemberian
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            med.time,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        // Status dengan chip berwarna
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: _buildMedicationStatusChip(med.status, context),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 2: Tabel Hasil Laboratorium
  // ===========================================================================
  Widget _buildLabResultsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Table(
        // Kolom proporsi untuk data lab — berbeda dari tab obat
        // karena "Normal Range" perlu lebih banyak ruang dari "Time"
        columnWidths: const {
          0: FlexColumnWidth(2.0),  // Nama tes
          1: FlexColumnWidth(1.5),  // Hasil
          2: FlexColumnWidth(1.5),  // Rentang normal
          3: FlexColumnWidth(1.2),  // Status
        },
        border: TableBorder(
          horizontalInside: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _buildLabHeader(context),
          ...labResults.map(
            (result) => _buildLabRow(result, context),
          ),
        ],
      ),
    );
  }

  /// Header tabel lab results.
  TableRow _buildLabHeader(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(
        color: AppTheme.backgroundGray,
        borderRadius: BorderRadius.circular(8),
      ),
      children: [
        _buildHeaderCell('Test', context),
        _buildHeaderCell('Result', context),
        _buildHeaderCell('Range', context),
        _buildHeaderCell('Status', context),
      ],
    );
  }

  /// Satu baris data hasil lab.
  TableRow _buildLabRow(LabResult result, BuildContext context) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.science,
                size: 16,
                color: AppTheme.primaryBlue.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  result.testName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            result.result,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            result.normalRange,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: _buildLabStatusChip(result.status, context),
        ),
      ],
    );
  }

  // ===========================================================================
  // Helper Widgets
  // ===========================================================================

  /// Sel header — teks bold dengan padding.
  Widget _buildHeaderCell(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  /// Chip status obat — warna berbeda sesuai status.
  Widget _buildMedicationStatusChip(String status, BuildContext context) {
    final Color chipColor;
    switch (status) {
      case 'Taken':
        chipColor = AppTheme.healthyGreen;
      case 'Pending':
        chipColor = AppTheme.warningOrange;
      case 'Upcoming':
        chipColor = AppTheme.textSecondary;
      default:
        chipColor = AppTheme.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Chip status lab — Normal hijau, High merah, Low oranye.
  Widget _buildLabStatusChip(String status, BuildContext context) {
    final Color chipColor;
    switch (status) {
      case 'Normal':
        chipColor = AppTheme.healthyGreen;
      case 'High':
        chipColor = AppTheme.emergencyRed;
      case 'Low':
        chipColor = AppTheme.warningOrange;
      default:
        chipColor = AppTheme.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
