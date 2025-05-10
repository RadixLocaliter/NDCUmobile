class SurveyGnsModel {
  final int survey_id;
  final int gn;
  final String? created;
  final String? updated;

  SurveyGnsModel(this.survey_id, this.gn, this.created, this.updated,);

  SurveyGnsModel.fromJson(Map<String, dynamic> json)
  : created = json['created'],
    updated = json['updated'],
    survey_id = json['survey_id'],
    gn = json['gn'];

  Map<String, dynamic> toMap() {
    return {
      'survey_id': survey_id,
      'gn': gn,
      'created': created,
      'updated': updated,
    };
  }
}
