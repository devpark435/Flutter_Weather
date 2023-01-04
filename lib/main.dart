import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_weather/provider/weekWeather.dart';
import 'package:flutter_weather/provider/weather.dart';
import 'package:flutter_weather/realWeek.dart';
import 'Week.dart';
import 'getGps.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

var mainWidth;
var mainHeight;
String BgImage = '';

class _MainPageState extends State<MainPage> {
  late Future<Weather> weather;
  // late Future<TimeWeather> timeWeather;

  @override
  void initState() {
    super.initState();
    weather = getWeather();

    // timeWeather = getTimeWeather();
  }

  @override
  Widget build(BuildContext context) {
    mainWidth = MediaQuery.of(context).size.width * 0.9;
    mainHeight = MediaQuery.of(context).size.height;

    return new FutureBuilder(
        future: weather,
        builder: (BuildContext context, snapshot) {
          var mainColor = Colors.white;

          if (snapshot.hasData) {
            var temp = (snapshot.data!.temp - 273.15).toStringAsFixed(0);
            // var temp = snapshot.data?.temp;
            var maxTemp = (snapshot.data!.tempMax - 273.15).toStringAsFixed(1);
            var minTemp = (snapshot.data!.tempMin - 273.15).toStringAsFixed(1);
            var humidity = snapshot.data!.code;
            var weather = snapshot.data!.weatherMain;
            var lon = snapshot.data!.lon;
            var lat = snapshot.data!.lon;
            print('${weather}');
            return Scaffold(
              backgroundColor: mainColor,
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(mainWeather(weather)))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Stack(
                      //AppBar
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                icon: Icon(Icons.place),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    getWeather();
                                  });
                                },
                              ),
                              GradientText(
                                'Seoul',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                gradientType: GradientType.linear,
                                gradientDirection: GradientDirection.ttb,
                                radius: 100,
                                colors: [
                                  Colors.black,
                                  Colors.grey,
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: double.infinity,
                          child: IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: ((context) => WeekView(
                              //               bgImg: weather,
                              //             ))));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => WeekPage(
                                            today: weather,
                                            lon: lon,
                                            lat: lat,
                                            maxT: minTemp,
                                            minT: maxTemp,
                                          ))));
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: ((context) => gpsTest())));
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                        //지금 온도
                        alignment: Alignment.bottomRight,
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: GradientText(
                          '${temp}°',
                          style: TextStyle(
                            fontSize: 100.0,
                            fontWeight: FontWeight.bold,
                          ),
                          gradientType: GradientType.linear,
                          gradientDirection: GradientDirection.ttb,
                          radius: 100,
                          colors: [
                            Colors.black,
                            Color.fromARGB(142, 158, 158, 158),
                          ],
                        )),
                    Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GradientText(
                              //최고온도
                              '최고 ${maxTemp}°',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              gradientType: GradientType.linear,
                              gradientDirection: GradientDirection.ttb,
                              radius: 100,
                              colors: [
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 158, 158, 158),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GradientText(
                              //최저온도
                              '최저 ${minTemp}°',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              gradientType: GradientType.linear,
                              gradientDirection: GradientDirection.ttb,
                              radius: 100,
                              colors: [
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 158, 158, 158),
                              ],
                            )
                          ],
                        )),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.bottomRight,
                            width: double.infinity,
                            child: GradientText(
                              //최고온도
                              '위도 ${snapshot.data!.lat.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                              gradientType: GradientType.linear,
                              gradientDirection: GradientDirection.ttb,
                              radius: 100,
                              colors: [
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 158, 158, 158),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            width: double.infinity,
                            child: GradientText(
                              //최저온도
                              '경도 ${snapshot.data!.lon.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                              gradientType: GradientType.linear,
                              gradientDirection: GradientDirection.ttb,
                              radius: 100,
                              colors: [
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 158, 158, 158),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(300),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('images/coldPerson.jpg'),
                              opacity: 0.8),
                        ))
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

String mainWeather(weather) {
  //백그라운드 이미지
  switch (weather) {
    case 'Clouds':
      BgImage = 'images/CloudsBackGround.jpg';
      return BgImage;
    case 'Mist':
      BgImage = 'images/CloudsBackGround.jpg';
      return BgImage;

    case 'Snow':
      BgImage = 'images/CloudsBackGround.jpg';
      return BgImage;
    case 'Clear':
      BgImage = 'images/CloudsBackGround.jpg';
      return BgImage;

    default:
      return BgImage;
  }
}
