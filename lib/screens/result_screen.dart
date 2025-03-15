import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hw37/helpers/request.dart';
import 'package:hw37/models/country_info_list.dart';
import '../widgets/list_tile_custom.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  var countryController = TextEditingController();
  String? countryName;
  List<CountryInfoList> countryInfo = [];
  bool isFetching = false;
  String? errorTxt;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getCountryInfo() async {
    try {
      final List<dynamic> jsonData = await request(
        'https://restcountries.com/v3.1/name/$countryName',
      );
      setState(() {
        countryInfo = jsonData.map((e) => CountryInfoList.fromJson(e)).toList();
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
    } else if (errorTxt != null) {
      content = Center(child: Text(errorTxt!, textAlign: TextAlign.center));
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
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
                      ListTileCustom(
                        title: 'Country',
                        subtitle: countryInfo[index].name,
                      ),
                      ListTileCustom(
                        title: 'Capital',
                        subtitle: countryInfo[index].capital[0],
                      ),

                      ListTileCustom(
                        title: 'Population',
                        subtitle:
                            '${(countryInfo[index].population / 1000000).toStringAsFixed(3)} mln',
                      ),

                      ListTileCustom(
                        title: 'Area',
                        subtitle: '${countryInfo[index].area.round()} km2',
                      ),

                      ListTileCustom(
                        title: 'Region',
                        subtitle: countryInfo[index].region,
                      ),
                    ],
                  ),
              itemCount: countryInfo.length,
            ),
          ),
        ],
      );
    }
    return content;
  }
}
