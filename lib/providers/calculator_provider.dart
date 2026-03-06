import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calculation_history.dart';
import '../utils/calculator_utils.dart';

class CalculatorState {
  final String expression;
  final String result;
  final List<CalculationHistory> history;

  CalculatorState({
    this.expression = '',
    this.result = '0',
    this.history = const [],
  });

  CalculatorState copyWith({
    String? expression,
    String? result,
    List<CalculationHistory>? history,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      history: history ?? this.history,
    );
  }
}

class CalculatorNotifier extends Notifier<CalculatorState> {
  @override
  CalculatorState build() {
    return CalculatorState();
  }

  void onButtonPressed(String value) {
    if (value == 'AC') {
      _clear();
    } else if (value == '⌫') {
      _backspace();
    } else if (value == '=') {
      _equals();
    } else {
      _appendValue(value);
    }
  }

  void _clear() {
    state = CalculatorState(history: state.history);
  }

  void _backspace() {
    if (state.expression.isEmpty) return;
    final newExpr = state.expression.substring(0, state.expression.length - 1);
    final newResult = newExpr.isEmpty ? '0' : CalculatorUtils.evaluate(newExpr);
    state = state.copyWith(expression: newExpr, result: newResult);
  }

  void _equals() {
    if (state.expression.isEmpty) return;
    final result = CalculatorUtils.evaluate(state.expression);
    final entry = CalculationHistory(
      expression: state.expression,
      result: result,
      time: DateTime.now(),
    );
    final newHistory = [entry, ...state.history];
    state = state.copyWith(
      expression: result.startsWith('Error') ? state.expression : result,
      result: result,
      history: newHistory,
    );
  }

  void _appendValue(String value) {
    final operators = ['+', '-', '*', '/'];

    if (operators.contains(value) && state.expression.isNotEmpty) {
      final lastChar = state.expression[state.expression.length - 1];
      if (operators.contains(lastChar)) {
        final newExpr = state.expression.substring(0, state.expression.length - 1) + value;
        state = state.copyWith(expression: newExpr);
        return;
      }
    }

    if (value == '.') {
      final parts = state.expression.split(RegExp(r'[\+\-\*\/]'));
      final lastPart = parts.isNotEmpty ? parts.last : '';
      if (lastPart.contains('.')) return;
    }

    final newExpr = state.expression + value;
    final newResult = CalculatorUtils.evaluate(newExpr);
    state = state.copyWith(expression: newExpr, result: newResult);
  }

  void clearHistory() {
    state = state.copyWith(history: []);
  }
}

final calculatorProvider = NotifierProvider<CalculatorNotifier, CalculatorState>(
  CalculatorNotifier.new,
);