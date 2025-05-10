class PhiModel {
  final int id;
  final int district;
  final int rdhs;
  final int moh;
  final String name;

  PhiModel(this.id, this.district, this.rdhs, this.moh, this.name);

  PhiModel.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    district = json['district'],
    rdhs = json['rdhs'],
    moh = json['moh'],
    name = json['name'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'district': district,
      'rdhs': rdhs,
      'moh': moh,
      'name': name,
    };
  }
}
