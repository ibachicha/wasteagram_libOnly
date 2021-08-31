import 'package:flutter/material.dart';
import 'package:wasteagram/models/postData.dart';

class RowDetail extends StatelessWidget {
  const RowDetail({Key? key}) : super(key: key);
  static const routeNames = 'rowDetails';
  @override
  Widget build(BuildContext context) {
    final readDB = ModalRoute.of(context)?.settings.arguments as WriteToDB;
    final String date = readDB.date.toString();
    final String url = readDB.imgurl.toString();
    final String quantity = readDB.quantity.toString();
    final String latitude = readDB.latitude.toString();
    final String longitude = readDB.longitude.toString();
    print(url);
    return Scaffold(
      appBar: AppBar(title: Text('Wasteagram')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(50.0),
            child: Text(
              date,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(height: 10, width: 20),
          Image.network(url),
          SizedBox(height: 100, width: 20),
          Text(quantity + ' items', style: TextStyle(fontSize: 40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 100, 5, 10),
                  child: Text('Location:     (' + latitude,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Padding(
                  padding: EdgeInsets.fromLTRB(5, 100, 5, 10),
                  child: Text(longitude + ')',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          )
        ],
      ),
    );
  }
}
