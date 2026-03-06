// Utility functions for calculator math operations

class CalculatorUtils {
  // Evaluates a math expression string like "3 + 5 * 2"
  // Returns the result as a string, or an error message
  static String evaluate(String expression) {
    try {
      // Replace the × and ÷ symbols if used
      String cleaned = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/');

      // Handle percentage: replace "X%" with "(X/100)"
      cleaned = _handlePercentage(cleaned);

      if (cleaned.isEmpty) return '0';

      // Use Dart to evaluate the expression
      final result = _calculate(cleaned);

      // Handle division by zero
      if (result == double.infinity || result == double.negativeInfinity) {
        return 'Error: ÷ by 0';
      }

      if (result.isNaN) return 'Error';

      // Return clean number (remove trailing .0 if whole number)
      if (result == result.toInt()) {
        return result.toInt().toString();
      } else {
        // Limit to 10 decimal places
        return double.parse(result.toStringAsFixed(10))
            .toString();
      }
    } catch (e) {
      return 'Error';
    }
  }

  // Replaces "X%" with "(X/100)"
  static String _handlePercentage(String expression) {
    return expression.replaceAllMapped(
      RegExp(r'(\d+\.?\d*)%'),
      (match) => '(${match.group(1)}/100)',
    );
  }

  // Simple recursive expression evaluator
  static double _calculate(String expression) {
    // Remove surrounding spaces
    expression = expression.trim();

    // Find last + or - not inside parentheses (lowest precedence)
    int parenDepth = 0;
    int lastPlusMinusIndex = -1;

    for (int i = expression.length - 1; i >= 0; i--) {
      final char = expression[i];
      if (char == ')') parenDepth++;
      if (char == '(') parenDepth--;

      if (parenDepth == 0 && (char == '+' || char == '-') && i > 0) {
        lastPlusMinusIndex = i;
        break;
      }
    }

    if (lastPlusMinusIndex > 0) {
      final left = _calculate(expression.substring(0, lastPlusMinusIndex));
      final right = _calculate(expression.substring(lastPlusMinusIndex + 1));
      return expression[lastPlusMinusIndex] == '+' ? left + right : left - right;
    }

    // Find last * or / not inside parentheses
    parenDepth = 0;
    int lastMulDivIndex = -1;

    for (int i = expression.length - 1; i >= 0; i--) {
      final char = expression[i];
      if (char == ')') parenDepth++;
      if (char == '(') parenDepth--;

      if (parenDepth == 0 && (char == '*' || char == '/')) {
        lastMulDivIndex = i;
        break;
      }
    }

    if (lastMulDivIndex >= 0) {
      final left = _calculate(expression.substring(0, lastMulDivIndex));
      final right = _calculate(expression.substring(lastMulDivIndex + 1));
      if (expression[lastMulDivIndex] == '*') return left * right;
      if (right == 0) return double.infinity;
      return left / right;
    }

    // Handle parentheses
    if (expression.startsWith('(') && expression.endsWith(')')) {
      return _calculate(expression.substring(1, expression.length - 1));
    }

    // Handle negative numbers
    if (expression.startsWith('-')) {
      return -_calculate(expression.substring(1));
    }

    // Base case: parse number
    return double.parse(expression);
  }
}