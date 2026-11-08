class Vehicle {
  const Vehicle({
    this.id = 1,
    required this.vehicleName,
    this.registrationNumber,
    this.purchaseDate,
    this.purchasePrice,
  });

  final int id;
  final String vehicleName;
  final String? registrationNumber;

  /// ISO date `YYYY-MM-DD`, nullable when unset.
  final String? purchaseDate;
  final double? purchasePrice;

  bool get hasPurchasePrice =>
      purchasePrice != null && purchasePrice! > 0;

  Vehicle copyWith({
    int? id,
    String? vehicleName,
    String? registrationNumber,
    String? purchaseDate,
    double? purchasePrice,
    bool clearRegistration = false,
    bool clearPurchaseDate = false,
    bool clearPurchasePrice = false,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleName: vehicleName ?? this.vehicleName,
      registrationNumber: clearRegistration
          ? null
          : (registrationNumber ?? this.registrationNumber),
      purchaseDate: clearPurchaseDate
          ? null
          : (purchaseDate ?? this.purchaseDate),
      purchasePrice: clearPurchasePrice
          ? null
          : (purchasePrice ?? this.purchasePrice),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'vehicle_name': vehicleName,
      'registration_number': registrationNumber,
      'purchase_date': purchaseDate,
      'purchase_price': purchasePrice,
    };
  }

  factory Vehicle.fromMap(Map<String, Object?> map) {
    return Vehicle(
      id: map['id'] as int? ?? 1,
      vehicleName: map['vehicle_name'] as String,
      registrationNumber: map['registration_number'] as String?,
      purchaseDate: map['purchase_date'] as String?,
      purchasePrice: map['purchase_price'] == null
          ? null
          : (map['purchase_price'] as num).toDouble(),
    );
  }
}
