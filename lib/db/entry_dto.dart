class EntryDTO {

  String imageURL;
  int quantity;
  double latitude;
  double longitude;
  DateTime dateTime;

  String toString() =>
    'ImageURL: $imageURL.\nquantity: $quantity. Latitude: $latitude. Longitude: $longitude. Date: $dateTime.';

}
