import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double temperature;
  final String condition;
  final String description;
  final String iconCode;

  const Weather({
    required this.temperature,
    required this.condition,
    required this.description,
    required this.iconCode,
  });

  String get iconUrl => 'https://openweathermap.org/img/wn/\$iconCode@2x.png';

  @override
  List<Object?> get props => [temperature, condition, description, iconCode];
}
