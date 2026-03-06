import '../providers/calculator_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/calc_button.dart';
import '../widgets/history_panel.dart';


class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the calculator state — UI rebuilds when state changes
    final calcState = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);

    // Button color definitions
    const Color operatorColor = Color(0xFFFF9500);   // Orange for operators
    const Color acColor = Color(0xFFD4D4D2);          // Light grey for AC/special
    const Color numberColor = Color(0xFF333333);      // Dark for numbers
    const Color bgColor = Color(0xFF1C1C1E);          // App background

    // Button labels in order (4 columns)
    final buttons = [
      ['AC', '%', '⌫', '/'],
      ['7', '8', '9', '*'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', '='],      // Last row: 0 is wide
    ];

    // Get colors for each button
    Color getButtonColor(String label) {
      if (['/', '*', '-', '+', '='].contains(label)) return operatorColor;
      if (['AC', '%', '⌫'].contains(label)) return acColor;
      return numberColor;
    }

    Color getTextColor(String label) {
      if (['AC', '%', '⌫'].contains(label)) return Colors.black;
      return Colors.white;
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Display Area ──
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // History button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.history, color: Colors.white54),
                        onPressed: () {
                          // Show history as a bottom sheet
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const HistoryPanel(),
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    // Current expression
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        calcState.expression.isEmpty ? '0' : calcState.expression,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Live result preview
                    Text(
                      calcState.result,
                      style: TextStyle(
                        color: calcState.result.startsWith('Error')
                            ? Colors.redAccent
                            : Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Button Grid ──
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: buttons.map((row) {
                    // Last row has special layout (wide 0 button)
                    bool isLastRow = row == buttons.last;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: isLastRow
                            ? Row(
                                children: [
                                  // Wide "0" button
                                  Expanded(
                                    flex: 2,
                                    child: CalcButton(
                                      label: '0',
                                      backgroundColor: getButtonColor('0'),
                                      textColor: getTextColor('0'),
                                      onPressed: () => notifier.onButtonPressed('0'),
                                      isWide: true,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // "." button
                                  Expanded(
                                    child: CalcButton(
                                      label: '.',
                                      backgroundColor: getButtonColor('.'),
                                      textColor: getTextColor('.'),
                                      onPressed: () => notifier.onButtonPressed('.'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // "=" button
                                  Expanded(
                                    child: CalcButton(
                                      label: '=',
                                      backgroundColor: getButtonColor('='),
                                      textColor: getTextColor('='),
                                      onPressed: () => notifier.onButtonPressed('='),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: row.asMap().entries.map((entry) {
                                  final label = entry.value;
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: entry.key == 0 ? 0 : 6,
                                        right: entry.key == row.length - 1 ? 0 : 6,
                                      ),
                                      child: CalcButton(
                                        label: label,
                                        backgroundColor: getButtonColor(label),
                                        textColor: getTextColor(label),
                                        onPressed: () => notifier.onButtonPressed(label),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}