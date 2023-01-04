import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_weather/provider/weekWeather.dart';
import 'package:flutter_weather/realWeek.dart';

class WeekPage extends StatefulWidget {
  const WeekPage(
      {super.key,
      required this.today,
      required this.lon,
      required this.lat,
      required this.minT,
      required this.maxT});
  final String today;
  final String minT;
  final String maxT;
  final double lon;
  final double lat;

  @override
  State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  @override
  void initState() {
    super.initState();
    weekWeather();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: weekWeather(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Color.fromARGB(255, 167, 167, 167),
              appBar: AppBar(
                title: Text(
                  '주간 날씨',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Color.fromARGB(255, 167, 167, 167),
              ),
              body: SafeArea(
                  child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: Column(children: [
                      weatherIcon2(widget.today),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '최고 ${widget.maxT}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '최저 ${widget.minT}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '위도 ${widget.lat.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '경도 ${widget.lon.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ],
                      )
                    ]),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: ListView.builder(
                        itemCount: snapshot.data!.week!.length == 0
                            ? 0
                            : snapshot.data!.week!.length,
                        itemBuilder: ((context, index) {
                          var date = snapshot.data!.week![index].day;
                          var maxTemp = snapshot.data!.week![index].tempMax;
                          var minTemp = snapshot.data!.week![index].tempMin;
                          var rain = snapshot.data!.week![index].rain;
                          var weather = snapshot.data!.week![index].main;
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Color.fromRGBO(255, 255, 255, 70)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: weatherIcon2(weather),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(10),
                                    height: 100,
                                    width: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '최고 ${maxTemp}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: int.parse(maxTemp
                                                            .toString()) >
                                                        0
                                                    ? Colors.amber
                                                    : Colors.blue),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '최저 ${minTemp}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: int.parse(minTemp
                                                            .toString()) >
                                                        0
                                                    ? Colors.amber
                                                    : Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Icon(
                                      Icons.ac_unit,
                                      size: 50,
                                      color: Color.fromARGB(255, 171, 189, 209),
                                    ),
                                  ),
                                  Container(
                                      width: 50,
                                      child: Text(
                                        '${rain}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 171, 189, 209),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        })),
                  ),
                ],
              )),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              getRealWeek(bgImg: widget.today))));
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }));
  }
}

Widget weatherIcon2(weatherData) {
  double iconSize = 80;
  switch (weatherData) {
    case 'Clear':
      return Icon(
        Icons.sunny,
        size: iconSize,
        color: Colors.amber,
      );
    case 'Mist':
      return Icon(
        Icons.sunny_snowing,
        size: iconSize,
        color: Colors.grey,
      );
    case 'Clouds':
      return Icon(
        Icons.cloud,
        size: iconSize,
        color: Colors.grey,
      );

    default:
      return Icon(Icons.quiz_sharp);
  }
}
