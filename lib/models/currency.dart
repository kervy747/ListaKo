class AppCurrency {
  const AppCurrency({
    required this.code,
    required this.symbol,
    required this.name,
  });

  final String code;
  final String symbol;
  final String name;
}

class AppCurrencies {
  AppCurrencies._();

  static const List<AppCurrency> all = [
    AppCurrency(code: 'PHP', symbol: '₱', name: 'Philippine Peso'),
    AppCurrency(code: 'USD', symbol: '\$', name: 'US Dollar'),
    AppCurrency(code: 'EUR', symbol: '€', name: 'Euro'),
    AppCurrency(code: 'GBP', symbol: '£', name: 'British Pound'),
    AppCurrency(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    AppCurrency(code: 'KRW', symbol: '₩', name: 'South Korean Won'),
    AppCurrency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
    AppCurrency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar'),
    AppCurrency(code: 'SGD', symbol: 'S\$', name: 'Singapore Dollar'),
    AppCurrency(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
  ];
}