import 'package:flutter/material.dart';

import '../models/food_waste_post.dart';
import '../widgets/app_bar_widget.dart';

class DetailsScreen extends StatefulWidget {

  static const routeName = 'detailsScreen';

  @override
  _DetailsScreenState createState() => _DetailsScreenState();

}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {

    final FoodWastePost post =
      ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBarWidget(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Text(
            post.date,
            style: Theme.of(context).textTheme.headline6,
          ),

          Semantics(
            child: Image.network(
              post.imageURL,
              height: 300,
              fit: BoxFit.fitHeight,
            ),
            hint: 'Photo that was previously uploaded.',
            label: 'Photo that was previously uploaded.',
          ),

          Text(
            post.quantity.toString() + ' items',
            style: Theme.of(context).textTheme.headline4,
          ),

          Text(
            'Location: (' + post.latitude.toString() + ', ' +
              post.longitude.toString() + ')',
            style: Theme.of(context).textTheme.headline6,
          ),

        ],
      ),
    );
  }
}
