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
                  color: candidateData.isNotEmpty
                      ? AppConstants.accentCyan
                      : AppConstants.darkBorder,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                color: AppConstants.darkAccent.withOpacity(
                  candidateData.isNotEmpty ? 0.8 : 0.3,
                ),
              ),
              child: tasksInContainer.isEmpty
                  ? Center(
                      child: Text(
                        '拖曳任務到這裡開始規劃',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF666666),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < tasksInContainer.length; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
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

