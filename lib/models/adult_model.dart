class AdultModel {
  final int survey_id;
  final String address;
  final int container_id;
  final int environment;
  final int resting_area;
  final String? other_area;
  final int resting_place;
  final String? other_place;
  final int? wall_type;
  final String? wall_other;
  final int resting_height;
  final int ae_female;
  final int albo_female;
  final int non_fed;
  final int blood_fed;
  final int semi_gravid;
  final int gravid;
  final int ae_male;
  final int albo_male;
  final String? note;
  final String? created;
  final String? updated;

  AdultModel({required this.survey_id, required this.address, required this.container_id,
  required this.resting_area, this.other_area, required this.resting_place, this.other_place, this.wall_type, 
  this.wall_other, required this.resting_height, required this.ae_female, required this.albo_female, required this.ae_male, 
  required this.albo_male, required this.environment, required this.note, required this.non_fed, required this.blood_fed,  
  required this.semi_gravid, required this.gravid, this.created, this.updated,});

  AdultModel.fromJson(Map<String, dynamic> json)
  : created = json['created'],
    updated = json['updated'],
    survey_id = json['survey_id'],
    address = json['address'],
    container_id = json['container_id'],
    resting_area = json['resting_area'],
    other_area = json['other_area'],
    resting_place = json['resting_place'],
    other_place = json['other_place'],
    wall_type = json['wall_type'],
    wall_other = json['wall_other'],
    resting_height = json['resting_height'],
    ae_female = json['ae_female'],
    albo_female = json['albo_female'],
    non_fed = json['non_fed'],
    blood_fed = json['blood_fed'],
    semi_gravid = json['semi_gravid'],
    gravid = json['gravid'],
    ae_male = json['ae_male'],
    albo_male = json['albo_male'],
    environment = json['environment'],
    note = json['note'];

  Map<String, dynamic> toMap() {
    return {
      'survey_id': survey_id,
      'address': address,
      'container_id': container_id,
      'resting_area': resting_area,
      'other_area': other_area,
      'resting_place': resting_place,
      'other_place': other_place,
      'wall_type': wall_type,
      'wall_other': wall_other,
      'resting_height': resting_height,
      'ae_female': ae_female,
      'albo_female': albo_female,
      'non_fed': non_fed,
      'blood_fed': blood_fed,
      'semi_gravid': semi_gravid,
      'gravid': gravid,
      'ae_male': ae_male,
      'albo_male': albo_male,
      'environment': environment,
      'note': note,
      'created': created,
      'updated': updated,
    };
  }
}