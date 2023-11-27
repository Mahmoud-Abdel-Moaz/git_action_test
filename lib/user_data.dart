class UserData {
  UserData({
    this.id,
    this.name,
    this.nationality,
    this.city,
  });

  UserData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    nationality = json['nationality'];
    city = json['city'];
  }
  int? id;
  String? name;
  String? nationality;
  String? city;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['nationality'] = nationality;
    map['city'] = city;
    return map;
  }
}
