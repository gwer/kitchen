DATE=$(date +"%F %T")

cd pages
git checkout pages
git add .
git commit -m "Update pages $DATE"
git push origin HEAD
