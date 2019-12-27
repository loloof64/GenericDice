import "dart:collection";

class UserDicesConfiguration {
  Map<String, List<String>> dices = SplayTreeMap();

  UserDicesConfiguration();

  UserDicesConfiguration.fromJson(Map<String, dynamic> json) {
    dices = SplayTreeMap();
    for (var diceEntry in json.entries) {
      final valuesArray = List<String>.from(diceEntry.value);
      dices[diceEntry.key] = valuesArray;
    }
  }

  Map<String, dynamic> toJson() => dices;
}
