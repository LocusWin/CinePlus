import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class ConnectionStatusModel extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription _connectionSubscription;
  bool _isOnline = false;

  var isDeviceConnected = false;

  ConnectionStatusModel() {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        _isOnline = await DataConnectionChecker().hasConnection;

        notifyListeners();
      }
    });
    //checkInternetConnection();
  }

  bool get isOnline => _isOnline;

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Mobile data detected & internet connection confirmed.
        _isOnline = true;
      } else {
        // Mobile data detected but no internet connection found.
        _isOnline = false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a WIFI network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Wifi detected & internet connection confirmed.
        _isOnline = true;
        print('is online');
      } else {
        // Wifi detected but no internet connection found.
        _isOnline = false;
        print('not online');
      }
    } else {
      // Neither mobile data or WIFI detected, not internet connection found.
      _isOnline = false;
    }

    notifyListeners();

    return _isOnline;
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}
