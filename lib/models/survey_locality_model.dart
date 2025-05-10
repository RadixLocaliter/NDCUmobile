class SurveyLocalityModel {
  final int survey_id;
  final int gn;
  final String locality;
  final String? created;
  final String? updated;

  SurveyLocalityModel(this.survey_id, this.gn, this.created, this.updated, this.locality,);

  SurveyLocalityModel.fromJson(Map<String, dynamic> json)
  : created = json['created'],
    updated = json['updated'],
    survey_id = json['survey_id'],
    locality = json['locality'],
    gn = json['gn'];

  Map<String, dynamic> toMap() {
    return {
      'survey_id': survey_id,
      'gn': gn,
      'locality': locality,
      'created': created,
      'updated': updated,
    };
  }
}
