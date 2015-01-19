#!/bin/sh
################################################
# Make sure git fetches (hidden) Pull Requests
# by adding:
# fetch = +refs/pull/*/head:refs/remotes/origin/pullrequest/*
# to .git/config under the origin remote
################################################

#echo "\nAdding fetch of pull requests to .git/config"

CURRENT_FETCH=`grep '	fetch =.\+refs/pull/\*/head:refs/remotes/origin/pullrequest/\*' .git/config`
if [ "$CURRENT_FETCH" = '' ]
then
	# Avoid -i flag for sed, because of platform differences
	sed 's/\[remote \"origin\"\]/[remote "origin"]\
	fetch = +refs\/pull\/*\/head:refs\/remotes\/origin\/pullrequest\/*/g' .git/config >.git/config_with_pull_request
	cp .git/config .git/config.backuo
	mv .git/config_with_pull_request .git/config
	echo 'Added fetch of pull request to .git/config:'
	#cat .git/config
#else
#	echo 'Fetch of pull request already in place in .git/config'
fi
git fetch --quiet

########################################################################################
# Lookup PR number
# By looking the SHA checksum of the current branchs latests commit
# And finding a pull request that has a matching SHA checksum as the lastest commit
# This enforces a restriction that you can only merge branches that match a pull request
# And using the number of the pull request later, we can close the pull request
# by making the squash merge commit message include "fixes #[pull request number] ..."
########################################################################################

#echo "\nFinding pull request that matches branch we want to merge (current branch)"

CURRENT_SHA=`git log -1 --format="%H"`
#echo "Current SHA:"
#echo "${CURRENT_SHA}"

error='\nAre you on the right brach?\nAre you trying to deploy a branch that is not a pull request?\nOr did you forget to push your changes to github?'

MATCHING_PULL_REQUEST=`git show-ref | grep $CURRENT_SHA | grep 'refs/remotes/origin/pullrequest/'`
if [ "$MATCHING_PULL_REQUEST" = '' ] ; then
  echo "ERROR finding matching pull request: ${error}" >&2; exit 1
fi
#echo "Matching pull request:"
#echo "${MATCHING_PULL_REQUEST}"

PR_NUMBER=`echo "${MATCHING_PULL_REQUEST}" | sed 's/[0-9a-z]* refs\/remotes\/origin\/pullrequest\///g' | sed 's/\s//g'`
case ${PR_NUMBER} in
    ''|*[!0-9]*) echo "ERROR pull request number does not match number regExp (weird!): ${error}" >&2; exit 1 ;;
esac
echo "Matched pull request number: ${PR_NUMBER}"
