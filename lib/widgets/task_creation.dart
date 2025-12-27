import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';

class TaskCreation extends StatefulWidget {
  const TaskCreation({Key? key}) : super(key: key);

  @override
  State<TaskCreation> createState() => _TaskCreationState();
}

class _TaskCreationState extends State<TaskCreation> {
  late TextEditingController _taskNameController;
  double _selectedDuration = 1.0;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  void _addTask() {
    final name = _taskNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請輸入任務名稱')),
      );
      return;
    }

    context.read<TaskProvider>().addTask(name, _selectedDuration);
    _taskNameController.clear();
    _selectedDuration = 1.0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已新增任務：$name')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '新增任務',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // 任務名稱輸入
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _taskNameController,
                    decoration: InputDecoration(
                      hintText: AppConstants.taskNameHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 12),
                // 時長選擇
                Expanded(
                  flex: 1,
                  child: DropdownButton<double>(
                    value: _selectedDuration,
                    isExpanded: true,
                    items: AppConstants.durationOptions
                        .map((duration) => DropdownMenuItem(
                              value: duration,
                              child: Text(DurationFormatter.format(duration)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedDuration = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // 新增按鈕
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text(AppConstants.addButtonLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
