class FoodWastePost {
  
  String imageURL;
  int quantity;
  double latitude;
  double longitude;
  String date;

  FoodWastePost(
    this.imageURL,
    this.quantity,
    this.latitude,
    this.longitude,
    this.date
  );

  String toString() =>
    'ImageURL: $imageURL.\nquantity: $quantity. Latitude: $latitude. Longitude: $longitude. Date: $date.';

}
