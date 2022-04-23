import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

class BitcoinPage extends StatelessWidget {
  const BitcoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFDE7),
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text('Bitcoin Convert Calculator'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Center(
                      child:
                          Image.asset('assets/images/bitcoin.png', scale: 4)),
                )),
            Container(
              height: 350,
              child: const BitcoinConvertForm(),
            ),
          ],
        )),
      ),
    );
  }
}

class BitcoinConvertForm extends StatefulWidget {
  const BitcoinConvertForm({Key? key}) : super(key: key);

  @override
  State<BitcoinConvertForm> createState() => _BitcoinConvertFormState();
}

class _BitcoinConvertFormState extends State<BitcoinConvertForm> {
  String? selectedType;
  String? selectedUnit;
  TextEditingController inputEditingController = TextEditingController();
  double input = 0.0, output = 0.0, amount = 0.0;
  String unit = "";
  String desc = "";
  List<String> unitList = [];
  List<String> typeList = ["Crypto", "Fiat"];
  List<String> cryptoList = [
    "Ether (ETH)",
    "Litecoin (LTC)",
    "Bitcoin Cash (BCH)",
    "Binance Coin (BNB)",
    "EOS",
    "XRP",
    "Lumens (XLM)",
    "Chainlink (LINK)",
    "Polkadot (DOT)",
    "Yearn.finance (YFI)",
    "BITS",
    "Satoshi (SATS)"
  ];
  List<String> fiatList = [
    "US Dollar (USD)",
    "United Arab Emirates Dirham (AED)",
    "Argentine Peso (ARS)",
    "Australian Dollar (AUD)",
    "Bangladeshi Taka (BDT)",
    "Bahraini Dinar (BHD)",
    "Bermudian Dollar (BMD)",
    "Brazil Real (BRL)",
    "Canadian Dollar (CAD)",
    "Swiss Franc (CHF)",
    "Chilean Peso (CLP)",
    "Chinese Yuan (CNY)",
    "Czech Koruna (CZK)",
    "Danish Krone (DKK)",
    "Euro (EUR)",
    "British Pound Sterling (GBP)",
    "Hong Kong Dollar (HKD)",
    "Hungarian Forint (HUF)",
    "Indonesian Rupiah (IDR)",
    "Israeli New Shekel (ILS)",
    "Indian Rupee (INR)",
    "Japanese Yen (JPY)",
    "South Korean Won (KRW)",
    "Kuwaiti Dinar (KWD)",
    "Sri Lankan Rupee (LKR)",
    "Burmese Kyat (MMK)",
    "Mexican Peso (MXN)",
    "Malaysian Ringgit (MYR)",
    "Nigerian Naira (NGN)",
    "Norwegian Krone (NOK)",
    "New Zealand Dollar (NZD)",
    "Philippine Peso (PHP)",
    "Pakistani Rupee (PKR)",
    "Polish Zloty (PLN)",
    "Russian Ruble (RUB)",
    "Saudi Riyal (SAR)",
    "Swedish Krona (SEK)",
    "Singapore Dollar (SGD)",
    "Thai Baht (THB)",
    "Turkish Lira (TRY)",
    "New Taiwan Dollar (TWD)",
    "Ukrainian hryvnia (UAH)",
    "Venezuelan bolívar fuerte (VEF)",
    "Vietnamese đồng (VND)",
    "South African Rand (ZAR)",
    "IMF Special Drawing Rights (XDR)"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: inputEditingController,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Enter Bitcoin's value to convert",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              DropdownButton(
                hint: const Text("Select type"),
                itemHeight: 50,
                isExpanded: true,
                value: selectedType,
                items: typeList.map((String value) {
                  return DropdownMenuItem(
                    child: Text(value, style: const TextStyle(fontSize: 15)),
                    value: value,
                  );
                }).toList(),
                onChanged: _onChangedReturn,
              ),
              Scrollbar(
                child: DropdownButton(
                  hint: const Text("Select unit to convert"),
                  itemHeight: 50,
                  isExpanded: true,
                  value: selectedUnit,
                  items: unitList.map((String value) {
                    return DropdownMenuItem(
                      child: Text(value, style: const TextStyle(fontSize: 15)),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (unit) {
                    setState(() {
                      selectedUnit = unit.toString();
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: _bitcoinConvert, child: const Text("Convert")),
              const SizedBox(height: 10),
              Text(desc,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  void _onChangedReturn(type) {
    if (type == "Crypto") {
      unitList = cryptoList;
    } else if (type == "Fiat") {
      unitList = fiatList;
    } else {
      unitList = [];
    }

    setState(() {
      selectedType = type.toString();
      selectedUnit = null;
    });
  }

  Future<void> _bitcoinConvert() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Converting..."), title: const Text("Message"));
    progressDialog.show();

    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);
    var rescode = response.statusCode;
    input = double.parse(inputEditingController.text);
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        if (selectedUnit == "Ether (ETH)") {
          unit = parsedJson['rates']['eth']['unit'];
          amount = parsedJson['rates']['eth']['value'];
        } else if (selectedUnit == "Litecoin (LTC)") {
          unit = parsedJson['rates']['ltc']['unit'];
          amount = parsedJson['rates']['ltc']['value'];
        } else if (selectedUnit == "Bitcoin Cash (BCH)") {
          unit = parsedJson['rates']['bch']['unit'];
          amount = parsedJson['rates']['bch']['value'];
        } else if (selectedUnit == "Binance Coin (BNB)") {
          unit = parsedJson['rates']['bnb']['unit'];
          amount = parsedJson['rates']['bnb']['value'];
        } else if (selectedUnit == "EOS") {
          unit = parsedJson['rates']['eos']['unit'];
          amount = parsedJson['rates']['eos']['value'];
        } else if (selectedUnit == "XRP") {
          unit = parsedJson['rates']['xrp']['unit'];
          amount = parsedJson['rates']['xrp']['value'];
        } else if (selectedUnit == "Lumens (XLM)") {
          unit = parsedJson['rates']['xlm']['unit'];
          amount = parsedJson['rates']['xlm']['value'];
        } else if (selectedUnit == "Chainlink (LINK)") {
          unit = parsedJson['rates']['link']['unit'];
          amount = parsedJson['rates']['link']['value'];
        } else if (selectedUnit == "Polkadot (DOT)") {
          unit = parsedJson['rates']['dot']['unit'];
          amount = parsedJson['rates']['dot']['value'];
        } else if (selectedUnit == "Yearn.finance (YFI)") {
          unit = parsedJson['rates']['yfi']['unit'];
          amount = parsedJson['rates']['yfi']['value'];
        } else if (selectedUnit == "BITS") {
          unit = parsedJson['rates']['bits']['unit'];
          amount = parsedJson['rates']['bits']['value'];
        } else if (selectedUnit == "Satoshi (SATS)") {
          unit = parsedJson['rates']['sats']['unit'];
          amount = parsedJson['rates']['sats']['value'];
        } else if (selectedUnit == "US Dollar (USD)") {
          unit = parsedJson['rates']['usd']['unit'];
          amount = parsedJson['rates']['usd']['value'];
        } else if (selectedUnit == "United Arab Emirates Dirham (AED)") {
          unit = parsedJson['rates']['aed']['unit'];
          amount = parsedJson['rates']['aed']['value'];
        } else if (selectedUnit == "Argentine Peso (ARS)") {
          unit = parsedJson['rates']['ars']['unit'];
          amount = parsedJson['rates']['ars']['value'];
        } else if (selectedUnit == "Australian Dollar (AUD)") {
          unit = parsedJson['rates']['aud']['unit'];
          amount = parsedJson['rates']['aud']['value'];
        } else if (selectedUnit == "Bangladeshi Taka (BDT)") {
          unit = parsedJson['rates']['bdt']['unit'];
          amount = parsedJson['rates']['bdt']['value'];
        } else if (selectedUnit == "Bahraini Dinar (BHD)") {
          unit = parsedJson['rates']['bhd']['unit'];
          amount = parsedJson['rates']['bhd']['value'];
        } else if (selectedUnit == "Bermudian Dollar (BMD)") {
          unit = parsedJson['rates']['bmd']['unit'];
          amount = parsedJson['rates']['bmd']['value'];
        } else if (selectedUnit == "Brazil Real (BRL)") {
          unit = parsedJson['rates']['brl']['unit'];
          amount = parsedJson['rates']['brl']['value'];
        } else if (selectedUnit == "Canadian Dollar (CAD)") {
          unit = parsedJson['rates']['cad']['unit'];
          amount = parsedJson['rates']['cad']['value'];
        } else if (selectedUnit == "Swiss Franc (CHF)") {
          unit = parsedJson['rates']['chf']['unit'];
          amount = parsedJson['rates']['chf']['value'];
        } else if (selectedUnit == "Chilean Peso (CLP)") {
          unit = parsedJson['rates']['clp']['unit'];
          amount = parsedJson['rates']['clp']['value'];
        } else if (selectedUnit == "Chinese Yuan (CNY)") {
          unit = parsedJson['rates']['cny']['unit'];
          amount = parsedJson['rates']['cny']['value'];
        } else if (selectedUnit == "Czech Koruna (CZK)") {
          unit = parsedJson['rates']['czk']['unit'];
          amount = parsedJson['rates']['czk']['value'];
        } else if (selectedUnit == "Danish Krone (DKK)") {
          unit = parsedJson['rates']['dkk']['unit'];
          amount = parsedJson['rates']['dkk']['value'];
        } else if (selectedUnit == "Euro (EUR)") {
          unit = parsedJson['rates']['eur']['unit'];
          amount = parsedJson['rates']['eur']['value'];
        } else if (selectedUnit == "British Pound Sterling (GBP)") {
          unit = parsedJson['rates']['gbp']['unit'];
          amount = parsedJson['rates']['gbp']['value'];
        } else if (selectedUnit == "Hong Kong Dollar (HKD)") {
          unit = parsedJson['rates']['hkd']['unit'];
          amount = parsedJson['rates']['hkd']['value'];
        } else if (selectedUnit == "Hungarian Forint (HUF)") {
          unit = parsedJson['rates']['huf']['unit'];
          amount = parsedJson['rates']['huf']['value'];
        } else if (selectedUnit == "Indonesian Rupiah (IDR)") {
          unit = parsedJson['rates']['idr']['unit'];
          amount = parsedJson['rates']['idr']['value'];
        } else if (selectedUnit == "Israeli New Shekel (ILS)") {
          unit = parsedJson['rates']['ils']['unit'];
          amount = parsedJson['rates']['ils']['value'];
        } else if (selectedUnit == "Indian Rupee (INR)") {
          unit = parsedJson['rates']['inr']['unit'];
          amount = parsedJson['rates']['inr']['value'];
        } else if (selectedUnit == "Japanese Yen (JPY)") {
          unit = parsedJson['rates']['jpy']['unit'];
          amount = parsedJson['rates']['jpy']['value'];
        } else if (selectedUnit == "South Korean Won (KRW)") {
          unit = parsedJson['rates']['krw']['unit'];
          amount = parsedJson['rates']['krw']['value'];
        } else if (selectedUnit == "Kuwaiti Dinar (KWD)") {
          unit = parsedJson['rates']['kwd']['unit'];
          amount = parsedJson['rates']['kwd']['value'];
        } else if (selectedUnit == "Sri Lankan Rupee (LKR)") {
          unit = parsedJson['rates']['lkr']['unit'];
          amount = parsedJson['rates']['lkr']['value'];
        } else if (selectedUnit == "Burmese Kyat (MMK)") {
          unit = parsedJson['rates']['mmk']['unit'];
          amount = parsedJson['rates']['mmk']['value'];
        } else if (selectedUnit == "Mexican Peso (MXN)") {
          unit = parsedJson['rates']['mxn']['unit'];
          amount = parsedJson['rates']['mxn']['value'];
        } else if (selectedUnit == "Malaysian Ringgit (MYR)") {
          unit = parsedJson['rates']['myr']['unit'];
          amount = parsedJson['rates']['myr']['value'];
        } else if (selectedUnit == "Nigerian Naira (NGN)") {
          unit = parsedJson['rates']['ngn']['unit'];
          amount = parsedJson['rates']['ngn']['value'];
        } else if (selectedUnit == "Norwegian Krone (NOK)") {
          unit = parsedJson['rates']['nok']['unit'];
          amount = parsedJson['rates']['nok']['value'];
        } else if (selectedUnit == "New Zealand Dollar (NZD)") {
          unit = parsedJson['rates']['nzd']['unit'];
          amount = parsedJson['rates']['nzd']['value'];
        } else if (selectedUnit == "Philippine Peso (PHP)") {
          unit = parsedJson['rates']['php']['unit'];
          amount = parsedJson['rates']['php']['value'];
        } else if (selectedUnit == "Pakistani Rupee (PKR)") {
          unit = parsedJson['rates']['pkr']['unit'];
          amount = parsedJson['rates']['pkr']['value'];
        } else if (selectedUnit == "Polish Zloty (PLN)") {
          unit = parsedJson['rates']['pln']['unit'];
          amount = parsedJson['rates']['pln']['value'];
        } else if (selectedUnit == "Russian Ruble (RUB)") {
          unit = parsedJson['rates']['rub']['unit'];
          amount = parsedJson['rates']['rub']['value'];
        } else if (selectedUnit == "Saudi Riyal (SAR)") {
          unit = parsedJson['rates']['sar']['unit'];
          amount = parsedJson['rates']['sar']['value'];
        } else if (selectedUnit == "Swedish Krona (SEK)") {
          unit = parsedJson['rates']['sek']['unit'];
          amount = parsedJson['rates']['sek']['value'];
        } else if (selectedUnit == "Singapore Dollar (SGD)") {
          unit = parsedJson['rates']['sgd']['unit'];
          amount = parsedJson['rates']['sgd']['value'];
        } else if (selectedUnit == "Thai Baht (THB)") {
          unit = parsedJson['rates']['thb']['unit'];
          amount = parsedJson['rates']['thb']['value'];
        } else if (selectedUnit == "Turkish Lira (TRY)") {
          unit = parsedJson['rates']['try']['unit'];
          amount = parsedJson['rates']['try']['value'];
        } else if (selectedUnit == "New Taiwan Dollar (TWD)") {
          unit = parsedJson['rates']['twd']['unit'];
          amount = parsedJson['rates']['twd']['value'];
        } else if (selectedUnit == "Ukrainian hryvnia (UAH)") {
          unit = parsedJson['rates']['uah']['unit'];
          amount = parsedJson['rates']['uah']['value'];
        } else if (selectedUnit == "Venezuelan bolívar fuerte (VEF)") {
          unit = parsedJson['rates']['vef']['unit'];
          amount = parsedJson['rates']['vef']['value'];
        } else if (selectedUnit == "Vietnamese đồng (VND)") {
          unit = parsedJson['rates']['vnd']['unit'];
          amount = parsedJson['rates']['vnd']['value'];
        } else if (selectedUnit == "South African Rand (ZAR)") {
          unit = parsedJson['rates']['zar']['unit'];
          amount = parsedJson['rates']['zar']['value'];
        } else if (selectedUnit == "IMF Special Drawing Rights (XDR)") {
          unit = parsedJson['rates']['xdr']['unit'];
          amount = parsedJson['rates']['xdr']['value'];
        }
        output = input * amount;
        desc = "BTC $input = $unit $output";
      });
      progressDialog.dismiss();
    } else {
      setState(() {
        desc = "No record";
      });
      progressDialog.dismiss();
    }
  }
}
