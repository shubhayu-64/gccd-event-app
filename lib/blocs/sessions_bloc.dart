import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/sessions_model.dart';

class SessionsGridBloc extends ChangeNotifier {
  // create a api call to get the sessions list
  // http call to get the sessions list
  final Uri sessionsUrl =
      Uri.parse("https://sessionize.com/api/v2/kirmfltc/view/GridSmart");

  List<SessionsGrid> _day1Sessions = [];

  List<SessionsGrid> get day1Sessions => _day1Sessions;

  List<SessionsGrid> _day2Sessions = [];

  List<SessionsGrid> get day2Sessions => _day1Sessions;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isError = false;

  bool get isError => _isError;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  SessionsGridBloc() {
    _fetchSessions();
  }

  void _fetchSessions() async {
    _isLoading = true;
    notifyListeners();
    // try {
      final response = await get(sessionsUrl);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final day1TimeslotsData = data[0]["timeSlots"];
        final day2TimeslotsData = data[1]["timeSlots"];
        for (var timeslot in day1TimeslotsData) {
          final rooms = timeslot["rooms"];
          for (var room in rooms) {
            final sessionData = room["session"];
            SessionsGrid session = SessionsGrid.fromJson(sessionData);
            _day1Sessions.add(session);
          }
        }
        for (var timeslot in day2TimeslotsData) {
          final rooms = timeslot["rooms"];
          for (var room in rooms) {
            final sessionData = room["session"];
            SessionsGrid session = SessionsGrid.fromJson(sessionData);
            _day2Sessions.add(session);
          }
        }

        print("${_day1Sessions.length} ${day2Sessions.length}");

        _isLoading = false;
        notifyListeners();
      } else {
        _isError = true;
        _errorMessage = "Something went wrong";
        notifyListeners();
      }
    // } catch (e) {
    //   _isError = true;
    //   if (kDebugMode) {
    //     print(e.toString());
    //   }
    //   _errorMessage = "Something went wrong";
    //   notifyListeners();
    // }
  }
}