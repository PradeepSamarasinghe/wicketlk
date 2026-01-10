import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import 'package:wicket_lk_new/features/auth/providers/auth_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CricInsights'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;
          final stats = user?.stats; // stats is Map<String, dynamic>?

          if (stats == null || stats.isEmpty) {
            return Center(
              child: Text(
                'No statistics available',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }

          // Safe access to stats values (assume keys like 'average', 'strikeRate' as double)
          final double userAverage = (stats['average'] as num?)?.toDouble() ?? 0.0;
          final double userStrikeRate = (stats['strikeRate'] as num?)?.toDouble() ?? 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 250,
                  decoration: AppTheme.glassmorphicDecoration(),
                  padding: const EdgeInsets.all(16),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 10),
                            const FlSpot(1, 25),
                            const FlSpot(2, 18),
                            const FlSpot(3, 35),
                            const FlSpot(4, 30),
                            const FlSpot(5, 45),
                            const FlSpot(6, 52),
                          ],
                          isCurved: true,
                          color: AppTheme.neonGreen,
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.neonGreen.withOpacity(0.1),
                          ),
                        ),
                      ],
                      maxY: 60,
                      minY: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Strengths & Weaknesses',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _SkillBar(skill: 'Batting', percentage: 0.75),
                const SizedBox(height: 12),
                _SkillBar(skill: 'Bowling', percentage: 0.60),
                const SizedBox(height: 12),
                _SkillBar(skill: 'Fielding', percentage: 0.85),
                const SizedBox(height: 12),
                _SkillBar(skill: 'Running', percentage: 0.70),
                const SizedBox(height: 24),
                Text(
                  'Recent Form',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: AppTheme.glassmorphicDecoration(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _FormIndicator(label: 'Last Match', performance: 'Excellent'),
                      const Divider(color: AppTheme.textGray, height: 24),
                      _FormIndicator(label: 'This Season', performance: 'Good'),
                      const Divider(color: AppTheme.textGray, height: 24),
                      _FormIndicator(label: 'Last 5 Matches', performance: 'Improving'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Comparison',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: AppTheme.glassmorphicDecoration(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _ComparisonRow(
                        label: 'vs District Average',
                        userValue: userAverage.toStringAsFixed(2),
                        districtValue: '28.5',
                        isPositive: userAverage > 28.5,
                      ),
                      const SizedBox(height: 12),
                      _ComparisonRow(
                        label: 'vs National Average',
                        userValue: userStrikeRate.toStringAsFixed(2),
                        districtValue: '130.5',
                        isPositive: userStrikeRate > 130.5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  final String skill;
  final double percentage;

  const _SkillBar({required this.skill, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${(percentage * 100).toInt()}%',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.darkBlue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.neonGreen,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FormIndicator extends StatelessWidget {
  final String label;
  final String performance;

  const _FormIndicator({required this.label, required this.performance});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getPerformanceColor(performance).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _getPerformanceColor(performance)),
          ),
          child: Text(
            performance,
            style: TextStyle(
              color: _getPerformanceColor(performance),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Color _getPerformanceColor(String performance) {
    switch (performance) {
      case 'Excellent':
        return AppTheme.neonGreen;
      case 'Good':
        return Colors.blue;
      case 'Improving':
        return Colors.orange;
      default:
        return AppTheme.textGray;
    }
  }
}

class _ComparisonRow extends StatelessWidget {
  final String label;
  final String userValue;
  final String districtValue;
  final bool isPositive;

  const _ComparisonRow({
    required this.label,
    required this.userValue,
    required this.districtValue,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              'You: $userValue • Avg: $districtValue',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          color: isPositive ? AppTheme.neonGreen : Colors.red,
          size: 28,
        ),
      ],
    );
  }
}