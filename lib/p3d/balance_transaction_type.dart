class BalanceTransactionTypeValue {
  static const BalanceTransactionType defaultType =
      BalanceTransactionType.transferKeepAlive;

  const BalanceTransactionTypeValue(this.type);

  final BalanceTransactionType type;

  @override
  String toString() {
    return type.name;
  }
}

enum BalanceTransactionType {
  transfer,
  transferKeepAlive,
}
