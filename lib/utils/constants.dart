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

  // 顏色
  static final taskBlockColor = Colors.blue.shade300;
  static final taskBlockBorderColor = Colors.blue.shade700;
  static final containerBackgroundColor = Colors.grey.shade100;
  static final referenceLineColor = Colors.grey.shade400;

  // 文字
  static const String appTitle = 'Tech Vibe - 時間視覺化規劃';
  static const String taskNameHint = '輸入任務名稱...';
  static const String addButtonLabel = '新增';
  static const String tasksInPoolLabel = '待放置的任務：';
  static const String todayLabel = '今日規劃：';
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
