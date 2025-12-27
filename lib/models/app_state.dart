import 'task_model.dart';
import 'countdown_model.dart';

class AppState {
  final List<Task> allTasks;
  final Set<String> tasksInContainerId;
  final List<Countdown> countdowns;

  AppState({
    this.allTasks = const [],
    this.tasksInContainerId = const {},
    this.countdowns = const [],
  });

  // Getter：任務池中的任務（未放入容器）
  List<Task> get tasksInPool =>
      allTasks.where((task) => !tasksInContainerId.contains(task.id)).toList();

  // Getter：容器中的任務（已放入）
  List<Task> get tasksInContainer => allTasks
      .where((task) => tasksInContainerId.contains(task.id))
      .toList();

  // 計算容器中的總時長
  double get totalDurationInContainer =>
      tasksInContainer.fold(0.0, (sum, task) => sum + task.duration);

  // 複製方法
  AppState copyWith({
    List<Task>? allTasks,
    Set<String>? tasksInContainerId,
    List<Countdown>? countdowns,
  }) {
    return AppState(
      allTasks: allTasks ?? this.allTasks,
      tasksInContainerId: tasksInContainerId ?? this.tasksInContainerId,
      countdowns: countdowns ?? this.countdowns,
    );
  }

  // 序列化
  Map<String, dynamic> toJson() {
    return {
      'tasks': allTasks.map((task) => task.toJson()).toList(),
      'tasksInContainerId': tasksInContainerId.toList(),
      'countdowns': countdowns.map((cd) => cd.toJson()).toList(),
    };
  }

  // 反序列化
  factory AppState.fromJson(Map<String, dynamic> json) {
    final tasksList = (json['tasks'] as List<dynamic>?)
            ?.map((item) => Task.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];
    final containerIds = (json['tasksInContainerId'] as List<dynamic>?)
            ?.map((id) => id as String)
            .toSet() ??
        {};
    final countdownsList = (json['countdowns'] as List<dynamic>?)
            ?.map((item) => Countdown.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];

    return AppState(
      allTasks: tasksList,
      tasksInContainerId: containerIds,
      countdowns: countdownsList,
    );
  }
}

