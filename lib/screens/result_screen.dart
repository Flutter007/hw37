import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hw37/helpers/request.dart';
import 'package:hw37/models/country_info_list.dart';
import 'package:hw37/models/country_short.dart';
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
    });
  }

  Future<void> getCountryInfo() async {
    try {
      final List<dynamic> countriesData = await request(
        'https://restcountries.com/v3.1/name/$countryName',
      );
      for (var i = 0; i < countriesData.length; i++) {
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

      setState(() {
        countryInfo =
            countriesData.map((e) => CountryInfoList.fromJson(e)).toList();
        isFetching = false;
      });
    } catch (error) {
      setState(() {
        isFetching = false;
        errorTxt = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget content;
    if (isFetching) {
      content = Center(child: CircularProgressIndicator());
    } else {
      content =
          content = Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      errorTxt = null;
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
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    countryName = countryController.text;
                    isFetching = true;
                  });
                  getCountryInfo();
                },
                child: Text(
                  "Find",
                  style: GoogleFonts.alef(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
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
