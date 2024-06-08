class PlaceDetail {
  String icon;
  String id;
  String name;
  String rating;
  String vicinity;

  String? formatted_address;
  String? international_phone_number;
  List<String>? weekday_text;
  String? url;

  PlaceDetail(
    this.id,
    this.name,
    this.icon,
    this.rating,
    this.vicinity,result, param6, List<String> weekdays, {
    this.formatted_address = '',
    this.international_phone_number = '',
    this.weekday_text = const [],
    this.url = '',
  });
}
