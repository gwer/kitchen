INDEX_FILE="./index.md"
POSTS_LIST_FILE="../posts_list.txt"
REPO_FOLDER="posts_repo"

cd "./new_data/$REPO_FOLDER"

echo '---' > $INDEX_FILE
echo 'layout: default' >> $INDEX_FILE
echo '---' >> $INDEX_FILE

while read post_path; do
  AUTHORS=$(cat "$post_path.authors")
  DATE=$(cat "$post_path.date")
  TITLE=$(cat "$post_path.title")
  POST_LINK="- ${DATE} :: [$TITLE]($post_path) <sup>${AUTHORS}</sup>"

  echo $POST_LINK >> $INDEX_FILE
done < <(sort $POSTS_LIST_FILE | awk '{print $2}')

echo '' >> $INDEX_FILE
echo '***' >> $INDEX_FILE
echo '' >> $INDEX_FILE

echo '[GitHub](https://github.com/gwer/kitchen) ::' >> $INDEX_FILE
echo '[Twitter](https://twitter.com/webholt) ::' >> $INDEX_FILE
echo '[Репозиторий с публикациями](https://github.com/razrabs-media/editorial) ::' >> $INDEX_FILE
echo '[Оригинальный сервис](https://razrabs.ru)' >> $INDEX_FILE
