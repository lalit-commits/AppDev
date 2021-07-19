import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'graph_screen.dart';
import 'package:cryptoapp/coin_class.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  Future<List<Coin>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=200&page=1&sparkline=false'));

    if (response.statusCode == 200) {

      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJson(map));
          }
        }
        setState(() {
          coinList;
        });
      }
      return coinList;
    } else {
      throw Exception('Failed to load coins');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    fetchCoin();
    Timer.periodic(Duration(seconds: 10), (timer) => fetchCoin());

    super.initState();
    // getCryptoData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF191A1D),
        centerTitle: true,
        title: Text('CryptoQuery',
          style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold
          ),

        ),

      ),
      backgroundColor: Color(0xFF191A1D),
      body: Container(
        child: Column(
          children: [
            // Padding(
            //     padding: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 40),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Color(0xFF262531),
            //       borderRadius: BorderRadius.circular(30),
            //       border: Border.all(color: Colors.amber,width: 2)
            //
            //     ),
            //     child: Row(
            //       children : [
            //         Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 10),
            //           child: Icon(Icons.search,size: 30,color: Colors.white,),
            //         ),
            //
            //         Expanded(
            //           child: TextField(
            //             showCursor: true,
            //           cursorColor: Colors.green,
            //           decoration: new InputDecoration(
            //               border: InputBorder.none,
            //               hintText: 'Search Crypto',
            //               hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
            //
            //
            //           ),
            //
            //       ),
            //         ),
            //     ]
            //     ),
            //   ),
            // ),

            Padding(

              padding:  EdgeInsets.only(left: 18,bottom: 12,right: 32,top: 20),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cryptocurrencies',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white
                  ),
                  ),


                  Text('Price',
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white
                    ),
                  )
                ],
              ),
            ),

            // DisplayRow(),
            Expanded(
              child: ListView.builder(
                // shrinkWrap: true,
                itemCount: coinList.length,

                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GraphScreen(
                          name: coinList[index].name,
                          icon: coinList[index].imageUrl,
                          currentPrice: coinList[index].price.toStringAsFixed(2),
                          rank: coinList[index].rank.toString(),
                          marketCap:coinList[index].marketCap.toString() ,
                          id: coinList[index].id.toString(),
                        )),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF262531),
                          border: Border.all(color: Colors.amber,width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(coinList[index].imageUrl,
                                height: 50,
                                width: 50,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(coinList[index].name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lato',
                                      fontSize: 20,
                                      wordSpacing: -1.5,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(coinList[index].symbol,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lato',
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: [
                                  Text('\$${coinList[index].price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('${coinList[index].changePercentage.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: coinList[index].changePercentage>=0?Colors.green:Colors.red,
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}

