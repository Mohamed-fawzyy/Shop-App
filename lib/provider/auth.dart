// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD1QOjPDckdSfJs37BrUnjha05KlVDqIfA');
    try {
      final res = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final resData = json.decode(res.body);
      if (resData['error'] != null) {
        throw HttpException(resData['error']['message']);
      }
      _token = resData['idToken'];
      _userId = resData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(resData['expiresIn']),
        ),
      );
      _autoLogOut();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (er) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
    // we add return here to make sure that auth will be waiting for the signUp
    //and without it its gona work but not wait it
  }

  Future<void> signIN(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
    notifyListeners();
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;

    final extractedData = //as Map<String, Object>
        json.decode(prefs.getString('userData') ?? "") as Map<String, dynamic>;

    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();

    _autoLogOut();
    return true;
  }
}
