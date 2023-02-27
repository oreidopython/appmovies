import 'package:flutter/material.dart';


class AtoresWidget extends StatelessWidget {
  final List atoresData;
  AtoresWidget(this.atoresData);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: atoresData.length,
          itemBuilder: (context, index) {
            final String atorpath = atoresData[index]['profile_path'];
            final String atornome= atoresData[index]['name'];
            return Container(
                child: Column (children:<Widget> [
                  Card(
                    child: Image.network(
                        "http://image.tmdb.org/t/p/w780/$atorpath", height: 50, width: 100,),
                  ),
                  Text(
                    atornome,
                    style: TextStyle(
                        color: Colors.white, fontSize: 10),
                  ),
                ],),
              );
          }),
    );
  }
}