class Room {
  String room,
      address,
      idcard,
      name,
      note,
      number,
      password,
      status,
      username,
      floor;

  Room(this.address, this.idcard, this.name, this.note, this.number,
      this.password, this.room, this.status, this.username, this.floor);

  Room.fromMap(Map<String, dynamic> map) {
    this.address = map['address'];
    this.floor = map['floor'];
    this.idcard = map['idcard'];
    this.name = map['name'];
    this.note = map['note'];
    this.number = map['number'];
    this.password = map['password'];
    this.room = map['room'];
    this.status = map['status'];
    this.username = map['username'];
  }
}
