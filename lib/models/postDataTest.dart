class TestDBPost {
  final DateTime date;
  final num quantity;
  final double latitude;
  final double longitude;
  final String imgurl;
  TestDBPost(
      this.date, this.quantity, this.latitude, this.longitude, this.imgurl);

  static fromMap(Set set) {}
}
