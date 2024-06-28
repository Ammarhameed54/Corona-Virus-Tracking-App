import 'package:coronatracker/models/corona_model.dart';
import 'package:coronatracker/services/services.dart';
import 'package:coronatracker/views/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  // final colorList = [
  //   const Color(0xff4285f4),
  //   const Color(0xff1aa268),
  //   const Color(0xffde5246),
  //   Color.fromARGB(255, 255, 255, 255),
  // ];
  @override
  Widget build(BuildContext context) {
    StatServices statServices = StatServices();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                  future: statServices.getstatsapi(),
                  builder: (context, AsyncSnapshot<CoronaModel> snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                        flex: 1,
                        child: SpinKitFadingCircle(
                          controller: _controller,
                          color: Colors.white,
                          size: 50,
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          PieChart(
                            dataMap: {
                              "Total":
                                  double.parse(snapshot.data!.cases.toString()),
                              "Recovered": double.parse(
                                  snapshot.data!.recovered.toString()),
                              "Deaths": double.parse(
                                  snapshot.data!.deaths.toString()),
                              "Active": double.parse(
                                  snapshot.data!.active.toString()),
                              "Today Cases": double.parse(
                                  snapshot.data!.todayCases.toString()),
                              "Today Deaths": double.parse(
                                  snapshot.data!.todayDeaths.toString())
                            },
                            chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true),
                            chartRadius:
                                MediaQuery.of(context).size.width / 3.2,
                            legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.left),
                            chartType: ChartType.ring,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Card(
                              child: Column(
                                children: [
                                  ReuseableRow(
                                      title: "Total Cases",
                                      value: snapshot.data!.cases.toString()),
                                  ReuseableRow(
                                      title: "Recovered",
                                      value:
                                          snapshot.data!.recovered.toString()),
                                  ReuseableRow(
                                      title: "Deaths",
                                      value: snapshot.data!.deaths.toString()),
                                  ReuseableRow(
                                      title: "Active",
                                      value: snapshot.data!.active.toString()),
                                  ReuseableRow(
                                      title: "Today Cases",
                                      value:
                                          snapshot.data!.todayCases.toString()),
                                  ReuseableRow(
                                      title: "Today Deaths",
                                      value: snapshot.data!.todayDeaths
                                          .toString()),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CountriesList())),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: const Color(0xff1aa268),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                child: Text("Track Countries"),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
      )),
    );
  }
}

// ignore: must_be_immutable
class ReuseableRow extends StatelessWidget {
  String title, value;
  ReuseableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider()
        ],
      ),
    );
  }
}
