class GnModel {
  final int id;
  final int district;
  final int rdhs;
  final int moh;
  final int phi;
  final String name;

  GnModel(this.id, this.district, this.rdhs, this.moh, this.phi, this.name);

  GnModel.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    district = json['district'],
    rdhs = json['rdhs'],
    moh = json['moh'],
    phi = json['phi'],
    name = json['name'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'district': district,
      'rdhs': rdhs,
      'moh': moh,
      'phi': phi,
      'name': name,
    };
  }
}
