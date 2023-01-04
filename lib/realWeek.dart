import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_weather/main.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class getRealWeek extends StatefulWidget {
  const getRealWeek({super.key, required this.bgImg});
  final String bgImg;

  @override
  State<getRealWeek> createState() => _getRealWeekState();
}

class _getRealWeekState extends State<getRealWeek> {
  List<String> minTempList = [];
  List<String> maxTempList = [];
  List<String> dateList = [];
  List<String> weatherList = [];
  Future getWeeklyData() async {
    final url = Uri.parse('https://weather.naver.com/today/09530112');
    final reponse = await http.get(url);

    dom.Document html = dom.Document.html(reponse.body);
    //#weekly > ul > li:nth-child(2) > div > div.cell_date > span > span
    final minTemps = html
        .querySelectorAll(
            'li > div > div.cell_temperature > strong > span.lowest')
        .map((e) => e.innerHtml.trim())
        .toList();
    final maxTemps = html
        .querySelectorAll(
            'li > div > div.cell_temperature > strong > span.highest')
        .map((e) => e.innerHtml.trim())
        .toList();
    final dates = html
        .querySelectorAll('li > div > div.cell_date > span > span')
        .map((e) => e.innerHtml.trim())
        .toList();
    final weather = html
        .querySelectorAll('div > div.cell_weather > span > i > span')
        .map((e) => e.innerHtml.trim())
        .toList();
    //#weekly > div.scroll_control.end_left > div > ul > li:nth-child(3) > div > div.cell_weather > span:nth-child(1) > i > span

    print('Count : ${minTemps.length}');

    // for (final minTemp in minTemps) {
    //   // debugPrint(title);
    //   // debugPrint(title.indexOf('-').toString());
    //   debugPrint(minTemp.substring(minTemp.indexOf('-')));
    // }
    // for (final maxTemp in maxTemps) {
    //   // debugPrint(title);
    //   // debugPrint(title.indexOf('-').toString());
    //   debugPrint(maxTemp.substring(31));
    // }
    for (var i = 2; i < 9; i++) {
      minTempList.add(minTemps[i].substring(31));
      maxTempList.add(maxTemps[i].substring(31));
      dateList.add(dates[i]);
    }
    for (var i = 0; i < weather.length; i++) {
      // debugPrint('${weather[i]}');
      weatherList.add(weather[i]);
      i++;
    }
    print('weatherLength${weather.length}');
    print(minTempList.length);
    print(maxTempList.length);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getWeeklyData();
    // Requesting to fetch before UI drawing starts
  }

  @override
  Widget build(BuildContext context) {
    var viewHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(mainWeather(widget.bgImg)))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: viewHeight - 50,
              child: ListView.builder(
                  itemCount: minTempList.length,
                  itemBuilder: ((context, index) {
                    var minTempInt =
                        int.parse(minTempList[index].replaceAll('°', ''));
                    var maxTempInt =
                        int.parse(maxTempList[index].replaceAll('°', ''));
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
                              child: weatherIcon(weatherList[index]),
                            ),
                            Column(
                              children: [
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(5),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: 50,
                                    child: Text(
                                      dateList[index],
                                      style: TextStyle(fontSize: 30),
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '최저 ${minTempList[index]}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: minTempInt > 0
                                                ? Colors.amber
                                                : Colors.blue),
                                      ),
                                      Text(
                                        '최고 ${maxTempList[index]}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: maxTempInt > 0
                                                ? Colors.amber
                                                : Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
            )
          ],
        ),
      ),
    );
  }
}

Widget weatherIcon(weatherData) {
  double iconSize = 80;
  switch (weatherData) {
    case '구름많음':
      return Icon(
        Icons.cloud,
        size: iconSize,
        color: Colors.grey,
      );
    case '맑음':
      return Icon(
        Icons.sunny,
        size: iconSize,
        color: Colors.amber,
      );

    default:
      return Icon(Icons.abc);
  }
}
