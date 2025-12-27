import 'package:flutter/material.dart';

class AppConstants {
  // 時間單位
  static const double baseUnit = 30.0; // pixels per hour
  static const double containerHeightHours = 16.0; // 容器高度代表 16 小時
  static const double containerHeight = containerHeightHours * baseUnit; // 480px

  // 時長選項
  static const List<double> durationOptions = [0.5, 1.0, 1.5, 2.0, 3.0, 4.0];

  // 參考線位置（小時）
  static const List<double> referenceLineHours = [8.0, 16.0, 24.0];

  // 深色主題顏色
  static const Color darkBg = Color(0xFF1a1a2e);
  static const Color darkCardBg = Color(0xFF16213e);
  static const Color darkAccent = Color(0xFF0f3460);
  static const Color darkText = Color(0xFFe0e0e0);
  static const Color darkBorder = Color(0xFF533483);
  static const Color accentPurple = Color(0xFF9d4edd);
  static const Color accentCyan = Color(0xFF3a86ff);

  // 任務區塊顏色
  static final List<Color> taskBlockColors = [
    const Color(0xFF7209b7),
    const Color(0xFF3a86ff),
    const Color(0xFF06ffa5),
    const Color(0xFFffbe0b),
    const Color(0xFFfb5607),
    const Color(0xFFff006e),
  ];

  // 文字
  static const String appTitle = 'Tech Vibe';
  static const String taskNameHint = '輸入任務名稱...';
  static const String memoHint = '補充說明（選填）...';
  static const String addButtonLabel = '新增';
  static const String tasksInPoolLabel = '待放置的任務：';
  static const String todayLabel = '今日規劃：';
  static const String countdownsLabel = '重大倒數：';
}

class DurationFormatter {
  static String format(double hours) {
    if (hours == 0.5) return '30 分鐘';
    if (hours == 1.0) return '1 小時';
    if (hours == 1.5) return '1.5 小時';
    if (hours == 2.0) return '2 小時';
    if (hours == 3.0) return '3 小時';
    if (hours == 4.0) return '4 小時';
    return '${hours.toStringAsFixed(1)} 小時';
  }

  static String formatShort(double hours) {
    if (hours < 1) {
      return '${(hours * 60).toStringAsFixed(0)}m';
    }
    return '${hours.toStringAsFixed(1)}h';
  }
}
