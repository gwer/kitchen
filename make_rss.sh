RSS_FILE="./feed.rss"
POSTS_LIST_FILE="../posts_list.txt"
REPO_FOLDER="posts_repo"
SITE="https://gwer.github.io/kitchen/"

cd "./new_data/$REPO_FOLDER"

echo '<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">' > $RSS_FILE
echo "<channel>" >> $RSS_FILE
echo "  <title>Gwer's Kitchen</title>" >> $RSS_FILE
echo "  <description>Хорошо живу, купаюсь в бассейне, пью джюс</description>" >> $RSS_FILE
echo "  <link>$SITE</link>" >> $RSS_FILE

while read post_path; do
  AUTHORS=$(cat "$post_path.authors")
  DATE=$(cat "$post_path.date")
  TITLE=$(cat "$post_path.title")
  RELATIVE_PATH=$(echo "${post_path:2}" | sed 's/\.md$/.html/')
  URL="${SITE}${RELATIVE_PATH}"


  echo "  <item>" >> $RSS_FILE
  echo "    <title>$TITLE</title>" >> $RSS_FILE
  echo "    <link>$URL</link>" >> $RSS_FILE
  echo "    <dc:creator>$AUTHORS</dc:creator>" >> $RSS_FILE
  echo "    <dc:date>$DATE</dc:date>" >> $RSS_FILE
  echo "  </item>" >> $RSS_FILE
done < <(sort -r $POSTS_LIST_FILE | awk '{print $2}')

echo "</channel>" >> $RSS_FILE
echo "</rss>" >> $RSS_FILE
