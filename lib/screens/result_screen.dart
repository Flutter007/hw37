import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:hw37/models/country_info_list.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  var countyController = TextEditingController();
  String? countryName;
  List<CountyInfoList> countryInfo = [];

  @override
  void initState() {
    super.initState();
    getCountryInfo();
  }

  Future<void> getCountryInfo() async {
    final url = Uri.parse(
      countryName != null
          ? 'https://restcountries.com/v3.1/name/$countryName'
          : 'https://restcountries.com/v3.1/name/kg',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        countryInfo = jsonData.map((e) => CountyInfoList.fromJson(e)).toList();
      });
    }
    if (response.statusCode == 404 || response.statusCode == 400) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).textTheme.titleMedium!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,

            itemBuilder:
                (ctx, index) => Row(
                  children: [
                    Column(
                      children: [
                        Text(countryInfo[index].population.toString()),
                        Text(
                          ('${countryInfo[index].area / 1000000}).toStringAsFixed(2)}'),
                        ),
                        Text(countryInfo[index].region),
                      ],
                    ),
                  ],
                ),

            itemCount: countryInfo.length,
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: countyController,
            decoration: InputDecoration(
              label: Text("Enter your country!"),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              countryName = countyController.text.trim();
            });
            getCountryInfo();
          },
          child: Text(
            "Find",
            style: GoogleFonts.alef(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeColor.color,
            ),
          ),
        ),
      ],
    );
  }
}
