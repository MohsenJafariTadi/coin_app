import 'dart:convert';

class Crypto {
  String id;
  String name;
  String symbol;
  double changePercent24hr;
  double priceUsd;
  double marketCapUsd;
  int rank;

  Crypto(this.id,
      this.name,
      this.symbol,
      this.changePercent24hr,
      this.priceUsd,
      this.marketCapUsd,
      this.rank,);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'changePercent24hr': changePercent24hr,
      'priceUsd': priceUsd,
      'marketCapUsd': marketCapUsd,
      'rank': rank,
    };
  }

  factory Crypto.fromJson(Map<String, dynamic> jsonMapObject) {
    Crypto crypto = Crypto(
        jsonMapObject['id'],
        jsonMapObject['name'],
        jsonMapObject['symbol'],
        double.parse(jsonMapObject["changePercent24Hr"]),
    double.parse(jsonMapObject['priceUsd']),
    double.parse(jsonMapObject['marketCapUsd']),
    int.parse(jsonMapObject['rank']),
    );

    return crypto;
  }

  String toJsonString() {
    return """{"id": "$id","name":"$name","symbol": "$symbol","changePercent24Hr": "$changePercent24hr","priceUsd": "$priceUsd","marketCapUsd": "$marketCapUsd","rank": "$rank"}""";
  }

  Crypto fromJsonString(String jsonStr) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
    return Crypto.fromJson(jsonMap);
  }

  @override
  String toString() {
    return 'Crypto{id: $id, name: $name, symbol: $symbol, changePercent24Hr: $changePercent24hr, priceUsd: $priceUsd, marketCapUsd: $marketCapUsd, rank: $rank}';
  }
}
