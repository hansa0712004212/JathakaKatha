class Tale {
  final int id;
  final String title;
  final String story;
  final String image;
  final List<String> tags;
  final List<int> connectedStories;

  Tale({
    this.id,
    this.title,
    this.story,
    this.image,
    this.tags,
    this.connectedStories
  });
}