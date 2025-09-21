String truncateWord(String word, int maxLength) {
  if (word.length <= maxLength) return word;
  return '${word.substring(0, maxLength)}...';
}