import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// AppTheme - Centralized Design System untuk Medical Dashboard
// =============================================================================
//
// MENGAPA FILE INI ADA?
// Semua warna, tipografi, dan styling dikumpulkan di satu tempat agar:
// 1. Konsistensi visual terjaga di seluruh aplikasi
// 2. Perubahan tema cukup dilakukan di satu file
// 3. Menghindari "magic numbers" (warna/ukuran hardcode) tersebar di widgets
//
// CARA KERJA:
// Widget mengakses tema via Theme.of(context), bukan langsung ke konstanta.
// Ini mengikuti prinsip Material Design 3 dan memungkinkan dark mode di masa depan.
// =============================================================================

/// Kelas abstrak yang menyimpan seluruh konfigurasi tema aplikasi.
/// Abstrak agar tidak bisa di-instantiate — hanya menyediakan static members.
abstract class AppTheme {
  // ---------------------------------------------------------------------------
  // Color Palette - Warna medis yang profesional dan mudah dibaca
  // ---------------------------------------------------------------------------

  /// Biru utama — warna identitas dashboard medis, memberi kesan tenang & profesional
  static const Color primaryBlue = Color(0xFF1A73E8);

  /// Merah darurat — untuk indikator kritis dan tombol emergency
  static const Color emergencyRed = Color(0xFFE53935);

  /// Hijau sehat — untuk status normal dan indikator "sudah diberikan"
  static const Color healthyGreen = Color(0xFF43A047);

  /// Oranye peringatan — untuk nilai borderline dan status "pending"
  static const Color warningOrange = Color(0xFFFB8C00);

  /// Abu-abu latar — warna background Scaffold yang lembut
  static const Color backgroundGray = Color(0xFFF5F7FA);

  /// Putih kartu — surface color untuk Card widgets
  static const Color cardWhite = Colors.white;

  /// Teks utama — kontras tinggi untuk aksesibilitas
  static const Color textPrimary = Color(0xFF1A1C1E);

  /// Teks sekunder — untuk label dan deskripsi
  static const Color textSecondary = Color(0xFF6B7280);

  // ---------------------------------------------------------------------------
  // Theme Configuration
  // ---------------------------------------------------------------------------

  /// Menghasilkan ThemeData lengkap untuk MaterialApp.
  ///
  /// Menggunakan Material Design 3 (useMaterial3: true) dengan ColorScheme
  /// yang di-generate dari seed color, lalu di-override untuk kebutuhan medis.
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,

      // ColorScheme.fromSeed menghasilkan palet warna harmonis dari satu warna dasar.
      // Kita override beberapa slot agar sesuai dengan identitas visual medis.
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        error: emergencyRed,
        surface: cardWhite,
        brightness: Brightness.light,
      ),

      // Scaffold background menggunakan abu-abu lembut, bukan putih polos,
      // agar kartu-kartu terlihat "terangkat" (elevated) secara visual.
      scaffoldBackgroundColor: backgroundGray,

      // Tipografi menggunakan Poppins — font modern yang mudah dibaca
      // untuk konteks medis. Google Fonts akan men-download font saat pertama kali
      // dijalankan; jika offline, fallback ke system font.
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),

      // AppBar styling — header biru solid dengan teks putih
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Card styling — rounded corners dan shadow halus
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
