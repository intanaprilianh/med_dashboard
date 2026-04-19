import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/screens/dashboard_screen.dart';

// =============================================================================
// Medical Dashboard - Entry Point Aplikasi
// =============================================================================
//
// Aplikasi ini mendemonstrasikan 5 widget layout utama Flutter:
//
// 1. ROW & COLUMN  → Health metrics tersusun dalam grid responsif
//    File: lib/widgets/health_metrics_section.dart
//
// 2. STACK          → Profil pasien dengan indikator status bertumpuk
//    File: lib/widgets/patient_profile_card.dart
//
// 3. ALIGN          → Tombol emergency diposisikan presisi di bottom-right
//    File: lib/widgets/emergency_button.dart
//
// 4. TABLE          → Jadwal obat dan hasil lab dalam tabel terstruktur
//    File: lib/widgets/medication_table.dart
//
// Arsitektur: main.dart sengaja dibuat TIPIS (thin). Semua logika,
// theming, dan komposisi widget ada di file-file terpisah sesuai
// prinsip Single Responsibility.
// =============================================================================

void main() {
  runApp(const MedicalDashboardApp());
}

/// Root widget aplikasi Medical Dashboard.
///
/// MaterialApp mengonfigurasi:
/// - Theme global dari [AppTheme.lightTheme()]
/// - Halaman utama: [DashboardScreen]
/// - debugShowCheckedModeBanner: false untuk tampilan bersih
class MedicalDashboardApp extends StatelessWidget {
  const MedicalDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      home: const DashboardScreen(),
    );
  }
}
