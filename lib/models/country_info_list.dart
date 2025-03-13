class CountyInfoList {
  final String region;
  final double area;
  final double population;

  CountyInfoList({
    required this.region,
    required this.area,
    required this.population,
  });
  factory CountyInfoList.fromJson(Map<String, dynamic> json) {
    return CountyInfoList(
      region: json['region'],
      area: json['area'].toDouble(),
      population: json['population'].toDouble(),
    );
  }
}
