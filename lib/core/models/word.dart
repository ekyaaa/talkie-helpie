enum WordType { pronoun, urgent, response, emotion, activity, action, location }

class Word {
  final String id;
  final String word;
  final String imgPath;
  final WordType type;

  Word({
    required this.id,
    required this.word,
    required this.imgPath,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'word': word,
    'imgPath': imgPath,
    'type': type.name, // simpan enum sebagai string
  };

  factory Word.fromJson(Map<String, dynamic> json) => Word(
    id: json['id'],
    word: json['word'],
    imgPath: json['imgPath'],
    type: WordType.values.firstWhere(
          (e) => e.name == json['type'],
      orElse: () => WordType.pronoun, // default kalau JSON tidak punya type
    ),
  );
}
