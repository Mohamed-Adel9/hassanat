String getFirstWord(String text) {
  List<String> parts = text.split(" ");
  return parts.first.toLowerCase();
}