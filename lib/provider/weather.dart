import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../getGps.dart';
import '../main.dart';

// final _openweatherkey = '2eb451b0ad86c93e1776450abba40da0';
// String latitude = '';
// String longitude = '';

// @override
// void initState() {
//   // super.initState();
//   getPosition();
// }

// Future<void> getPosition() async {
//   var currentPosition = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);

//   print(currentPosition);
//   latitude = currentPosition.latitude.toString();
//   longitude = currentPosition.longitude.toString();

//   // getWeather(
//   //     lat: currentPosition.latitude.toString(),
//   //     lon: currentPosition.longitude.toString());
// }

Future<Weather> getWeather() async {
  Location location = Location();
  await location.getCurrentLocation();
  double longitude = location.longitude;
  double latitude = location.latitude;
  //api 호출을 위한 주소
  String apiAddr =
      "https://api.openweathermap.org/data/2.5/weather?lon=$longitude&lat=$latitude&appid=2eb451b0ad86c93e1776450abba40da0";
  http.Response response; //http request의 결과 즉 api 호출의 결과를 받기 위한 변수
  var data1; //api 호출을 통해 받은 정보를 json으로 바꾼 결과를 저장한다.
  Weather weather;

  response = await http.get(Uri.parse(apiAddr)); //필요 api 호출
  data1 = json.decode(response.body); //받은 정보를 json형태로 decode
  //받은 데이터정보를 필요한 형태로 저장한다.
  weather = Weather(
      temp: data1["main"]["temp"],
      tempMax: data1["main"]["temp_max"],
      tempMin: data1["main"]["temp_min"],
      weatherMain: data1["weather"][0]["main"],
      lon: data1["coord"]["lon"],
      lat: data1["coord"]["lat"],
      code: data1["weather"][0]["id"]);

  return weather;
}

class Weather {
  final double temp; //현재 온도
  final double tempMin; //최저 온도
  final double tempMax; //최고 온도
  final String weatherMain; //흐림정도
  final int code; //흐림정도의 id(icon 작업시 필요)
  final double lon; //경도
  final double lat; //위도

  Weather({
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.weatherMain,
    required this.code,
    required this.lon,
    required this.lat,
  });
}
