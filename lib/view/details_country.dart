import 'package:covid_tracker/view/world_stat.dart';
import 'package:flutter/material.dart';

class DetailsCountryScreen extends StatefulWidget {
  final String name;
  final String image;
  final int totalCases;
  final int totalDeaths;
  final int totalRecovered;
  final int active;
  final int critical;
  final int population;
  final int tests;
  final int oneCasePerPeople;
  final int oneDeathPerPeople;

  DetailsCountryScreen({
    required this.name,
    required this.image,
    required this.totalCases,
    required this.totalDeaths,
    required this.totalRecovered,
    required this.active,
    required this.critical,
    required this.population,
    required this.tests,
    required this.oneCasePerPeople,
    required this.oneDeathPerPeople,
  });

  @override
  State<DetailsCountryScreen> createState() => _DetailsCountryScreenState();
}

class _DetailsCountryScreenState extends State<DetailsCountryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .067),
                  //padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .06),
                        ReuseableRow(
                            title: 'Cases',
                            value: widget.totalCases.toString()),
                        ReuseableRow(
                            title: 'Deaths',
                            value: widget.totalDeaths.toString()),
                        ReuseableRow(
                            title: 'Recovered',
                            value: widget.totalRecovered.toString()),
                        ReuseableRow(
                            title: 'Active',
                            value: widget.active.toString()),
                        ReuseableRow(
                            title: 'Critical',
                            value: widget.critical.toString()),
                        ReuseableRow(
                            title: 'Population',
                            value: widget.population.toString()),
                        ReuseableRow(
                            title: 'Tests',
                            value: widget.tests.toString()),
                        ReuseableRow(
                            title: 'OneCasePerPeople',
                            value: widget.oneCasePerPeople.toString()),
                        ReuseableRow(
                            title: 'OneDeathPerPeople',
                            value: widget.oneDeathPerPeople.toString()),
                       
                      ],
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.image),
                  radius: 50.0,
                )
              ],
            )
            //
          ],
        ));
  }
}
