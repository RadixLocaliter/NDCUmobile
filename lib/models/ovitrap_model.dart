class OvitrapModel {
  final int survey_id;
  final String address;
  final int container_id;
  final int environment;
  final int collected;
  final int? identification;
  final int? fecundity;
  final String? note;
  final String? created;
  final String? updated;

  OvitrapModel({required this.survey_id, required this.address, required this.container_id, required this.collected,  
  this.identification, this.fecundity, required this.environment, this.note, this.created, this.updated,});

  OvitrapModel.fromJson(Map<String, dynamic> json)
  : created = json['created'],
    updated = json['updated'],
    survey_id = json['survey_id'],
    address = json['address'],
    container_id = json['container_id'],
    environment = json['environment'],
    collected = json['collected'],
    identification = json['identification'],
    fecundity = json['fecundity'],
    note = json['note'];

  Map<String, dynamic> toMap() {
    return {
      'survey_id': survey_id,
      'address': address,
      'container_id': container_id,
      'environment': environment,
      'collected': collected,
      'identification': identification,
      'fecundity': fecundity,
      'note': note,
      'created': created,
      'updated': updated,
    };
  }
}