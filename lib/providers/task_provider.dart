import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../models/countdown_model.dart';
import '../models/app_state.dart';
import '../utils/storage.dart';

class TaskProvider extends ChangeNotifier {
  AppState _state = AppState();

  AppState get state => _state;
  List<Task> get allTasks => _state.allTasks;
  List<Task> get tasksInPool => _state.tasksInPool;
  List<Task> get tasksInContainer => _state.tasksInContainer;
  double get totalDurationInContainer => _state.totalDurationInContainer;
  List<Countdown> get countdowns => _state.countdowns;

  final StorageService _storage = StorageService();

  TaskProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final appState = await _storage.loadAppState();
    _state = appState;
    notifyListeners();
  }

  // 新增任務
  void addTask(String name, double duration, {String memo = ''}) {
    if (name.isEmpty || duration < 0.5 || duration > 8) {
      return;
    }

    final newTask = Task(
      name: name,
      duration: duration,
      memo: memo,
    );

    final updatedTasks = [..._state.allTasks, newTask];
    _state = _state.copyWith(allTasks: updatedTasks);
    saveToStorage();
    notifyListeners();
  }

  // 編輯任務
  void editTask(String taskId, {String? name, double? duration, String? memo}) {
    final taskIndex = _state.allTasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final updatedTask = _state.allTasks[taskIndex].copyWith(
      name: name,
      duration: duration,
      memo: memo,
    );

    final updatedTasks = [..._state.allTasks];
    updatedTasks[taskIndex] = updatedTask;
    
    _state = _state.copyWith(allTasks: updatedTasks);
    saveToStorage();
    notifyListeners();
  }

  // 標記任務完成
  void markTaskComplete(String taskId) {
    final taskIndex = _state.allTasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final updatedTask = _state.allTasks[taskIndex].copyWith(isCompleted: true);
    
    final updatedTasks = [..._state.allTasks];
    updatedTasks[taskIndex] = updatedTask;
    
    _state = _state.copyWith(allTasks: updatedTasks);
    saveToStorage();
    notifyListeners();
  }

  // 刪除任務
  void removeTask(String taskId) {
    final updatedTasks =
        _state.allTasks.where((task) => task.id != taskId).toList();
    final updatedContainerIds = Set<String>.from(_state.tasksInContainerId)
      ..remove(taskId);

    _state = _state.copyWith(
      allTasks: updatedTasks,
      tasksInContainerId: updatedContainerIds,
    );
    saveToStorage();
    notifyListeners();
  }

  // 將任務移入容器
  void moveTaskToContainer(String taskId) {
    final updatedContainerIds = Set<String>.from(_state.tasksInContainerId)
      ..add(taskId);

    _state = _state.copyWith(tasksInContainerId: updatedContainerIds);
    saveToStorage();
    notifyListeners();
  }

  // 將任務移出容器
  void moveTaskOutOfContainer(String taskId) {
    final updatedContainerIds = Set<String>.from(_state.tasksInContainerId)
      ..remove(taskId);

    _state = _state.copyWith(tasksInContainerId: updatedContainerIds);
    saveToStorage();
    notifyListeners();
  }

  // 新增倒數計時
  void addCountdown(String title, DateTime targetDate) {
    final newCountdown = Countdown(
      title: title,
      targetDate: targetDate,
    );

    final updatedCountdowns = [..._state.countdowns, newCountdown];
    _state = _state.copyWith(countdowns: updatedCountdowns);
    saveToStorage();
    notifyListeners();
  }

  // 刪除倒數計時
  void removeCountdown(String countdownId) {
    final updatedCountdowns =
        _state.countdowns.where((cd) => cd.id != countdownId).toList();
    _state = _state.copyWith(countdowns: updatedCountdowns);
    saveToStorage();
    notifyListeners();
  }

  // 從本地儲存載入資料
  Future<void> loadFromStorage() async {
    final appState = await _storage.loadAppState();
    _state = appState;
    notifyListeners();
  }

  // 儲存到本地儲存
  Future<void> saveToStorage() async {
    await _storage.saveAppState(_state);
  }

  // 清除所有資料
  void clearAll() {
    _state = AppState();
    _storage.clearAll();
    notifyListeners();
  }
}

