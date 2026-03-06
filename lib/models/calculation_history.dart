// Model to represent a single history entry
class CalculationHistory {
  final String expression; // e.g. "3 + 5"
  final String result;     // e.g. "8"
  final DateTime time;

  CalculationHistory({
    required this.expression,
    required this.result,
    required DateTime? time,
  }) : time = time ?? DateTime.now();
}