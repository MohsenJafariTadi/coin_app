import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'dart:developer' as dev;
import 'response.dart';
import 'dart:convert';
import 'crypto.dart';

class UseApi {
  static Future<ResponseModel> getCrypto() async {
    Hive.openBox("HiveBox");
    final hive = Hive.box("HiveBox");
    bool haveNetwork = await hasNetwork();
    // dev.log(haveNetwork.toString());
    if (haveNetwork) {
      const url = "https://api.coincap.io/v2/assets";
      final response = await http.get(Uri.parse(url));
      List<Crypto> cryptos = [];
      dev.log(response.statusCode.toString());

      for (var data in jsonDecode(response.body)["data"]) {
        Crypto crypto = Crypto.fromJson(data);
        cryptos.add(crypto);
      }
      hive.put("HiveValue", getStringJsonCryptos(cryptos));
      hive.close();
      dev.log('haveNetwork');
      return ResponseModel(cryptos, true);
    } else {
      dev.log('errorNetwork');
      return ResponseModel(
          getListCryptoFromString(hive.get("HiveValue")), false);
    }
  }

  static Future<bool> hasNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static String getStringJsonCryptos(List<Crypto> cryptos) {
    String jsonCrypto = '{"cryptos" : [';
    for (var crypto in cryptos) {
      jsonCrypto += crypto.toJsonString();
      if (crypto != cryptos.last) jsonCrypto += ",";
    }
    jsonCrypto += "]}";
    return jsonCrypto;
  }

  static List<Crypto> getListCryptoFromString(String jsonCryptos) {
    List<Crypto> cryptos = [];

    final jsonList = jsonDecode(jsonCryptos)['cryptos'];
    for (var json in jsonList) {
      cryptos.add(Crypto.fromJson(json));
    }
    return cryptos;
  }
}
