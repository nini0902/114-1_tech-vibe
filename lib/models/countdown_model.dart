import 'package:uuid/uuid.dart';

class Countdown {
  final String id;
  final String title;
  final DateTime targetDate;
  final DateTime createdAt;

  Countdown({
    String? id,
    required this.title,
    required this.targetDate,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // 計算剩餘天數
  int get daysRemaining {
    return targetDate.difference(DateTime.now()).inDays;
  }

  // 計算剩餘時間的完整字串
  String get remainingTimeStr {
    final diff = targetDate.difference(DateTime.now());
    if (diff.isNegative) {
      return '已過期';
    }
    
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    
    if (days > 0) {
      return '$days 天 $hours 小時';
    } else if (hours > 0) {
      return '$hours 小時 $minutes 分鐘';
    } else {
      return '$minutes 分鐘';
    }
  }

  // 序列化
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetDate': targetDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // 反序列化
  factory Countdown.fromJson(Map<String, dynamic> json) {
    return Countdown(
      id: json['id'] as String,
      title: json['title'] as String,
      targetDate: DateTime.parse(json['targetDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // 複製方法
  Countdown copyWith({
    String? id,
    String? title,
    DateTime? targetDate,
    DateTime? createdAt,
  }) {
    return Countdown(
      id: id ?? this.id,
      title: title ?? this.title,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Countdown &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
