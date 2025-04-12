import 'dart:convert';

// Book model
class Chapter {
  final String chapterId;
  final int chapterNum;
  final String chapterTitle;
  final List<String> chapterContent;
  final String audioFile;
  final DateTime? dateAccess;
  bool isReadRewardClaimed;
  bool isListenRewardClaimed;

  Chapter({
    required this.chapterId,
    required this.chapterNum,
    required this.chapterTitle,
    required this.chapterContent,
    required this.audioFile,
    this.dateAccess,
    this.isReadRewardClaimed = false,
    this.isListenRewardClaimed = false,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterId: json['chapterId'],
      chapterNum: json['chapterNum'],
      chapterTitle: json['chapterTitle'],
      chapterContent: List<String>.from(json['chapterContent']),
      audioFile: json['audioFile'],
      dateAccess: json['dateAccess'] != null
          ? DateTime.parse(json['dateAccess'])
          : null,
      isReadRewardClaimed: json['isReadRewardClaimed'] ?? false,
      isListenRewardClaimed: json['isListenRewardClaimed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterId': chapterId,
      'chapterNum': chapterNum,
      'chapterTitle': chapterTitle,
      'chapterContent': chapterContent,
      'audioFile': audioFile,
      'dateAccess': dateAccess?.toIso8601String(),
      'isReadRewardClaimed': isReadRewardClaimed,
      'isListenRewardClaimed': isListenRewardClaimed,
    };
  }
}

class Book {
  final String bookId;
  final String title;
  final String cover;
  final double rating;
  final int totalRead;
  final List<String> category;
  final String author;
  final int year;
  final String synopsis;
  final int totalChapter;
  int chapterProgress;
  final List<Chapter> chapters;

  Book({
    required this.bookId,
    required this.title,
    required this.cover,
    required this.rating,
    required this.totalRead,
    required this.category,
    required this.author,
    required this.year,
    required this.synopsis,
    required this.totalChapter,
    this.chapterProgress = 0,
    required this.chapters,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['bookId'],
      title: json['title'],
      cover: json['cover'],
      rating: json['rating'].toDouble(),
      totalRead: json['totalRead'],
      category: List<String>.from(json['category']),
      author: json['author'],
      year: json['year'],
      synopsis: json['synopsis'],
      totalChapter: json['totalChapter'],
      chapterProgress: json['chapterProgress'] ?? 0,
      chapters: (json['chapters'] as List)
          .map((chapterJson) => Chapter.fromJson(chapterJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'title': title,
      'cover': cover,
      'rating': rating,
      'totalRead': totalRead,
      'category': category,
      'author': author,
      'year': year,
      'synopsis': synopsis,
      'totalChapter': totalChapter,
      'chapterProgress': chapterProgress,
      'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
    };
  }
}
