#!/bin/bash
#
# This script is used by travis to deploy generated files
#

# Config for this script:
export GH_USER="justinsoon"
export GH_EMAIL="justin.soon@verizon.net"
export GH_REPO="resume"

# Pull requests and commits to other branches shouldn't try to deploy
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "master" ]; then
  echo "Skipping deploy."
  exit 0
fi

# Save some useful information
export SHA=`git rev-parse --verify HEAD`

# Now let's go have some fun with the cloned repo
echo "git config"
git config --global user.name $GH_USER
git config --global user.email $GH_EMAIL
git clone "https://github.com/$GH_USER/$GH_REPO.git"
cd $GH_REPO
git checkout -b gh-pages origin/gh-pages
cp -f ../*.pdf ./ # copy and replace the compiled pdf files
git add *.pdf -f
echo "git commit"
git commit -m "Deploy $SHA"

# Now that we're all set up, we can push.
git push -f -q https://$GH_USER:$GH_TOKEN@github.com/$GH_USER/$GH_REPO.git gh-pages
