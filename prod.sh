#!/usr/bin/env bash
branch_name=${1// /_}
git checkout -b "${branch_name}" || exit $?
git add . -A
git commit -m "${branch_name}" || echo "ignoring commit problem"
git push --set-upstream origin "${branch_name}" || exit $?
hub pull-request -m "$1" || exit $?
tcmerge "${branch_name}" || exit $?
