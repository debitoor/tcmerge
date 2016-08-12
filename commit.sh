#!/usr/bin/env bash

myCommit(){
	git add . -A
	git commit -m "${branch_name}" || echo "ignoring commit problem"
	if [ "$2" = 'do-pull-request' ]
	then
	    git push --set-upstream origin "${branch_name}" || exit $?
		hub pull-request -m "$1" || exit $?
	else
		git push || exit $?
	fi
}

current_branch=`git rev-parse --abbrev-ref HEAD`
branch_name=${1// /_}
if [ "$current_branch" = 'master' ]
then
	git checkout -b "${branch_name}" || exit $?
	myCommit "$1" "do-pull-request"
else
	if [ "$current_branch" = "$branch_name" ]
	then
		echo "Already on the branch ${branch_name}"
		myCommit "$1"
	else
		echo "Not on master branch and not on branch ${branch_name}, exiting with no action"
	fi
fi


