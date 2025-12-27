import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';

class TaskEditDialog extends StatefulWidget {
  final Task task;

  const TaskEditDialog({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskEditDialog> createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends State<TaskEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _memoController;
  late double _selectedDuration;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _memoController = TextEditingController(text: widget.task.memo);
    _selectedDuration = widget.task.duration;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConstants.darkCardBg,
      title: const Text(
        '編輯任務',
        style: TextStyle(color: AppConstants.darkText),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 任務名稱
            const Text(
              '任務名稱',
              style: TextStyle(
                color: AppConstants.darkText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: AppConstants.taskNameHint,
                hintStyle: const TextStyle(color: Color(0xFF666666)),
                fillColor: AppConstants.darkAccent,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppConstants.darkBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppConstants.darkBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: AppConstants.darkText),
            ),
            const SizedBox(height: 16),
            
            // 時長
            const Text(
              '預估時長',
              style: TextStyle(
                color: AppConstants.darkText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: AppConstants.durationOptions.map((duration) {
                final isSelected = _selectedDuration == duration;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDuration = duration;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppConstants.accentPurple
                          : AppConstants.darkAccent,
                      border: Border.all(
                        color: isSelected
                            ? AppConstants.accentPurple
                            : AppConstants.darkBorder,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      DurationFormatter.format(duration),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppConstants.darkText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            
            // 備註
            const Text(
              '補充說明',
              style: TextStyle(
                color: AppConstants.darkText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _memoController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: AppConstants.memoHint,
                hintStyle: const TextStyle(color: Color(0xFF666666)),
                fillColor: AppConstants.darkAccent,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppConstants.darkBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppConstants.darkBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: AppConstants.darkText),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            '取消',
            style: TextStyle(color: AppConstants.accentCyan),
          ),
        ),
        TextButton(
          onPressed: () {
            context.read<TaskProvider>().editTask(
              widget.task.id,
              name: _nameController.text,
              duration: _selectedDuration,
              memo: _memoController.text,
            );
            Navigator.pop(context);
          },
          child: const Text(
            '保存',
            style: TextStyle(color: AppConstants.accentPurple),
          ),
        ),
      ],
    );
  }
}
