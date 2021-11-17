import 'package:SmartPurchase/widgets/pet_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../configuration.dart';

class PetCategoryDisplay extends StatelessWidget {
  const PetCategoryDisplay({Key key, this.petList}) : super(key: key);
  final petList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: petList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: PetCard(
              petId: petList[index]['id'],
              petName: petList[index]['name'],
              age: petList[index]['age'],
              breed: petList[index]['breed'],
              gender: petList[index]['gender'],
              distance: petList[index]['distance'],
              imagePath: petList[index]['imagePath'],
              petInfo: petList[index],
            ),
          );
        },
      ),
    );
  }
}
