import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/countdown_model.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';

class CountdownCard extends StatelessWidget {
  final Countdown countdown;

  const CountdownCard({
    Key? key,
    required this.countdown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.darkCardBg,
        border: Border.all(color: AppConstants.darkBorder, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                countdown.title,
                style: const TextStyle(
                  color: AppConstants.darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                countdown.remainingTimeStr,
                style: TextStyle(
                  color: countdown.daysRemaining < 0
                      ? Colors.red
                      : AppConstants.accentCyan,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('yyyy/MM/dd').format(countdown.targetDate),
                style: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          // 刪除按鈕 - 右上角 X
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                context.read<TaskProvider>().removeCountdown(countdown.id);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '×',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CountdownsSection extends StatefulWidget {
  const CountdownsSection({Key? key}) : super(key: key);

  @override
  State<CountdownsSection> createState() => _CountdownsSectionState();
}

class _CountdownsSectionState extends State<CountdownsSection> {
  void _showAddCountdownDialog(BuildContext context) {
    final titleController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.darkCardBg,
        title: const Text(
          '新增倒數',
          style: TextStyle(color: AppConstants.darkText),
        ),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: '事件名稱',
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
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppConstants.darkAccent,
                    border: Border.all(color: AppConstants.darkBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: AppConstants.accentCyan, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        selectedDate == null
                            ? '選擇日期'
                            : DateFormat('yyyy/MM/dd').format(selectedDate!),
                        style: const TextStyle(color: AppConstants.darkText),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消',
                style: TextStyle(color: AppConstants.accentCyan)),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && selectedDate != null) {
                context.read<TaskProvider>().addCountdown(
                      titleController.text,
                      selectedDate!,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('新增',
                style: TextStyle(color: AppConstants.accentCyan)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppConstants.countdownsLabel,
                  style: TextStyle(
                    color: AppConstants.darkText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showAddCountdownDialog(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppConstants.accentPurple.withOpacity(0.3),
                      border: Border.all(
                          color: AppConstants.accentPurple, width: 1.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppConstants.accentPurple,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (provider.countdowns.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '尚未設定倒數',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.countdowns.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) =>
                    CountdownCard(countdown: provider.countdowns[index]),
              ),
          ],
        );
      },
    );
  }
}
