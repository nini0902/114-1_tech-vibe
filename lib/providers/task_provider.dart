import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../models/app_state.dart';
import '../utils/storage.dart';

class TaskProvider extends ChangeNotifier {
  AppState _state = AppState();

  AppState get state => _state;
  List<Task> get allTasks => _state.allTasks;
  List<Task> get tasksInPool => _state.tasksInPool;
  List<Task> get tasksInContainer => _state.tasksInContainer;
  double get totalDurationInContainer => _state.totalDurationInContainer;

  final StorageService _storage = StorageService();

  TaskProvider() {
    loadFromStorage();
  }

  // 新增任務
  void addTask(String name, double duration) {
    if (name.isEmpty || duration < 0.5 || duration > 8) {
      return;
    }

    final newTask = Task(
      name: name,
      duration: duration,
    );

    final updatedTasks = [..._state.allTasks, newTask];
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
