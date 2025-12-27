import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';
import 'task_edit_dialog.dart';

class TaskBlock extends StatefulWidget {
  final Task task;
  final bool isInContainer;
  final VoidCallback? onDurationChanged;

  const TaskBlock({
    Key? key,
    required this.task,
    required this.isInContainer,
    this.onDurationChanged,
  }) : super(key: key);

  @override
  State<TaskBlock> createState() => _TaskBlockState();
}

class _TaskBlockState extends State<TaskBlock> {
  late double _currentDuration;
  bool _isDraggingResize = false;

  @override
  void initState() {
    super.initState();
    _currentDuration = widget.task.duration;
  }

  double _getBlockHeight() {
    return _currentDuration * AppConstants.baseUnit;
  }

  Color _getTaskColor() {
    final colorIndex = widget.task.id.hashCode % AppConstants.taskBlockColors.length;
    return AppConstants.taskBlockColors[colorIndex.abs()];
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.darkCardBg,
        title: const Text(
          '🎉 恭喜完成！',
          style: TextStyle(
            color: AppConstants.darkText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              '「${widget.task.name}」',
              style: const TextStyle(
                color: AppConstants.accentCyan,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              '完成！再加油 💪',
              style: TextStyle(
                color: AppConstants.darkText,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '感謝提醒',
              style: TextStyle(color: AppConstants.accentPurple),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = _getBlockHeight();
    final taskColor = _getTaskColor();

    // 任務池中的任務
    if (!widget.isInContainer) {
      return Draggable<Task>(
        data: widget.task,
        feedback: Material(
          child: Container(
            width: 140,
            height: 100,
            decoration: BoxDecoration(
              color: taskColor,
              border: Border.all(
                color: taskColor.withOpacity(0.8),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.task.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.4,
          child: _buildBlockContent(taskColor),
        ),
        child: _buildBlockContent(taskColor),
      );
    }

    // 容器中的任務 - 支援拖曳和調整時長
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => TaskEditDialog(task: widget.task),
        );
      },
      child: Draggable<Task>(
        data: widget.task,
        feedback: Material(
          child: Container(
            width: 200,
            height: height.clamp(40.0, 200.0),
            decoration: BoxDecoration(
              color: taskColor,
              border: Border.all(
                color: taskColor.withOpacity(0.8),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.task.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: _buildBlockContent(taskColor),
        ),
        child: MouseRegion(
          cursor: _isDraggingResize
              ? SystemMouseCursors.resizeRow
              : MouseCursor.defer,
          child: Stack(
            children: [
              _buildBlockContent(taskColor),
              // 下方調整時長的把手
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 8,
                child: GestureDetector(
                  onVerticalDragStart: (_) {
                    setState(() {
                      _isDraggingResize = true;
                    });
                  },
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      final newDuration =
                          _currentDuration + (details.delta.dy / AppConstants.baseUnit);
                      if (newDuration >= 0.5 && newDuration <= 8.0) {
                        // 以 0.5 為單位四捨五入
                        _currentDuration =
                            (newDuration * 2).round() / 2;
                      }
                    });
                    widget.onDurationChanged?.call();
                  },
                  onVerticalDragEnd: (_) {
                    setState(() {
                      _isDraggingResize = false;
                    });
                    // 更新到 provider
                    context.read<TaskProvider>().editTask(
                      widget.task.id,
                      duration: _currentDuration,
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeRow,
                      child: Center(
                        child: Container(
                          width: 30,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlockContent(Color taskColor) {
    final isCompleted = widget.task.isCompleted;
    
    return Container(
      decoration: BoxDecoration(
        color: isCompleted ? taskColor.withOpacity(0.4) : taskColor,
        border: Border.all(
          color: isCompleted
              ? taskColor.withOpacity(0.6)
              : taskColor.withOpacity(0.8),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // 主要內容
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (widget.isInContainer && !isCompleted)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<TaskProvider>()
                                  .markTaskComplete(widget.task.id);
                              _showCompletionDialog();
                            },
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.6),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.task.name,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            if (widget.task.memo.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  widget.task.memo,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  DurationFormatter.format(_currentDuration),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // 刪除按鈕
          if (!widget.isInContainer)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  context.read<TaskProvider>().removeTask(widget.task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已刪除任務')),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

