import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ReferenceLines extends StatelessWidget {
  const ReferenceLines({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Column(
          children: [
            for (final hours in AppConstants.referenceLineHours)
              _buildReferenceLine(hours),
          ],
        ),
      ),
    );
  }

  Widget _buildReferenceLine(double hours) {
    final positionFromTop = (hours / AppConstants.containerHeightHours);

    if (positionFromTop > 1.0) return const SizedBox.shrink();

    return Expanded(
      flex: hours.toInt(),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppConstants.referenceLineColor,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppConstants.referenceLineColor,
                  width: 0.5,
                ),
              ),
              child: Text(
                '${hours.toStringAsFixed(0)}h',
                style: TextStyle(
                  fontSize: 10,
                  color: AppConstants.referenceLineColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
