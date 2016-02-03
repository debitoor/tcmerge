#!/usr/bin/env bash
branch_name=${1// /-}
git checkout -b "${branch_name}" || return $?
git commit -am "${branch_name}" || echo "ignoring commit problem"
git push --set-upstream origin "${branch_name}" || return $?
hub pull-request -m "${branch_name}" || return $?
tcmerge "${branch_name}" || return $?
