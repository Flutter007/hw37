class CountryShort {
  final String flag;
  final String name;

  CountryShort({required this.name, required this.flag});
  factory CountryShort.fromJson(Map<String, dynamic> json) {
    return CountryShort(
      flag: json['flags']['png'],
      name: json['name']['common'],
    );
  }
}
