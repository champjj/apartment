import 'dart:convert';

class Paymentmodel {
  final String roomprice;
  final String waterprice;
  final String elecprice;
  final String unitwater;
  final String unitelec;
  final String total;
  final String date;
  Paymentmodel({
    this.roomprice,
    this.waterprice,
    this.elecprice,
    this.unitwater,
    this.unitelec,
    this.total,
    this.date,
  });

  Paymentmodel copyWith({
    String roomprice,
    String waterprice,
    String elecprice,
    String unitwater,
    String unitelec,
    String total,
    String date,
  }) {
    return Paymentmodel(
      roomprice: roomprice ?? this.roomprice,
      waterprice: waterprice ?? this.waterprice,
      elecprice: elecprice ?? this.elecprice,
      unitwater: unitwater ?? this.unitwater,
      unitelec: unitelec ?? this.unitelec,
      total: total ?? this.total,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomprice': roomprice,
      'waterprice': waterprice,
      'elecprice': elecprice,
      'unitwater': unitwater,
      'unitelec': unitelec,
      'total': total,
      'date': date,
    };
  }

  factory Paymentmodel.fromMap(Map<String, dynamic> map) {
    return Paymentmodel(
      roomprice: map['roomprice'],
      waterprice: map['waterprice'],
      elecprice: map['elecprice'],
      unitwater: map['unitwater'],
      unitelec: map['unitelec'],
      total: map['total'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Paymentmodel.fromJson(String source) =>
      Paymentmodel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'paymentmodel(roomprice: $roomprice, waterprice: $waterprice, elecprice: $elecprice, unitwater: $unitwater, unitelec: $unitelec, total: $total, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Paymentmodel &&
        other.roomprice == roomprice &&
        other.waterprice == waterprice &&
        other.elecprice == elecprice &&
        other.unitwater == unitwater &&
        other.unitelec == unitelec &&
        other.total == total &&
        other.date == date;
  }

  @override
  int get hashCode {
    return roomprice.hashCode ^
        waterprice.hashCode ^
        elecprice.hashCode ^
        unitwater.hashCode ^
        unitelec.hashCode ^
        total.hashCode ^
        date.hashCode;
  }
}
