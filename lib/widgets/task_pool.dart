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

        return DragTarget<Task>(
          onAcceptWithDetails: (details) {
            // 支援從容器拖回任務池
            context
                .read<TaskProvider>()
                .moveTaskOutOfContainer(details.data.id);
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: candidateData.isNotEmpty
                      ? AppConstants.accentCyan
                      : AppConstants.darkBorder,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                color: AppConstants.darkAccent.withOpacity(0.5),
              ),
              child: tasksInPool.isEmpty
                  ? Center(
                      child: Text(
                        '還沒有待放置的任務\n從右側拖曳任務回到這裡',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF666666),
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      padding: const EdgeInsets.all(8),
                      itemCount: tasksInPool.length,
                      itemBuilder: (context, index) {
                        final task = tasksInPool[index];
                        return TaskBlock(task: task, isInContainer: false);
                      },
                    ),
            );
          },
          onWillAcceptWithDetails: (details) {
            return true;
          },
        );
      },
    );
  }
}

