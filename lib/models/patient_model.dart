import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';

// =============================================================================
// Data Models untuk Medical Dashboard
// =============================================================================
//
// MENGAPA PAKAI MODEL CLASS, BUKAN RAW MAP?
// 1. Type Safety — compiler menangkap kesalahan tipe data sebelum runtime
// 2. Autocompletion — IDE bisa menyarankan field yang tersedia
// 3. Refactoring — rename satu field otomatis berubah di seluruh kode
// 4. Dokumentasi — nama field dan tipe data sudah menjelaskan diri sendiri
//
// Setiap model menyediakan factory constructor `mock()` untuk data demo.
// Di aplikasi nyata, data ini akan datang dari API/database.
// =============================================================================

/// Model data pasien yang sedang dimonitor.
class Patient {
  final String name;
  final int age;
  final String room;
  final String patientId;
  final bool isOnline;
  final bool isEmergency;

  const Patient({
    required this.name,
    required this.age,
    required this.room,
    required this.patientId,
    required this.isOnline,
    required this.isEmergency,
  });

  /// Data mock untuk demo — mensimulasikan pasien aktif di ruangan.
  factory Patient.mock() {
    return const Patient(
      name: 'Ahmad Rizky',
      age: 45,
      room: 'Room 302',
      patientId: 'PT-2024-0302',
      isOnline: true,
      isEmergency: false,
    );
  }
}

/// Model satu metrik kesehatan (detak jantung, suhu, dll).
class HealthMetric {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final String status; // 'normal', 'warning', 'critical'

  const HealthMetric({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.status,
  });

  /// 4 metrik vital utama yang umum dimonitor di dashboard medis.
  static List<HealthMetric> mockMetrics() {
    return const [
      HealthMetric(
        label: 'Heart Rate',
        value: '78',
        unit: 'BPM',
        icon: Icons.favorite,
        color: AppTheme.emergencyRed,
        status: 'normal',
      ),
      HealthMetric(
        label: 'Temperature',
        value: '36.5',
        unit: '°C',
        icon: Icons.thermostat,
        color: AppTheme.warningOrange,
        status: 'normal',
      ),
      HealthMetric(
        label: 'Blood Pressure',
        value: '120/80',
        unit: 'mmHg',
        icon: Icons.speed,
        color: AppTheme.primaryBlue,
        status: 'normal',
      ),
      HealthMetric(
        label: 'SpO2',
        value: '98',
        unit: '%',
        icon: Icons.air,
        color: AppTheme.healthyGreen,
        status: 'normal',
      ),
    ];
  }
}

/// Model satu entri jadwal obat.
class Medication {
  final String name;
  final String dose;
  final String time;
  final String frequency;
  final String status; // 'Taken', 'Pending', 'Upcoming'

  const Medication({
    required this.name,
    required this.dose,
    required this.time,
    required this.frequency,
    required this.status,
  });

  /// 5 obat umum yang mungkin diberikan ke pasien rawat inap.
  static List<Medication> mockMedications() {
    return const [
      Medication(
        name: 'Amoxicillin',
        dose: '500mg',
        time: '08:00',
        frequency: '3x daily',
        status: 'Taken',
      ),
      Medication(
        name: 'Lisinopril',
        dose: '10mg',
        time: '09:00',
        frequency: '1x daily',
        status: 'Taken',
      ),
      Medication(
        name: 'Metformin',
        dose: '850mg',
        time: '12:00',
        frequency: '2x daily',
        status: 'Pending',
      ),
      Medication(
        name: 'Atorvastatin',
        dose: '20mg',
        time: '21:00',
        frequency: '1x daily',
        status: 'Upcoming',
      ),
      Medication(
        name: 'Omeprazole',
        dose: '20mg',
        time: '07:00',
        frequency: '1x daily',
        status: 'Taken',
      ),
    ];
  }
}

/// Model satu hasil pemeriksaan laboratorium.
class LabResult {
  final String testName;
  final String result;
  final String normalRange;
  final String status; // 'Normal', 'High', 'Low'

  const LabResult({
    required this.testName,
    required this.result,
    required this.normalRange,
    required this.status,
  });

  /// 4 pemeriksaan lab umum dengan nilai rujukan.
  static List<LabResult> mockResults() {
    return const [
      LabResult(
        testName: 'Blood Glucose',
        result: '95 mg/dL',
        normalRange: '70-100',
        status: 'Normal',
      ),
      LabResult(
        testName: 'Cholesterol',
        result: '210 mg/dL',
        normalRange: '<200',
        status: 'High',
      ),
      LabResult(
        testName: 'Hemoglobin',
        result: '14.2 g/dL',
        normalRange: '13.5-17.5',
        status: 'Normal',
      ),
      LabResult(
        testName: 'WBC Count',
        result: '7,500 /uL',
        normalRange: '4,500-11,000',
        status: 'Normal',
      ),
    ];
  }
}
