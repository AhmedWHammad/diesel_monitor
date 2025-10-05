import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/consumption_provider.dart';
import '../../../core/constants/app_colors.dart';

class ConsumptionScreen extends StatefulWidget {
  const ConsumptionScreen({Key? key}) : super(key: key);

  @override
  State<ConsumptionScreen> createState() => _ConsumptionScreenState();
}

class _ConsumptionScreenState extends State<ConsumptionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConsumptionProvider>().startAutoRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.consumption),
      ),
      body: Consumer<ConsumptionProvider>(
        builder: (context, provider, child) {
          if (provider.state == ViewState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == ViewState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.danger,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.errorLoadingData,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => provider.retry(),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          final summary = provider.summaryData;

          if (summary == null) {
            return Center(child: Text(l10n.noDataAvailable));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSummaryCard(
                    l10n.daily,
                    summary.dailyIn,
                    summary.dailyOut,
                    summary.dailyEfficiency,
                    l10n,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    l10n.weekly,
                    summary.weeklyIn,
                    summary.weeklyOut,
                    summary.weeklyEfficiency,
                    l10n,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    l10n.monthly,
                    summary.monthlyIn,
                    summary.monthlyOut,
                    summary.monthlyEfficiency,
                    l10n,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.inletVsOutlet,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 200,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: [
                                  summary.dailyIn,
                                  summary.dailyOut,
                                  summary.weeklyIn,
                                  summary.weeklyOut,
                                  summary.monthlyIn,
                                  summary.monthlyOut,
                                ].reduce((a, b) => a > b ? a : b) * 1.2,
                                barGroups: [
                                  _buildBarGroup(0, summary.dailyIn, summary.dailyOut),
                                  _buildBarGroup(1, summary.weeklyIn, summary.weeklyOut),
                                  _buildBarGroup(2, summary.monthlyIn, summary.monthlyOut),
                                ],
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        switch (value.toInt()) {
                                          case 0:
                                            return Text(l10n.daily);
                                          case 1:
                                            return Text(l10n.weekly);
                                          case 2:
                                            return Text(l10n.monthly);
                                          default:
                                            return const Text('');
                                        }
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLegendItem(l10n.totalIn, AppColors.primary),
                              const SizedBox(width: 24),
                              _buildLegendItem(l10n.totalOut, AppColors.accent),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    double inValue,
    double outValue,
    double efficiency,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildValueColumn(
                    l10n.totalIn,
                    inValue,
                    AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _buildValueColumn(
                    l10n.totalOut,
                    outValue,
                    AppColors.accent,
                  ),
                ),
                Expanded(
                  child: _buildValueColumn(
                    l10n.efficiency,
                    efficiency,
                    AppColors.success,
                    suffix: '%',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueColumn(
    String label,
    double value,
    Color color, {
    String suffix = 'L',
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)}$suffix',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  BarChartGroupData _buildBarGroup(int x, double inValue, double outValue) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: inValue,
          color: AppColors.primary,
          width: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
        BarChartRodData(
          toY: outValue,
          color: AppColors.accent,
          width: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
