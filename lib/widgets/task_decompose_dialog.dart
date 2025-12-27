import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';
import '../utils/ai_service.dart';

class TaskDecomposeDialog extends StatefulWidget {
  const TaskDecomposeDialog({Key? key}) : super(key: key);

  @override
  State<TaskDecomposeDialog> createState() => _TaskDecomposeDialogState();
}

class _TaskDecomposeDialogState extends State<TaskDecomposeDialog> {
  late TextEditingController _taskController;
  String? _decomposeResult;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _decomposeTask() async {
    final taskDescription = _taskController.text.trim();
    
    if (taskDescription.isEmpty) {
      setState(() {
        _errorMessage = '請輸入任務描述';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _decomposeResult = null;
    });

    try {
      final result = await AIService.decomposeTask(taskDescription);
      setState(() {
        _decomposeResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConstants.darkCardBg,
      title: const Text(
        '✨ AI 任務分解助手',
        style: TextStyle(
          color: AppConstants.darkText,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '描述你的任務，AI 會幫你拆解成具體的子任務和時間估算：',
              style: TextStyle(
                color: Color(0xFF999999),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _taskController,
              maxLines: 3,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: '例如：準備跨年派對，邀請朋友，佈置場地，準備食物和飲料',
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
              ),
              style: const TextStyle(color: AppConstants.darkText),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            if (_decomposeResult != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.darkAccent,
                  border: Border.all(
                    color: AppConstants.accentCyan.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📋 AI 建議：',
                      style: TextStyle(
                        color: AppConstants.accentCyan,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _decomposeResult!,
                      style: const TextStyle(
                        color: AppConstants.darkText,
                        fontSize: 11,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_isLoading) ...[
              const SizedBox(height: 16),
              const Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppConstants.accentPurple,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'AI 正在分析...',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            '關閉',
            style: TextStyle(color: AppConstants.accentCyan),
          ),
        ),
        if (!_isLoading) ...[
          TextButton(
            onPressed: _decomposeTask,
            child: const Text(
              '分析',
              style: TextStyle(color: AppConstants.accentPurple),
            ),
          ),
        ],
      ],
    );
  }
}
