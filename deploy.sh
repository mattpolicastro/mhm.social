#!/usr/bin/env sh
###
# Pulled from the Deployment guide from vue-cli https://cli.vuejs.org/guide/deployment.html#general-guidelines
###

# abort on errors
set -e

# build
yarn build

# navigate into the build output directory
cd dist

# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME

git init
git add -A
git commit -m 'deploy'

# if you are deploying to https://<USERNAME>.github.io
# git push -f git@github.com:<USERNAME>/<USERNAME>.github.io.git master

# if you are deploying to https://<USERNAME>.github.io/<REPO>
git push -f git@github.com:mattpolicastro/mhm.social.git master:gh-pages

cd -