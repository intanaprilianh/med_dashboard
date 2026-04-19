import 'package:flutter/material.dart';
import 'package:flutter_application_5/models/patient_model.dart';
import 'package:flutter_application_5/widgets/emergency_button.dart';
import 'package:flutter_application_5/widgets/health_metrics_section.dart';
import 'package:flutter_application_5/widgets/medication_table.dart';
import 'package:flutter_application_5/widgets/patient_profile_card.dart';

// =============================================================================
// DashboardScreen - Layar Utama Dashboard Pemantauan Pasien
// =============================================================================
//
// File ini adalah KOMPOSITOR utama yang menyatukan semua widget layout
// menjadi satu dashboard yang kohesif. Di sinilah Anda bisa melihat
// bagaimana Row, Column, Stack, Align, dan Table bekerja BERSAMA.
//
// ===================================================================
// WIDGET TREE untuk dashboard ini:
//
//  Scaffold
//  ├── AppBar
//  │   ├── Text("Medical Dashboard")
//  │   └── Row[IconButton, IconButton]
//  └── Stack                              ← Layer: konten + tombol floating
//      ├── SingleChildScrollView          ← Konten bisa di-scroll
//      │   └── Column                     ← Vertikal: semua section berurutan
//      │       ├── PatientProfileCard     ← [STACK] - avatar + status overlay
//      │       ├── HealthMetricsSection   ← [ROW & COLUMN] - grid metrik
//      │       └── MedicationTable        ← [TABLE] - tabel obat & lab
//      └── EmergencyButton                ← [ALIGN] - floating bottom-right
//
// ===================================================================
//
// ===================================================================
// TIGA TREE DI FLUTTER — Apa yang Terjadi di Balik Layar
// ===================================================================
//
// Ketika Flutter membangun dashboard ini, TIGA struktur tree paralel dibuat:
//
// 1. WIDGET TREE (yang kita tulis di kode)
//    - Objek konfigurasi yang IMMUTABLE (tidak bisa diubah setelah dibuat)
//    - Dibangun ulang setiap kali setState dipanggil atau hot reload
//    - Ringan dan disposable — anggap sebagai "blueprint" atau "cetak biru"
//    - Contoh dari app ini:
//        MaterialApp → Scaffold → Stack → [SingleChildScrollView → Column → [...]]
//
// 2. ELEMENT TREE (pembukuan internal Flutter)
//    - Satu Element per Widget, tapi Element BERTAHAN (persistent) antar rebuild
//    - Element memegang "slot" di tree dan memutuskan apakah perlu UPDATE
//      atau RECREATE RenderObject yang bersesuaian
//    - Saat setState dipanggil, Flutter menelusuri Element tree, membandingkan
//      Widget lama dan baru (menggunakan runtimeType + key), dan hanya
//      memperbaiki bagian yang BERUBAH. Inilah mengapa Flutter cepat.
//    - Kita jarang berinteraksi langsung dengan Element, tapi Key (ValueKey,
//      GlobalKey) mempengaruhi bagaimana Element dicocokkan dengan Widget.
//
// 3. RENDER TREE (yang benar-benar menggambar piksel)
//    - RenderObject menangani LAYOUT (mengukur ukuran, memposisikan children)
//      dan PAINTING (menggambar ke canvas)
//    - TIDAK SEMUA Widget membuat RenderObject:
//      * Widget layout (Padding, Align, SizedBox) → membuat RenderObject
//      * Widget komposisi (StatelessWidget, Builder) → TIDAK membuat,
//        mereka hanya mengembalikan widget lain
//    - Di dashboard ini:
//      * Column → RenderFlex: mengukur tinggi setiap child, lalu susun vertikal
//      * Row → RenderFlex: mengukur lebar setiap child, lalu susun horizontal
//      * Stack → RenderStack: ukuran = child terbesar, Positioned di-offset
//      * Table → RenderTable: hitung lebar kolom dulu, lalu layout sel di grid
//      * Align → RenderPositionedBox: ambil satu child, posisikan dengan
//        alignment fraksional di dalam ruang yang tersedia
//
// MENGAPA INI PENTING:
// Memahami tiga tree menjelaskan mengapa:
// - Constructor "const" meningkatkan performa (Widget tidak berubah →
//   Element skip diffing → RenderObject tidak di-relayout)
// - Key penting untuk list (membantu Element mencocokkan Widget yang benar)
// - Beberapa widget "murah" dan yang lain "mahal" (tergantung kompleksitas
//   RenderObject — Table lebih mahal dari SizedBox)
// ===================================================================

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Buat instance model dari factory mock.
    // Di aplikasi nyata, data ini datang dari API/state management.
    final patient = Patient.mock();
    final metrics = HealthMetric.mockMetrics();
    final medications = Medication.mockMedications();
    final labResults = LabResult.mockResults();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
            tooltip: 'Settings',
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // STACK di level Scaffold body
      //
      // MENGAPA Stack di sini?
      // Kita ingin EmergencyButton "mengambang" di atas konten yang bisa
      // di-scroll. Stack memungkinkan kita MELAPISI:
      //   Layer 1: SingleChildScrollView (konten dashboard, bisa scroll)
      //   Layer 2: EmergencyButton (tetap di posisi, tidak ikut scroll)
      //
      // Ini adalah penggunaan KEDUA dari Stack di app ini, menunjukkan
      // versatilitasnya — bukan hanya untuk badge di foto, tapi juga untuk
      // floating UI elements seperti FAB custom.
      //
      // Perbedaan dengan FloatingActionButton bawaan Scaffold:
      // FAB sudah disediakan oleh Scaffold, tapi posisinya terbatas.
      // Dengan Stack + Align, kita punya kontrol penuh atas posisi,
      // ukuran, dan styling tombol floating.
      // -----------------------------------------------------------------------
      body: Stack(
        children: [
          // === LAYER 1: Konten Dashboard yang Bisa Di-scroll ===
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            // -----------------------------------------------------------------
            // COLUMN — Menyusun semua section secara VERTIKAL
            //
            // Column di sini adalah "spine" (tulang punggung) dari dashboard.
            // Setiap section (profil, metrik, tabel) disusun dari atas ke bawah.
            //
            // crossAxisAlignment: start → konten rata kiri
            // Tidak perlu mainAxisSize karena SingleChildScrollView sudah
            // memberikan ruang tak terbatas secara vertikal.
            // -----------------------------------------------------------------
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: Profil Pasien
                // Mendemonstrasikan STACK — avatar dengan status overlay
                PatientProfileCard(patient: patient),
                const SizedBox(height: 20),

                // Section 2: Metrik Kesehatan
                // Mendemonstrasikan ROW & COLUMN — grid responsif
                HealthMetricsSection(metrics: metrics),
                const SizedBox(height: 20),

                // Section 3: Tabel Rekam Medis
                // Mendemonstrasikan TABLE — data tabular terstruktur
                MedicationTable(
                  medications: medications,
                  labResults: labResults,
                ),

                // Extra space agar konten paling bawah tidak tertutup
                // oleh EmergencyButton yang floating di atasnya
                const SizedBox(height: 100),
              ],
            ),
          ),

          // === LAYER 2: Tombol Emergency Floating ===
          // Mendemonstrasikan ALIGN — posisi presisi di bottom-right
          EmergencyButton(
            onPressed: () => _showEmergencyDialog(context),
          ),
        ],
      ),
    );
  }

  /// Menampilkan dialog konfirmasi panggilan darurat.
  /// Memberikan feedback visual bahwa tombol berfungsi.
  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.emergency, color: Colors.red),
            SizedBox(width: 8),
            Text('Emergency Call'),
          ],
        ),
        content: const Text(
          'Are you sure you want to make an emergency call? '
          'This will alert the medical team immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emergency call initiated! Medical team alerted.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }
}
