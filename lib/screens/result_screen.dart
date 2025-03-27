import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hw37/helpers/request.dart';
import 'package:hw37/models/country_info_list.dart';
import 'package:hw37/models/country_short.dart';
import 'package:hw37/screens/single_country_screen.dart';

import '../widgets/list_tile_photo.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  var countryController = TextEditingController();
  String? countryName;
  List<CountryInfoList> countryInfo = [];
  List<CountryShort> countries = [];
  String? wrongEntry;
  bool isFetching = false;
  String? errorTxt;

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  void getCountries() async {
    final List<dynamic> countriesDataShort = await request(
      'https://restcountries.com/v3.1/all?fields=name,flags',
    );
    setState(() {
      countries =
          countriesDataShort.map((e) => CountryShort.fromJson(e)).toList();
      isFetching = false;
      print(countries.length);
    });
  }

  void country(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return SingleCountryScreen(countryName: name);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (countries.isEmpty) {
      content = Center(child: CircularProgressIndicator());
    } else {
      content = Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  errorTxt = null;
                  countries =
                      countries
                          .where(
                            (e) => e.name.toLowerCase().contains(
                              value.toLowerCase(),
                            ),
                          )
                          .toList();
                });
              },
              onTap:
                  () => setState(() {
                    countryController.text = '';
                  }),
              controller: countryController,
              decoration: InputDecoration(
                label: Text("Enter your country!"),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemBuilder:
                  (ctx, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTilePhoto(
                        onTap: () => country(countries[index].name),
                        title: countries[index].name,
                        subtitle: countries[index].flag,
                      ),
                    ],
                  ),
              itemCount: countries.length,
            ),
          ),
          SizedBox(height: 20),
        ],
      );
    }
    return content;
  }
}
