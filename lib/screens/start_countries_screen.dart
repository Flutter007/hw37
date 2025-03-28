import 'package:flutter/material.dart';
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
  List<CountryShort> sortedCountries = [];
  bool isFetching = true;
  String? errorTxt;

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  @override
  void dispose() {
    countryController.dispose();
    super.dispose();
  }

  void getCountries() async {
    try {
      final List<dynamic> countriesDataShort = await request(
        'https://restcountries.com/v3.1/all?fields=name,flags',
      );
      setState(() {
        countries =
            countriesDataShort.map((e) => CountryShort.fromJson(e)).toList();
        sortedCountries = List.from(countries);
        isFetching = false;
      });
    } catch (e) {
      setState(() {
        errorTxt = e.toString();
        isFetching = false;
      });
    }
  }

  void openCountryInfo(String name) {
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
    final theme = Theme.of(context);
    sortedCountries.sort((a, b) => a.name.compareTo(b.name));
    Widget content;
    if (isFetching) {
      content = Center(child: CircularProgressIndicator());
    } else if (errorTxt != null) {
      content = Center(
        child: Row(
          children: [
            Icon(Icons.error, size: 30, color: theme.colorScheme.error),
            Expanded(
              child: Text(
                errorTxt!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    } else {
      content = Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  sortedCountries =
                      countries
                          .where(
                            (e) => e.name.toLowerCase().contains(
                              value.toLowerCase(),
                            ),
                          )
                          .toList();
                  errorTxt = null;
                });
              },
              onTap:
                  () => setState(() {
                    countryController.text = '';
                    sortedCountries = List.from(countries);
                  }),
              controller: countryController,
              decoration: InputDecoration(
                label: Text("Enter your country!"),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          sortedCountries.isNotEmpty
              ? Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemBuilder:
                      (ctx, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTilePhoto(
                            onTap:
                                () => openCountryInfo(
                                  sortedCountries[index].name,
                                ),
                            title: sortedCountries[index].name,
                            subtitle: sortedCountries[index].flag,
                          ),
                        ],
                      ),
                  itemCount: sortedCountries.length,
                ),
              )
              : Center(
                child: Text(
                  'No country found yet!',
                  style: TextStyle(fontSize: 28),
                ),
              ),
        ],
      );
    }
    return content;
  }
}
