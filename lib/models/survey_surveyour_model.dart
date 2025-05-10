class SurveySurveyourModel {
  final int survey_id;
  final String username;
  final String created;
  final String updated;

  SurveySurveyourModel(this.survey_id, this.username, this.created, this.updated);

  SurveySurveyourModel.fromJson(Map<String, dynamic> json)
  : created = json['created'],
    updated = json['updated'],
    survey_id = int.parse(json['survey_id'].toString()),
    username = json['username'];

  Map<String, dynamic> toMap() {
    return {
      'survey_id': survey_id,
      'username': username,
      'created': created,
      'updated': updated,
    };
  }
}
