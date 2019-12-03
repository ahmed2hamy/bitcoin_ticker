import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'coin_data.dart';

const apiUrl = 'https://apiv2.bitcoinaverage.com/indices/global/ticker';

class NetworkingHelper {
  Future getData({@required String fiat}) async {
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      String requestUrl = '$apiUrl/$crypto$fiat';
      var response = await http.get(requestUrl);
      if (response.statusCode == 200) {
        var data = convert.jsonDecode(response.body);
        double lastPrice = data['last'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print("Request failed with status: ${response.statusCode}.");
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
