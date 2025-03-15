class CountryInfoList {
  final String name;
  final List<String> capital;
  final String region;
  final double area;
  final double population;

  CountryInfoList({
    required this.name,
    required this.capital,
    required this.region,
    required this.area,
    required this.population,
  });
  factory CountryInfoList.fromJson(Map<String, dynamic> json) {
    return CountryInfoList(
      name: json['name']['common'],
      capital: List<String>.from(json['capital']),
      region: json['region'],
      area: json['area'].toDouble(),
      population: json['population'].toDouble(),
    );
  }
}
