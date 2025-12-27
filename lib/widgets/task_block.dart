import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';

class TaskBlock extends StatelessWidget {
  final Task task;
  final bool isInContainer;

  const TaskBlock({
    Key? key,
    required this.task,
    required this.isInContainer,
  }) : super(key: key);

  double _getBlockHeight() {
    return task.duration * AppConstants.baseUnit;
  }

  @override
  Widget build(BuildContext context) {
    final height = _getBlockHeight();

    // 在容器中的任務顯示為堆疊
    if (isInContainer) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: _buildBlockContent(context),
      );
    }

    // 任務池中的任務作為可拖曳的卡片
    return Draggable<Task>(
      data: task,
      feedback: Material(
        child: Container(
          width: 140,
          height: 100,
          decoration: BoxDecoration(
            color: AppConstants.taskBlockColor,
            border: Border.all(color: AppConstants.taskBlockBorderColor),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              task.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildBlockContent(context),
      ),
      child: _buildBlockContent(context),
    );
  }

  Widget _buildBlockContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.taskBlockColor,
        border: Border.all(
          color: AppConstants.taskBlockBorderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // 任務名稱和時長
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  DurationFormatter.format(task.duration),
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          // 刪除按鈕
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                context.read<TaskProvider>().removeTask(task.id);
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
