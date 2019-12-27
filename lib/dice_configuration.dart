import "dart:collection";

class SingleDiceConfiguration {
  List<String> values = [];
}

class UserDicesConfiguration {
  SplayTreeMap<String, SingleDiceConfiguration> dices = SplayTreeMap();
}
