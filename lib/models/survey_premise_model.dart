class SurveyPremiseModel {
  final int survey_id;
  final String locality;
  final String address;
  final String type;
  final double lat;
  final double lng;
  final String? created;
  final String? updated;

  SurveyPremiseModel(this.survey_id, this.locality, this.address, this.type, this.lat, this.lng, this.created, this.updated,);

  SurveyPremiseModel.fromJson(Map<String, dynamic> json)
  : created = json['created'],
    updated = json['updated'],
    survey_id = json['survey_id'],
    locality = json['locality'],
    address = json['address'],
    type = json['type'],
    lat = json['lat'].toDouble(),
    lng = json['lng'].toDouble();
    
  Map<String, dynamic> toMap() {
    return {
      'survey_id': survey_id,
      'locality': locality,
      'address': address,
      'type': type,
      'lat': lat,
      'lng': lng,
      'created': created,
      'updated': updated,
    };
  }
}
