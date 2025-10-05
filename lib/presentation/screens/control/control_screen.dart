import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/control_provider.dart';
import '../../../core/constants/app_colors.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.control),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                      l10n.pumpControl,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Consumer<ControlProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: provider.isLoading
                                        ? null
                                        : () => _confirmPumpAction(
                                              context,
                                              true,
                                              l10n,
                                            ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.success,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      l10n.pumpOn,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: provider.isLoading
                                        ? null
                                        : () => _confirmPumpAction(
                                              context,
                                              false,
                                              l10n,
                                            ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.danger,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      l10n.pumpOff,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 16),
                            Text(
                              l10n.autoFill,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                labelText: l10n.targetLiters,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixText: l10n.liters,
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final target = double.tryParse(value) ?? 0;
                                provider.setTargetLiters(target);
                              },
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: provider.isLoading
                                    ? null
                                    : () {
                                        if (provider.isAutoFilling) {
                                          provider.stopAutoFill().then((success) {
                                            if (success) {
                                              _showSnackBar(
                                                context,
                                                l10n.success,
                                                AppColors.success,
                                              );
                                            }
                                          });
                                        } else {
                                          provider.startAutoFill().then((success) {
                                            if (success) {
                                              _showSnackBar(
                                                context,
                                                l10n.success,
                                                AppColors.success,
                                              );
                                            } else if (provider.errorMessage != null) {
                                              _showSnackBar(
                                                context,
                                                provider.errorMessage!,
                                                AppColors.danger,
                                              );
                                            }
                                          });
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: provider.isAutoFilling
                                      ? AppColors.danger
                                      : AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: Icon(
                                  provider.isAutoFilling
                                      ? Icons.stop
                                      : Icons.play_arrow,
                                ),
                                label: Text(
                                  provider.isAutoFilling
                                      ? l10n.stopAutoFill
                                      : l10n.startAutoFill,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            if (provider.isLoading)
                              const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: LinearProgressIndicator(),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                      l10n.stepperControl,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Consumer<ControlProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  l10n.position,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${provider.stepperPosition}%',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Slider(
                              value: provider.stepperPosition.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 100,
                              label: '${provider.stepperPosition}%',
                              onChanged: provider.isLoading
                                  ? null
                                  : (value) {
                                      provider.setStepperPosition(value.toInt());
                                    },
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [0, 25, 50, 75, 100].map((pos) {
                                return ElevatedButton(
                                  onPressed: provider.isLoading
                                      ? null
                                      : () {
                                          provider.setStepperPosition(pos).then((success) {
                                            if (success) {
                                              _showSnackBar(
                                                context,
                                                l10n.success,
                                                AppColors.success,
                                              );
                                            }
                                          });
                                        },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text('$pos%'),
                                );
                              }).toList(),
                            ),
                            if (provider.isLoading)
                              const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: LinearProgressIndicator(),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmPumpAction(
    BuildContext context,
    bool turnOn,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirm),
        content: Text(turnOn ? l10n.confirmPumpOn : l10n.confirmPumpOff),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final provider = context.read<ControlProvider>();
              final future = turnOn ? provider.turnPumpOn() : provider.turnPumpOff();
              future.then((success) {
                if (success) {
                  _showSnackBar(context, l10n.success, AppColors.success);
                } else if (provider.errorMessage != null) {
                  _showSnackBar(context, provider.errorMessage!, AppColors.danger);
                }
              });
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
