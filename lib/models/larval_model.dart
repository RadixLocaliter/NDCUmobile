class LarvalModel {
  final int survey_id;
  final String address;
  final int container_id;
  final String breeding_type;
  // final String? other_breeding_type;
  final int type;
  final int environment;
  final int observation;
  final String? samples;
  final int? breeding;
  final int? identified;
  final int? identified_type;
  final String? identified_other;
  final String? note;
  final String? created;
  final String? updated;

  LarvalModel({required this.survey_id, required this.address, required this.container_id, required this.breeding_type,
  required this.type, required this.environment, required this.observation, this.created, this.updated,
  this.samples, this.breeding, this.identified, this.identified_type, this.identified_other, this.note,});

  LarvalModel.fromJson(Map<String, dynamic> json)
  : created = json['created'],
    updated = json['updated'],
    survey_id = json['survey_id'],
    address = json['address'],
    container_id = json['container_id'],
    breeding_type = json['breeding_type'],
    type = json['type'],
    environment = json['environment'],
    observation = json['observation'],
    // other_breeding_type = json['other_breeding_type'],
    samples = json['samples'],
    breeding = json['breeding'],
    identified = json['identified'],
    identified_type = json['identified_type'],
    identified_other = json['identified_other'],
    note = json['note'];

  Map<String, dynamic> toMap() {
    return {
      'survey_id': survey_id,
      'address': address,
      'container_id': container_id,
      'breeding_type': breeding_type,
      'type': type,
      'environment': environment,
      'observation': observation,
      // 'other_breeding_type': other_breeding_type,
      'samples': samples,
      'breeding': breeding,
      'identified': identified,
      'identified_type': identified_type,
      'identified_other': identified_other,
      'note': note,
      'created': created,
      'updated': updated,
    };
  }
}