import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/models/patient_model.dart';

// =============================================================================
// PatientProfileCard - Kartu Profil Pasien dengan Status Overlay
// =============================================================================
//
// WIDGET LAYOUT YANG DIGUNAKAN: Stack + Positioned
//
// === MENGAPA STACK? ===
// Stack memungkinkan widget BERTUMPUK (overlap) satu sama lain, seperti
// lapisan kertas. Di sini, kita menumpuk:
//   Layer 1 (bawah): Avatar/foto profil pasien
//   Layer 2 (tengah): Titik hijau indikator "online"
//   Layer 3 (atas):   Badge merah "emergency" (jika aktif)
//
// Ini TIDAK BISA dicapai dengan Row atau Column karena kedua widget tersebut
// menyusun children secara BERURUTAN (horizontal/vertikal), bukan BERTUMPUK.
//
// === MENGAPA POSITIONED? ===
// Di dalam Stack, child tanpa Positioned akan ditempatkan sesuai `alignment`
// (default: top-left). Positioned memberikan kontrol PIXEL-LEVEL untuk
// menempatkan widget di posisi spesifik menggunakan top/right/bottom/left.
//
// Contoh: Positioned(bottom: 2, right: 2) menempatkan titik online
// di pojok kanan bawah avatar, persis seperti indikator status di WhatsApp.
//
// === MENGAPA clipBehavior: Clip.none? ===
// Secara default, Stack memotong (clip) child yang keluar batasnya.
// Clip.none memperbolehkan badge emergency "menyembul" sedikit di luar
// batas avatar, menciptakan efek visual yang menarik dan umum di UI modern.
// =============================================================================

class PatientProfileCard extends StatelessWidget {
  final Patient patient;

  const PatientProfileCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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

      // Row menyusun avatar (kiri) dan info teks (kanan) secara horizontal.
      // Ini pola umum untuk profile card: gambar di satu sisi, detail di sisi lain.
      child: Row(
        children: [
          // Avatar dengan status overlay — bagian STACK demo
          _buildAvatarWithStatus(),
          const SizedBox(width: 16),

          // Info pasien mengisi SISA ruang horizontal yang tersedia.
          // Expanded mencegah overflow jika nama pasien panjang.
          Expanded(child: _buildPatientInfo(context)),
        ],
      ),
    );
  }

  // ===========================================================================
  // STACK DEMO — Avatar dengan Indikator Status Bertumpuk
  // ===========================================================================
  //
  // Visualisasi layer Stack:
  //
  //   ┌──────────────────────┐
  //   │                  [!] │ ← Layer 3: Emergency badge (Positioned top-right)
  //   │    ┌──────────┐      │
  //   │    │  Avatar   │     │ ← Layer 1: CircleAvatar (base layer)
  //   │    │  (foto)   │     │
  //   │    └──────────┘  ●   │ ← Layer 2: Online dot (Positioned bottom-right)
  //   └──────────────────────┘
  //
  // Urutan children di Stack = urutan painting (pertama = paling belakang).
  // ===========================================================================
  Widget _buildAvatarWithStatus() {
    return Stack(
      // Clip.none memperbolehkan child Positioned keluar dari batas Stack.
      // Tanpa ini, badge emergency yang di-offset negatif (top: -4) akan terpotong.
      clipBehavior: Clip.none,
      children: [
        // ----- LAYER 1: Avatar (Base Layer) -----
        // CircleAvatar digunakan sebagai placeholder foto profil.
        // Di aplikasi nyata, ini akan menggunakan NetworkImage.
        CircleAvatar(
          radius: 35,
          backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
          child: const Icon(
            Icons.person,
            size: 40,
            color: AppTheme.primaryBlue,
          ),
        ),

        // ----- LAYER 2: Indikator Online/Offline -----
        // Positioned(bottom: 2, right: 2) menempatkan titik di pojok kanan bawah.
        //
        // Border putih di sekitar titik menciptakan efek "cutout" yang
        // memisahkan titik dari avatar secara visual — teknik umum di UI messaging.
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: patient.isOnline
                  ? AppTheme.healthyGreen
                  : AppTheme.textSecondary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
            ),
          ),
        ),

        // ----- LAYER 3: Badge Emergency (Kondisional) -----
        // Hanya muncul jika pasien dalam status darurat.
        // Positioned(top: -4, right: -4) — nilai NEGATIF membuat badge
        // "menyembul" di luar batas avatar. Ini aman karena clipBehavior: Clip.none.
        if (patient.isEmergency)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppTheme.emergencyRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  /// Informasi detail pasien disusun vertikal dengan Column.
  Widget _buildPatientInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nama pasien — informasi paling penting
        Text(
          patient.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // Info umur dan ruangan dalam satu baris
        Text(
          '${patient.age} years old  •  ${patient.room}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),

        // ID Pasien — kode unik untuk referensi medis
        Text(
          'ID: ${patient.patientId}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),

        // Row berisi badge status online dan status darurat
        Row(
          children: [
            _buildStatusChip(
              label: patient.isOnline ? 'Online' : 'Offline',
              color: patient.isOnline
                  ? AppTheme.healthyGreen
                  : AppTheme.textSecondary,
              context: context,
            ),
            const SizedBox(width: 8),
            if (patient.isEmergency)
              _buildStatusChip(
                label: 'Emergency',
                color: AppTheme.emergencyRed,
                context: context,
              ),
          ],
        ),
      ],
    );
  }

  /// Chip kecil untuk menampilkan status (Online/Offline/Emergency).
  Widget _buildStatusChip({
    required String label,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
