import 'package:flutter/material.dart';
import 'package:hw37/helpers/request.dart';
import 'package:hw37/widgets/single_country_widget.dart';

import '../models/country_info_list.dart';

class SingleCountryScreen extends StatefulWidget {
  final String countryName;
  const SingleCountryScreen({super.key, required this.countryName});

  @override
  State<SingleCountryScreen> createState() => _SingleCountryScreenState();
}

class _SingleCountryScreenState extends State<SingleCountryScreen> {
  late Future<CountryInfoList> countryInfo;

  @override
  void initState() {
    super.initState();
    countryInfo = getCountryInfo();
  }

  Future<CountryInfoList> getCountryInfo() async {
    final List<dynamic> countriesData = await request(
      'https://restcountries.com/v3.1/name/${widget.countryName}',
    );
    for (int i = 0; i < countriesData.length; i++) {
      if (countriesData[i]['borders'] == null) {
        countriesData[i]['borders'] = ['No Borders with other countries'];
      } else {
        final borders =
            countriesData.expand((country) => country['borders']).toList();
        final bordersFutures =
            borders.map((border) {
              return request('https://restcountries.com/v3.1/alpha/$border');
            }).toList();
        final bordersData = await Future.wait(bordersFutures);
        countriesData[i]['borders'] =
            bordersData.map((border) => border[i]['name']['common']).toList();
      }
    }
    return CountryInfoList.fromJson(countriesData[0]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: countryInfo,
      builder: (ctx, snapshot) {
        return SingleCountryWidget(
          isFetching: snapshot.connectionState == ConnectionState.waiting,
          countryInfo: snapshot.data,
          isError: snapshot.hasError,
        );
      },
    );
  }
}
