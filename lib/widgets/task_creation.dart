import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';
import 'task_decompose_dialog.dart';

class TaskCreation extends StatefulWidget {
  const TaskCreation({Key? key}) : super(key: key);

  @override
  State<TaskCreation> createState() => _TaskCreationState();
}

class _TaskCreationState extends State<TaskCreation> {
  late TextEditingController _taskNameController;
  late TextEditingController _memoController;
  double _selectedDuration = 1.0;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController();
    _memoController = TextEditingController();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _addTask() {
    final name = _taskNameController.text.trim();
    final memo = _memoController.text.trim();
    
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請輸入任務名稱')),
      );
      return;
    }

    context.read<TaskProvider>().addTask(
      name,
      _selectedDuration,
      memo: memo,
    );
    _taskNameController.clear();
    _memoController.clear();
    _selectedDuration = 1.0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已新增任務：$name')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.darkCardBg,
        border: Border.all(color: AppConstants.darkBorder, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '新增任務',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppConstants.darkText,
                ),
              ),
              // AI 分解按鈕
              Tooltip(
                message: 'AI 任務分解助手',
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const TaskDecomposeDialog(),
                    );
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppConstants.accentPurple.withOpacity(0.2),
                      border: Border.all(
                        color: AppConstants.accentPurple,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppConstants.accentPurple,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 任務名稱和備註
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左側：名稱和備註
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    TextField(
                      controller: _taskNameController,
                      decoration: InputDecoration(
                        hintText: AppConstants.taskNameHint,
                        hintStyle: const TextStyle(color: Color(0xFF666666)),
                        fillColor: AppConstants.darkAccent,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.darkBorder),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.darkBorder),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      style: const TextStyle(color: AppConstants.darkText),
                      onSubmitted: (_) => _addTask(),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _memoController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: AppConstants.memoHint,
                        hintStyle: const TextStyle(color: Color(0xFF666666)),
                        fillColor: AppConstants.darkAccent,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.darkBorder),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.darkBorder),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      style: const TextStyle(color: AppConstants.darkText),
                      onSubmitted: (_) => _addTask(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // 右側：時長和按鈕
              Column(
                children: [
                  // 時長選擇
                  SizedBox(
                    width: 140,
                    child: DropdownButton<double>(
                      value: _selectedDuration,
                      isExpanded: true,
                      underline: Container(),
                      style: const TextStyle(color: AppConstants.darkText),
                      dropdownColor: AppConstants.darkAccent,
                      items: AppConstants.durationOptions
                          .map((duration) => DropdownMenuItem(
                                value: duration,
                                child: Text(
                                  DurationFormatter.format(duration),
                                  style: const TextStyle(
                                    color: AppConstants.darkText,
                                  ),
                                ),
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
                  const SizedBox(height: 8),
                  // 新增按鈕
                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.accentPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      AppConstants.addButtonLabel,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}


