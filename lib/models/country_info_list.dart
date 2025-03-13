class CountryInfoList {
  final List<String> capital;
  final String region;
  final double area;
  final double population;

  CountryInfoList({
    required this.capital,
    required this.region,
    required this.area,
    required this.population,
  });
  factory CountryInfoList.fromJson(Map<String, dynamic> json) {
    return CountryInfoList(
      capital: List<String>.from(json['capital']),
      region: json['region'],
      area: json['area'].toDouble(),
      population: json['population'].toDouble(),
    );
  }
}
