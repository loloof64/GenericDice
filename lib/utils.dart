String replaceVariables(String message, Map<String, String> variables) {
  for (var entry in variables.entries) {
    final currKey = entry.key;
    final currVal = entry.value;
    message = message.replaceAll("[$currKey]", currVal);
  }
  return message;
}