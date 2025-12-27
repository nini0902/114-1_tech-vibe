import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String name;
  final double duration; // 以小時為單位
  final DateTime createdAt;

  Task({
    String? id,
    required this.name,
    required this.duration,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // 驗證方法
  bool isValid() {
    return name.isNotEmpty && duration >= 0.5 && duration <= 8;
  }

  // 序列化
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // 反序列化
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      name: json['name'] as String,
      duration: (json['duration'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // 複製方法
  Task copyWith({
    String? id,
    String? name,
    double? duration,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
