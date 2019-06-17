

class PieData {
  final String typeID;
  final int amount;
  final String name;
  final int score;

  PieData({this.typeID, this.amount, this.name, this.score});

  factory PieData.fromJson(Map<String, dynamic> json) {
    return new PieData(
      typeID: json['typeID'],
      amount: json['amount'],
      name: json['name'],
      score: json['score']
    );
  }

}