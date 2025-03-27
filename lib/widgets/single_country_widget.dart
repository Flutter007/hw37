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

    if (isFetching) {
      content = Center(child: CircularProgressIndicator());
    } else if (isError) {
      content = Center(child: Text('Something went wrong!'));
    } else {
      final localCountry = countryInfo!;
      content = SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTileCustom(
                onTap: () {},
                title: 'Country: ',
                subtitle: localCountry.name,
              ),
              ListTileCustom(
                onTap: () {},
                title: 'Capital :',
                subtitle: localCountry.capital[0],
              ),

              ListTileCustom(
                onTap: () {},
                title: 'Population :',
                subtitle:
                    '${(localCountry.population / 1000000).toStringAsFixed(3)} mln',
              ),

              ListTileCustom(
                onTap: () {},
                title: 'Area :',
                subtitle: '${localCountry.area.round()} km2',
              ),

              ListTileCustom(
                onTap: () {},
                title: 'Region',
                subtitle: localCountry.region,
              ),
              ListTileCustom(
                onTap: () {},
                title: "Borders with : ",
                subtitle: localCountry.borders!.join('\n'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(appBar: AppBar(title: Text('Info')), body: content);
  }
}
