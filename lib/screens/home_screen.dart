import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_creation.dart';
import '../widgets/task_pool.dart';
import '../widgets/day_container.dart';
import '../widgets/reference_lines.dart';
import '../widgets/countdowns_section.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 任務建立區
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TaskCreation(),
          ),
          // 主內容區（左：倒數+任務池，右：今日容器）
          Expanded(
            child: Row(
              children: [
                // 左側：倒數計時 + 任務池
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 倒數計時區塊
                        const CountdownsSection(),
                        const SizedBox(height: 24),
                        // 任務池
                        Text(
                          AppConstants.tasksInPoolLabel,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: TaskPool(),
                        ),
                      ],
                    ),
                  ),
                ),
                // 右側：今日容器 + 參考線
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.todayLabel,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Stack(
                            children: [
                              DayContainer(),
                              ReferenceLines(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
