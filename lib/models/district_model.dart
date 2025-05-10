class DistrictModel {
  final int id;
  final String name;

  DistrictModel(this.id, this.name);

  DistrictModel.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    name = json['name'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name
    };
  }
}
