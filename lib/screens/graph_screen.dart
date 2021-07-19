import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'graph_data.dart';
int numDays=1;
class GraphScreen extends StatefulWidget {
GraphScreen({required this.name,required this.currentPrice,required this.icon,required this.rank,required this.marketCap,required this.id});
final String name;
final String icon;
final String currentPrice;
final String rank;
final String marketCap;
final String id;

  @override
  _GraphScreenState createState() => _GraphScreenState();

}

class _GraphScreenState extends State<GraphScreen> {
// updateVal()
// {
  late String cryptoId ;
// }
  Future<List<GraphCoordinate>> fetchGraphData() async {

    coordinates = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/$cryptoId/ohlc?vs_currency=usd&days=$numDays'));

    if (response.statusCode == 200) {

      List<dynamic> values = [];
      values = json.decode(response.body);
      // print(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            // Map<String, dynamic> map = values[i];
            coordinates.add(GraphCoordinate.fromJson(values[i]));
          }
        }
        setState(() {
          coordinates;
        });
      }
      return coordinates;
    } else {
      throw Exception('Failed to graph data');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      cryptoId = widget.id;
    });
    super.initState();
    fetchGraphData();
    // getGraphData();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 10),
              decoration: BoxDecoration(
                color: Color(0xFF262531),
                border: Border.all(color: Colors.amber,width: 3),
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(widget.icon,
                          height: 50,
                          width: 50,
                        ),
                        ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(widget.name,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),

                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [
                       Text('Rank: ${widget.rank}',
                       style: TextStyle(
                         fontFamily: 'Lato',
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                       fontSize: 30,
                       ),
                       ),

                          ],
                        ),
                      ),
                    ],
                  ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Market Cap: \$${widget.marketCap}',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontFamily: 'Lato',
                            ),
                          ),

                          Text('Price: \$${widget.currentPrice}',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontFamily: 'Lato',
                            ),
                          ),

                        ],
                      ),
                    )
                ]
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(0xFF262531),
                  border: Border.all(color: Colors.amber,width: 4),
                  borderRadius: BorderRadius.circular(10),
                ),
                // height: 350,
                child:SfCartesianChart(

                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    tooltipSettings: InteractiveTooltip(
                      enable: true,
                    ),
                  ),
                  plotAreaBorderColor: Colors.white,
                  backgroundColor: Colors.black,
                  primaryXAxis: DateTimeAxis(
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(
                      text: 'Crypto Price in \$',
                    )
                  ),

                  series: <ChartSeries>[
                    HiloOpenCloseSeries<GraphCoordinate,dynamic>(
                        dataSource: coordinates,
                        xValueMapper: (GraphCoordinate gc,_)=>gc.time,
                        lowValueMapper: (GraphCoordinate gc,_)=>gc.low,
                        highValueMapper: (GraphCoordinate gc,_)=>gc.high,
                        openValueMapper: (GraphCoordinate gc,_)=>gc.open,
                        closeValueMapper: (GraphCoordinate gc,_)=>gc.close,
                      enableTooltip: true,


                    )

                  ],


                )

       ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Container(
                 decoration : BoxDecoration(
                              color: Color(0xFF262531),
                              border: Border.all(color: Colors.amber,width: 3),
                              borderRadius: BorderRadius.circular(15),
                              ),


                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(

                            onPressed: (){
                              numDays=1;
                              setState(() {

                              });
                              fetchGraphData();
                            },
                          child: Text('1 Day',
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold
                          ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                ),
                            ),
                              backgroundColor: MaterialStateProperty.all(Colors.black),

                ),

                            ),
                        ElevatedButton(
                            onPressed: (){
                              numDays=7;
                              setState(() {

                              });
                              fetchGraphData();
                            },
                          child: Text('1 Week',
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                              ),
                            backgroundColor: MaterialStateProperty.all(Colors.black),

                          ),

                        ),
                        ElevatedButton(
                            onPressed: (){
                              numDays=365;
                              setState(() {

                              });
                              fetchGraphData();
                            },
                          child: Text('1 Year',
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),

                              ),
                            backgroundColor: MaterialStateProperty.all(Colors.black),

                          ),

                        ),

      ],
                    ),


                  ]
                  ),
                ),
              ),
            )



          ],
        ),

      ),
    );
  }
}

