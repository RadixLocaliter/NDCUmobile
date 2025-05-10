class SurveyModel {
  final int id;
  final String name;
  final int contribution;
  final String? description;
  final int type;
  final int category;
  final int survey_technique;
  final bool completed;
  final double lat;
  final double lng;
  final int district;
  final int rdhs;
  final int moh;
  final int phi;
  final int finished;
  final String lead_by;
  final String created_by;
  final String? last_sync;
  String? created;
  String? updated;

  SurveyModel(this.id, this.name, this.contribution, this.description, this.type, this.category, this.survey_technique, this.completed, this.lat, this.lng, this.district, this.rdhs, this.moh, this.phi, this.lead_by, this.created_by, this.last_sync, this.finished);

  SurveyModel.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id'].toString()),
        name = json['name'].toString(), 
        contribution = int.parse(json['contribution'].toString()), 
        description = json['description'],
        type = int.parse(json['type'].toString()),
        category = int.parse(json['category'].toString()),
        survey_technique = int.parse(json['survey_technique'].toString()),
        completed = false,
        lat = 0,
        lng = 0,
        district = json['district'],
        rdhs = json['rdhs'],
        moh = json['moh'],
        phi = json['phi'],
        lead_by = json['lead_by'],
        created_by = json['created_by'],
        finished = json['finished'],
        last_sync = json['last_sync'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contribution': contribution,
      'description': description,
      'type': type,
      'category': category,
      'survey_technique': survey_technique,
      'district': district,
      'moh': moh,
      'rdhs': rdhs,
      'phi': phi,
      'lead_by': lead_by,
      'created_by': created_by,
      'last_sync': last_sync,
      'finished': finished,
      'created': created,
      'updated': updated,
    };
  }
}
