REPO_FOLDER="posts_repo"

rm -rf pages
mkdir pages
cp -r .git pages
cd pages
git checkout pages && git pull origin pages
cd ..

./make_pages.sh

rm -rf pages/docs
mv "new_data/$REPO_FOLDER" pages/docs
rm -rf new_data
cp -r extra/* pages/docs

./commit_pages.sh
