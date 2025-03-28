import 'package:flutter/material.dart';
import '../models/country_info_list.dart';
import 'list_tile_custom.dart';

class SingleCountryWidget extends StatelessWidget {
  final CountryInfoList? countryInfo;
  final bool isFetching;
  final bool isError;

  const SingleCountryWidget({
    super.key,
    this.countryInfo,
    required this.isFetching,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    final theme = Theme.of(context);

    if (isFetching) {
      content = Center(child: CircularProgressIndicator());
    } else if (isError) {
      content = Center(
        child: Text(
          'Something went wrong,please try again!',
          style: TextStyle(fontSize: 30),
        ),
      );
    } else {
      final localCountry = countryInfo!;
      content = ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTileCustom(title: 'Country :', subtitle: localCountry.name),
                ListTileCustom(
                  title: 'Capital :',
                  subtitle: localCountry.capital[0],
                ),
                ListTileCustom(
                  title: 'Population :',
                  subtitle:
                      '${(localCountry.population / 1000000).toStringAsFixed(3)} mln',
                ),
                ListTileCustom(
                  title: 'Area :',
                  subtitle: '${localCountry.area.round()} km2',
                ),
                ListTileCustom(
                  title: 'Region :',
                  subtitle: localCountry.region,
                ),
                ListTileCustom(
                  title: "Borders with : ",
                  subtitle: localCountry.borders!.join('\n'),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(
          'INFO about country!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: content,
    );
  }
}
