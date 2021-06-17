import 'dart:convert';

class OverdueModel {
  dynamic room;
  dynamic total;
  dynamic date;
  OverdueModel({
    this.room,
    this.total,
    this.date,
  });

  OverdueModel copyWith({
    dynamic room,
    dynamic total,
    dynamic date,
  }) {
    return OverdueModel(
      room: room ?? this.room,
      total: total ?? this.total,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'room': room,
      'total': total,
      'date': date,
    };
  }

  factory OverdueModel.fromMap(Map<String, dynamic> map) {
    return OverdueModel(
      room: map['room'],
      total: map['total'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OverdueModel.fromJson(String source) =>
      OverdueModel.fromMap(json.decode(source));

  @override
  String toString() => 'OverdueModel(room: $room, total: $total, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OverdueModel &&
        other.room == room &&
        other.total == total &&
        other.date == date;
  }

  @override
  int get hashCode => room.hashCode ^ total.hashCode ^ date.hashCode;
}
