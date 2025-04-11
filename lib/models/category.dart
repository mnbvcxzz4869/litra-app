// Category
class Category{
  const Category({
    required this.id,
    required this.title,
  });
    
    final String id;
    final String title;
}
const categories = [
  Category(id: 'c1', title: 'Horror'),
  Category(id: 'c2', title: 'Fantasy'),
  Category(id: 'c3', title: 'Adventure'),
  Category(id: 'c4', title: 'Romance'),
  Category(id: 'c5', title: 'Drama'),
];