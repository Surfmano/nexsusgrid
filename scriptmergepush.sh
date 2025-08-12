#!/usr/bin/env bash
set -e

git fetch --all
git checkout main
git pull origin main

for br in $(git branch -r | grep -v 'origin/HEAD' | grep -v 'origin/main'); do
  git merge --no-edit "$br"
done

git push origin main