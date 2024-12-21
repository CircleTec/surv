// lib/features/surveyor/survey_response/views/surveyor_surveys_view.dart
import 'package:flutter/material.dart';

class SurveyorSurveysView extends StatelessWidget {
  const SurveyorSurveysView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Let\'s start new surveys',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[400]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Find surveys',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  Icon(Icons.tune, color: Colors.grey[400]),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Category Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('All', isSelected: true),
                  _buildCategoryChip('Health'),
                  _buildCategoryChip('Shopping'),
                  _buildCategoryChip('Lifestyle'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Survey List
            _buildSurveyItem(
              'Health Survey',
              'In Progress',
              '30 Minutes',
              '45 Out of 100 Complete',
              progress: 0.45,
            ),
            _buildSurveyItem(
              'Nutrition Survey',
              'In Progress',
              '30 Minutes',
              '75 Out of 150 Complete',
              progress: 0.5,
            ),
            _buildSurveyItem(
              'Money Survey',
              'To Do',
              '30 Minutes',
              '',
            ),
            _buildSurveyItem(
              'Studies Survey',
              'To Do',
              '30 Minutes',
              '',
            ),
            _buildSurveyItem(
              'Family Survey',
              'To Do',
              '30 Minutes',
              '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF5EE0C5) : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSurveyItem(String title, String status, String duration, String completion, {double? progress}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    color: const Color(0xFF5EE0C5),
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (completion.isNotEmpty)
                  Text(
                    completion,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          if (progress != null)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF5EE0C5),
                  width: 2,
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  color: const Color(0xFF5EE0C5),
                  strokeWidth: 2,
                ),
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF5EE0C5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}