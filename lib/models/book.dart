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
}
