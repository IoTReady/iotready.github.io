#! /bin/bash
# Build site into _site folder
bundle exec jekyll build
git add .
# This will prompt for a commit message
git commit
# Push master
git push
# Now push _site to gh-pages
git subtree push --prefix _site origin gh-pages