# Import standard verbs
verbs = [
  ['POST', "http://activitystrea.ms/schema/1.0/post"],
  ['FAVORITE', "http://activitystrea.ms/schema/1.0/favorite"],
  ['FOLLOW', 'http://activitystrea.ms/schema/1.0/follow'],
  ['LIKE', 'http://activitystrea.ms/schema/1.0/like'],
  ['MAKE-FRIEND', 'http://activitystrea.ms/schema/1.0/make-friend'],
  ['JOIN', 'http://activitystrea.ms/schema/1.0/join'],
  ['PLAY', 'http://activitystrea.ms/schema/1.0/play'],
  ['SAVE', 'http://activitystrea.ms/schema/1.0/save'],
  ['SHARE', 'http://activitystrea.ms/schema/1.0/share'],
  ['TAG', 'http://activitystrea.ms/schema/1.0/tag'],
  ['UPDATE', 'http://activitystrea.ms/schema/1.0/update']
]

verbs.each do |verb|
  Verb.find_or_create_by_name verb[0], :url_id => verb[1], :is_public => true
end

# Import standard object_types
object_types = [
  ['ARTICLE', 'http://activitystrea.ms/schema/1.0/article'],
  ['AUDIO', 'http://activitystrea.ms/schema/1.0/audio'],
  ['BOOKMARK', 'http://activitystrea.ms/schema/1.0/bookmark'],
  ['COMMENT', 'http://activitystrea.ms/schema/1.0/comment'],
  ['FILE', 'http://activitystrea.ms/schema/1.0/file'],
  ['FOLDER', 'http://activitystrea.ms/schema/1.0/folder'],
  ['GROUP', 'http://activitystrea.ms/schema/1.0/group'],
  ['LIST', 'http://activitystrea.ms/schema/1.0/list'],
  ['NOTE', 'http://activitystrea.ms/schema/1.0/note'],
  ['PERSON', 'http://activitystrea.ms/schema/1.0/person'],
  ['PHOTO', "http://activitystrea.ms/schema/1.0/photo"],
  ['PHOTO ALBUM', 'http://activitystrea.ms/schema/1.0/photo-album'],
  ['PLACE', 'http://activitystrea.ms/schema/1.0/place'],
  ['PLAYLIST', 'http://activitystrea.ms/schema/1.0/playlist'],
  ['PRODUCT', 'http://activitystrea.ms/schema/1.0/product'],
  ['REVIEW', 'http://activitystrea.ms/schema/1.0/review'],
  ['SERVICE', 'http://activitystrea.ms/schema/1.0/service'],
  ['STATUS', 'http://activitystrea.ms/schema/1.0/status'],
  ['VIDEO', 'http://activitystrea.ms/schema/1.0/video']
]

object_types.each do |ot|
  ObjectType.find_or_create_by_name ot[0], :url_id => ot[1], :is_public => true
end