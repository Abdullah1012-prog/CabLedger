class DailyRecord {
  const DailyRecord({
    this.id,
    required this.date,
    required this.sale,
    required this.fuel,
    required this.expense,
    this.expenseDescription,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;

  /// ISO date `YYYY-MM-DD`.
  final String date;
  final double sale;
  final double fuel;
  final double expense;
  final String? expenseDescription;
  final String? createdAt;
  final String? updatedAt;

  double get net => sale - fuel - expense;

  DailyRecord copyWith({
    int? id,
    String? date,
    double? sale,
    double? fuel,
    double? expense,
    String? expenseDescription,
    String? createdAt,
    String? updatedAt,
    bool clearDescription = false,
  }) {
    return DailyRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      sale: sale ?? this.sale,
      fuel: fuel ?? this.fuel,
      expense: expense ?? this.expense,
      expenseDescription: clearDescription
          ? null
          : (expenseDescription ?? this.expenseDescription),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'date': date,
      'sale': sale,
      'fuel': fuel,
      'expense': expense,
      'expense_description': expenseDescription,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory DailyRecord.fromMap(Map<String, Object?> map) {
    return DailyRecord(
      id: map['id'] as int?,
      date: map['date'] as String,
      sale: (map['sale'] as num).toDouble(),
      fuel: (map['fuel'] as num).toDouble(),
      expense: (map['expense'] as num).toDouble(),
      expenseDescription: map['expense_description'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }
}
