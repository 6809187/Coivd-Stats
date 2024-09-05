import 'package:covid_tracker/Models/world_states_model.dart';
import 'package:covid_tracker/Services/stats_services.dart';
import 'package:covid_tracker/view/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatScreen extends StatefulWidget {
  const WorldStatScreen({super.key});

  @override
  State<WorldStatScreen> createState() => _WorldStatScreenState();
}

class _WorldStatScreenState extends State<WorldStatScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();
  bool _isTapped = false; // Track if the container is tapped
  bool _isHovered = false; // Track if the mouse is hovered

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatsServices statsServices = StatsServices();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              FutureBuilder(
                future: statsServices.fetchWorldStatesRecords(),
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                      flex: 1,
                      child: SpinKitCircle(
                        color: Colors.white,
                        size: 50.0,
                        controller: _controller,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {

                    // If snapshot.data is null (e.g., due to a failed network request), snapshot.data?.cases will be null, and cases will be assigned 0.0. This means your pie chart and other UI elements will not break or show incorrect information due to missing data.
                    final cases = snapshot.data?.cases ?? 0.0;
                    final recovered = snapshot.data?.recovered ?? 0.0;
                    final deaths = snapshot.data?.deaths ?? 0.0;

                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "Total": double.parse(cases.toString()),
                            "Recovered": double.parse(recovered.toString()),
                            "Deaths": double.parse(deaths.toString()),
                          },
                          chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true),
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          legendOptions: const LegendOptions(
                              legendPosition: LegendPosition.left),
                          animationDuration: const Duration(milliseconds: 1200),
                          chartType: ChartType.ring,
                          colorList: colorList,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.06),
                          child: Card(
                            child: Column(
                              children: [
                                ReuseableRow(
                                  title: 'Total',
                                  value: snapshot.data!.cases.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Deaths',
                                  value: snapshot.data!.deaths.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Recovered',
                                  value: snapshot.data!.recovered.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Active',
                                  value: snapshot.data!.active.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Critical',
                                  value: snapshot.data!.critical.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Today Deaths',
                                  value: snapshot.data!.todayDeaths.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Today Recovered',
                                  value: snapshot.data!.recovered.toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) {
                            setState(() {
                              _isHovered = true;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              _isHovered = false;
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isTapped = true;
                              });

                              Future.delayed(const Duration(milliseconds: 200), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CountriesListScreen(),
                                  ),
                                );
                              });

                              // Reset the tapped state
                              Future.delayed(const Duration(milliseconds: 100), () {
                                setState(() {
                                  _isTapped = false;
                                });
                              });
                            },
                            child: Opacity(
                              opacity: _isTapped ? 0.6 : 1.0,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _isHovered ? const Color(0xff1e8a50) : const Color(0xff1aa260),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Track Countries',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  final String title, value;
  const ReuseableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
