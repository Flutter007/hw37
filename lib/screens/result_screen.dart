import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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
  Widget? errorText;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getCountryInfo() async {
    final url = Uri.parse('https://restcountries.com/v3.1/name/$countryName');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        countryInfo = jsonData.map((e) => CountryInfoList.fromJson(e)).toList();
        errorText = null;
      });
    }
    if (response.statusCode == 404 || response.statusCode == 400) {
      setState(() {
        errorText = Text(
          'No country found!',
          style: GoogleFonts.alef(
            fontSize: 20,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
        TextButton(
          onPressed: () {
            setState(() {
              countryName = countryController.text;
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
        errorText == null
            ? Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(10),

                itemBuilder:
                    (ctx, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTileCustom(
                          title: 'Country',

                          subtitle: countryName!,
                        ),
                        ListTileCustom(
                          title: 'Capital',
                          subtitle: countryInfo[index].capital[0],
                        ),

                        ListTileCustom(
                          title: 'Population',
                          subtitle:
                              '${(countryInfo[index].population / 1000000).toStringAsFixed(2)} mln',
                        ),

                        ListTileCustom(
                          title: 'Area',
                          subtitle: '${countryInfo[index].area.floor()} km2',
                        ),

                        ListTileCustom(
                          title: 'Region',
                          subtitle: countryInfo[index].region,
                        ),
                      ],
                    ),
                itemCount: countryInfo.length,
              ),
            )
            : Center(child: errorText),
      ],
    );
  }
}
