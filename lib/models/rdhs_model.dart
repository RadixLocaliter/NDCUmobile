class RdhsModel {
  final int id;
  final int district;
  final String name;

  RdhsModel(this.id, this.district, this.name);

  RdhsModel.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    district = json['district'],
    name = json['name'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'district': district,
      'name': name,
    };
  }
}
