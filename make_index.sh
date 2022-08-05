INDEX_FILE="./index.md"
POSTS_LIST_FILE="../posts_list.txt"
REPO_FOLDER="posts_repo"

cd "./new_data/$REPO_FOLDER"
rm $INDEX_FILE

while read post_path; do
  AUTHORS=$(cat "$post_path.authors")
  RELATIVE_DATE=$(cat "$post_path.relative_date")
  TITLE=$(cat "$post_path.title")
  POST_LINK="- [$TITLE]($post_path) <sup>${AUTHORS} :: ${RELATIVE_DATE}</sup>"

  echo $POST_LINK >> $INDEX_FILE
done < $POSTS_LIST_FILE

echo '' >> $INDEX_FILE
echo '***' >> $INDEX_FILE
echo '' >> $INDEX_FILE

echo '[GitHub](https://github.com/gwer/kitchen) ::' >> $INDEX_FILE
echo '[Twitter](https://twitter.com/webholt) ::' >> $INDEX_FILE
echo '[Репозиторий с публикациями](https://github.com/razrabs-media/editorial) ::' >> $INDEX_FILE
echo '[Оригинальный сервис](https://razrabs.ru)' >> $INDEX_FILE
