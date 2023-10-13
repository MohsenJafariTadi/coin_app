import 'package:coin_app/crypto_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/material.dart';
import 'response.dart';
import 'crypto.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('HiveBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResponseModel>(
      future: UseApi.getCrypto(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ResponseModel responseModel = snapshot.data!;
          List<Crypto> cryptos = responseModel.crytptos;
          bool internetOk = responseModel.internetOk;
          return Scaffold(
            appBar: AppBar(
              actions: [
                Icon(Icons.circle,
                    color: (internetOk) ? Colors.green : Colors.red)
              ],
            ),
            body: ListView.builder(
              itemCount: cryptos.length,
              itemBuilder: (context, index) {
                Crypto crypto = cryptos[index];
                return ListTile(
                  title: Text(crypto.name),
                  subtitle: Text(crypto.symbol),
                  trailing: Text(crypto.priceUsd.toStringAsFixed(2)),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          // There was an error
          return Scaffold(
            body: Center(
              child: Text('Error fetching crypto data: ${snapshot.error}'),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
