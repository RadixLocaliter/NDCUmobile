class PupalModel {
  final int survey_id;
  final String address;
  final int container_id;
  final String breeding_type;
  final int environment;
  final int observation;
  final String? samples;
  final int? identified;
  final int? identified_type;
  final String? identified_other;
  final String? note;
  final String? created;
  final String? updated;

  PupalModel({required this.survey_id, required this.address, required this.container_id, required this.environment,
  required this.breeding_type, required this.observation, this.samples, this.identified, this.identified_type, 
  this.identified_other, this.note, this.created, this.updated,});

  PupalModel.fromJson(Map<String, dynamic> json)
  : created = json['created'],
    updated = json['updated'],
    survey_id = json['survey_id'],
    address = json['address'],
    container_id = json['container_id'],
    environment = json['environment'],
    breeding_type = json['breeding_type'],
    observation = json['observation'],
    samples = json['samples'],
    identified = json['identified'],
    identified_type = json['identified_type'],
    identified_other = json['identified_other'],
    note = json['note'];

  Map<String, dynamic> toMap() {
    return {
      'survey_id': survey_id,
      'address': address,
      'container_id': container_id,
      'environment': environment,
      'breeding_type': breeding_type,
      'observation': observation,
      'samples': samples,
      'identified': identified,
      'identified_type': identified_type,
      'identified_other': identified_other,
      'note': note,
      'created': created,
      'updated': updated,
    };
  }
}