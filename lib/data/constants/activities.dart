class ActivityOption {
  final String label;
  final String category;

  const ActivityOption(this.label, this.category);
}

class Activities {
  static const String catHighSocial = 'high effort\nsocial';
  static const String catHighPersonal = 'high effort\npersonal';
  static const String catLowSocial = 'low effort\nsocial';
  static const String catLowPersonal = 'low effort\npersonal';

  static const List<String> highSocial = [
    'Jury',
    'Campaigning',
    'NASA',
    'Dancing',
    'Debating',
    'Case Study',
    'Model Making',
    'Event Prep',
    'Surveying',
    'Teaching',
    'Site Visit',
    'Sheet Signing',
    'Organizing',
    'Exploring',
    'Drama',
  ];

  static const List<String> highPersonal = [
    'Drafting',
    'Rendering',
    'Cutting',
    'Thesis',
    'Redoing',
    'Studying',
    'Portfolio',
    'Sketching',
    'Researching',
    'Printing',
    'Concepting',
    'Deadline',
    'Writing',
    'Submission',
    'Cramming',
  ];

  static const List<String> lowSocial = [
    'Chai Break',
    'Gossiping',
    'Vibing',
    'Scrolling',
    'Snacking',
    'Ranting',
    'Ludo',
    'Music',
    'Strolling',
    'Judging',
    'Napping',
    'Memes',
    'Movie',
    'Selfies',
    'Chatting',
  ];

  static const List<String> lowPersonal = [
    'Sleeping',
    'Scrolling',
    'Playlist',
    'Doodle',
    'Zoning Out',
    'Series',
    'Snack',
    'Bus Ride',
    'Vibe',
    'Coffee',
    'Observe',
    'Nap',
    'Clean',
    'YouTube',
    'Reflect',
  ];
}
