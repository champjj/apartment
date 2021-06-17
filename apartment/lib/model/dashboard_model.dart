import 'dart:convert';

// ignore: camel_case_types
class billmeter {
  final dynamic total;
  final dynamic waterprice;
  final dynamic elecprice;
  final dynamic date;
  billmeter({
    this.total,
    this.waterprice,
    this.elecprice,
    this.date,
  });

  billmeter copyWith({
    dynamic total,
    dynamic waterprice,
    dynamic elecprice,
    dynamic date,
  }) {
    return billmeter(
      total: total ?? this.total,
      waterprice: waterprice ?? this.waterprice,
      elecprice: elecprice ?? this.elecprice,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'waterprice': waterprice,
      'elecprice': elecprice,
      'date': date,
    };
  }

  factory billmeter.fromMap(Map<String, dynamic> map) {
    return billmeter(
      total: map['total'],
      waterprice: map['waterprice'],
      elecprice: map['elecprice'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory billmeter.fromJson(String source) =>
      billmeter.fromMap(json.decode(source));

  @override
  String toString() {
    return 'billmeter(total: $total, waterprice: $waterprice, elecprice: $elecprice, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is billmeter &&
        other.total == total &&
        other.waterprice == waterprice &&
        other.elecprice == elecprice &&
        other.date == date;
  }

  @override
  int get hashCode {
    return total.hashCode ^
        waterprice.hashCode ^
        elecprice.hashCode ^
        date.hashCode;
  }
}
