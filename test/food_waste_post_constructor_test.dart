import 'package:flutter_test/flutter_test.dart';

import '../lib/models/food_waste_post.dart';

void main() {
  test('Post created via constructor should have appropriate values.', () {

    const imageURL = 'http://example.com';
    const quantity = 1;
    const latitude = 42.27;
    const longitude = -71.16;
    const date = 'Monday, August 10, 2020';

    final foodWastePost = FoodWastePost(
      imageURL,
      quantity,
      latitude,
      longitude,
      date,
    );

    expect(foodWastePost.imageURL, imageURL);
    expect(foodWastePost.quantity, quantity);
    expect(foodWastePost.latitude, latitude);
    expect(foodWastePost.longitude, longitude);
    expect(foodWastePost.date, date);

  });
}
