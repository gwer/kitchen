rm -rf new_data
mkdir new_data
cd new_data

git clone https://github.com/razrabs-media/editorial.git
# Больше 100 открытых PR'ов не отработают корректно.
curl -o prs.json  https://api.github.com/repos/razrabs-media/editorial/pulls?per_page=100
grep 'patch_url' prs.json | sed "s/^.*\": \"//" | sed "s/\",$//" > ./patches_list.txt

mkdir patches
cd patches

# Скачивание всех патчей
xargs -n 1 curl -L -O < ../patches_list.txt

cd ../editorial

# Применяем патчи, конфликтные скипаем.
git am -q ../patches/*.patch
while git am --skip
do
  :
done

# Удаляем ридми
find ./ -maxdepth 1 -type f -exec rm {} \;

# Вариант, где названия файлов не имеют значения.
for folder_name in *; do
  if ! [ -d "./$folder_name" ]; then
    # rm "./$folder_name"
    continue
  fi

  if ! [ -f ./$folder_name/*.md ]; then
    # rm -r "./$folder_name"
    continue
  fi

  for post_path in ./$folder_name/*.md; do
    RAW_TITLE=$(head -n 1 "$post_path")

    if [[ ${RAW_TITLE::2} == "# " ]]; then
      TITLE=$(echo $RAW_TITLE | sed "s/^# //")
    else
      # rm $post_path
      continue
    fi

    echo $TITLE > "$post_path.title"

    AUTORS=$(git log --pretty=format:"%an%x09" "$post_path" | sort | uniq | tr -d '\t' | tr '\n' ',' | sed 's/,/, /g' | rev | cut -c3- | rev)
    echo $AUTORS > "$post_path.authors"

    SHORT_DATE=$(git log --follow --format=%ad --date short "$post_path" | tail -1)
    echo $SHORT_DATE > "$post_path.short_date"

    RELATIVE_DATE=$(git log --follow --format=%ad --date relative "$post_path" | tail -1)
    echo $RELATIVE_DATE > "$post_path.relative_date"

    HEADER="_${AUTORS} ${RELATIVE_DATE}_"

    echo $HEADER > "$post_path.new"
    echo '' >> "$post_path.new"
    cat $post_path >> "$post_path.new"
    rm $post_path
    mv "$post_path.new" $post_path

    echo $post_path >> ../posts_list.txt
  done
done

rm -rf .git
cd ../..

./make_index.sh

rm -rf docs
mv new_data/editorial docs
rm -rf new_data
cp _config.yml docs
