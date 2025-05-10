class ContainerModel {
  final String type;
  final String environment;
  final bool identified;
  final String? identification;
  final String? other;
  final bool isDirty;

  ContainerModel({
    required this.type,
    required this.environment, 
    required this.identified, 
    this.identification, 
    this.other,
    required this.isDirty
  });
}