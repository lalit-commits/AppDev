import 'package:flutter/material.dart';

class Coin {
  Coin({
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.changePercentage,
    required this.id,
    required this.rank,
    required this.marketCap
  });

  String name;
  String symbol;
  String imageUrl;
  num price;
  num changePercentage;
  num rank;
  num marketCap;
  String id;

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      name: json['name'],
      symbol: json['symbol'],
      imageUrl: json['image'],
      price: json['current_price'],
      changePercentage: json['price_change_percentage_24h'],
      id: json['id'],
      rank: json['market_cap_rank'],
      marketCap: json['market_cap'],
    );
  }
}

List<Coin> coinList = [];