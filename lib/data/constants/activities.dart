class ActivityOption {
  final String label;
  final String category;

  const ActivityOption(this.label, this.category);
}

class Activities {
  static const String catHighSocial = 'High Energy / Social';
  static const String catHighPersonal = 'High Energy / Personal';
  static const String catLowSocial = 'Low Energy / Social';
  static const String catLowPersonal = 'Low Energy / Personal';

  static const List<String> highSocial = [
    'Charretting',
    'Presenting',
    'Surveying',
    'Critiquing',
    'Constructing',
    'Debating',
    'Exhibiting',
    'Networking',
    'Curating',
    'Workshoping',
    'Collaborating',
    'Defending',
    'Mapping',
    'Brainstorming',
    'Mentoring',
    'Directing',
    'Interviewing',
    'Negotiating',
  ];

  static const List<String> highPersonal = [
    'Drafting',
    'Rendering',
    'Modeling',
    'Sketching',
    'Detailing',
    'Scripting',
    'Plotting',
    'Redlining',
    'Researching',
    'Calculating',
    'Prototyping',
    'Writing',
    'Sectioning',
    'Photocollaging',
    'Concepting',
    'Portfolio-ing',
    'Specifying',
    'Analysing',
  ];

  static const List<String> lowSocial = [
    'Venting',
    'Snacking',
    'Pinning',
    'Roaming',
    'Jamming',
    'Gossiping',
    'Observing',
    'Thrifting',
    'Lunching',
    'Sharing',
    'Photowalking',
    'Visiting',
    'Commuting',
    'Browsing',
    'Meme-ing',
    'Coffee-ing',
    'Listening',
    'People-watching',
  ];

  static const List<String> lowPersonal = [
    'Waiting',
    'Sleeping',
    'Pinterest-ing',
    'Staring',
    'Listening',
    'Collecting',
    'Organizing',
    'Tracing',
    'Doodling',
    'Watching',
    'Sharpening',
    'Reflecting',
    'Walking',
    'Reading',
    'Sourcing',
    'Dreaming',
    'Meditating',
    'Journaling',
  ];
}
