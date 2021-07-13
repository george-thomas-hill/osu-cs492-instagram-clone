import 'package:flutter_test/flutter_test.dart';

import '../lib/models/food_waste_post.dart';

void main() {
  test('Post toString() method should generate correct string.', () {

    const imageURL = 'http://example.com';
    const quantity = 1;
    const latitude = 42.27;
    const longitude = -71.16;
    const date = 'Monday, August 10, 2020';

    const correctString = 'ImageURL: http://example.com.\nquantity: 1. Latitude: 42.27. Longitude: -71.16. Date: Monday, August 10, 2020.';

    final foodWastePost = FoodWastePost(
      imageURL,
      quantity,
      latitude,
      longitude,
      date,
    );

    expect(foodWastePost.toString(), correctString);

  });
}
