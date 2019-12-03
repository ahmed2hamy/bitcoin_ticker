import 'package:bitcoin_ticker/components/reusable_card.dart';
import 'package:bitcoin_ticker/services/coin_data.dart';
import 'package:bitcoin_ticker/services/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  bool isLoading = false;
  Map<String, String> cryptoPrices = {};
  String fiat = 'USD';

  void updateUi() async {
    isLoading = true;
    try {
      var data = await NetworkingHelper().getData(fiat: fiat);
      isLoading = false;
      setState(() {
        cryptoPrices = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    updateUi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: makeCard()),
          Text(
            'Latest Pricess By BitcoinAverage.com',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 200,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.blueAccent,
            child:
                iosPicker(), // Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }

  Column makeCard() {
    List<ReusableCard> cards = [];
    for (String crypto in cryptoList) {
      cards.add(ReusableCard(
          crypto: crypto,
          price: isLoading ? '?' : cryptoPrices[crypto],
          fiat: fiat));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cards,
    );
  }

  DropdownButton<String> androidPicker() {
    List<DropdownMenuItem<String>> dropDownMenuItems = [];
    for (String currency in currenciesList) {
      var newInput = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownMenuItems.add(newInput);
    }
    return DropdownButton<String>(
        value: fiat,
        items: dropDownMenuItems,
        onChanged: (value) {
          setState(() {
            fiat = value;
            updateUi();
          });
        });
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.blueAccent,
      itemExtent: 35.0,
      scrollController: FixedExtentScrollController(initialItem: 20),
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          fiat = currenciesList[selectedIndex];
          updateUi();
        });
      },
      children: pickerItems,
    );
  }
}
