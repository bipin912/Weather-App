import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';

import '../models/weather_model.dart';
class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('b0b841e4b8bb0b6954244d75632e993f');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async{
    //get the current city
    String cityName = await _weatherService.getCurrentCity();
    
    //get weather for city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather as Weather?;
      });
    }
    //any errors
    catch(e){
      print(e);
    }
  }

  //weather animation
  String getWeatherAnimation(String? mainCondition){
    if(mainCondition== null ) return 'assets/sunny.json';// default sunny

    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'snow':
      case 'frost':
        return 'assets/snow.json';
      case 'rain':
      case 'drizzle':
        return 'assets/rainny.json';
      default:
        return 'assets/sunny.json';


    }
  }


  //init state
  @override
  void initState(){
    super.initState();
    // fetch weather on startup
    _fetchWeather();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "loading city..." ),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //temperature
            Text('${_weather?.temperature.round() }°C'),

            //weather condition
            Text(_weather?.mainCondition ?? ""),
          ],
        ),
      ),
      
    );
  }
}
