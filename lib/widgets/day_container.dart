import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'task_block.dart';
import '../utils/constants.dart';

class DayContainer extends StatelessWidget {
  const DayContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasksInContainer = taskProvider.tasksInContainer;

        return DragTarget<Task>(
          onAcceptWithDetails: (details) {
            context
                .read<TaskProvider>()
                .moveTaskToContainer(details.data.id);
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                color: candidateData.isNotEmpty
                    ? Colors.blue.shade50
                    : AppConstants.containerBackgroundColor,
              ),
              child: tasksInContainer.isEmpty
                  ? Center(
                      child: Text(
                        '拖曳任務到這裡開始規劃',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < tasksInContainer.length; i++)
                            Draggable<Task>(
                              data: tasksInContainer[i],
                              feedback: Material(
                                child: Container(
                                  width: 200,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color:
                                        AppConstants.taskBlockColor.withOpacity(0.9),
                                    border: Border.all(
                                      color:
                                          AppConstants.taskBlockBorderColor,
                                    ),
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
                                      tasksInContainer[i].name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onDragCompleted: () {
                                // 拖曳完成但沒有放到有效地點
                              },
                              childWhenDragging: Opacity(
                                opacity: 0.5,
                                child: SizedBox(
                                  height: tasksInContainer[i].duration *
                                      AppConstants.baseUnit,
                                  width: double.infinity,
                                  child: TaskBlock(
                                    task: tasksInContainer[i],
                                    isInContainer: true,
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                height: tasksInContainer[i].duration *
                                    AppConstants.baseUnit,
                                width: double.infinity,
                                child: TaskBlock(
                                  task: tasksInContainer[i],
                                  isInContainer: true,
                                ),
                              ),
                            ),
                        ],
                      ),
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
