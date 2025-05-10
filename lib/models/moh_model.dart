class MohModel {
  final int id;
  final int district;
  final int rdhs;
  final String name;

  MohModel(this.id, this.district, this.rdhs, this.name);

  MohModel.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    district = json['district'],
    rdhs = json['rdhs'],
    name = json['name'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'district': district,
      'rdhs': rdhs,
      'name': name,
    };
  }
}
