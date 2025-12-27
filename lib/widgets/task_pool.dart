import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import 'task_block.dart';
import '../utils/constants.dart';

class TaskPool extends StatelessWidget {
  const TaskPool({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasksInPool = taskProvider.tasksInPool;

        if (tasksInPool.isEmpty) {
          return Center(
            child: Text(
              '還沒有待放置的任務\n拖曳任務到這裡移除',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: tasksInPool.length,
          itemBuilder: (context, index) {
            final task = tasksInPool[index];
            return TaskBlock(task: task, isInContainer: false);
          },
        );
      },
    );
  }
}
