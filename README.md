[![npm version](https://badge.fury.io/js/tcmerge.svg)](http://badge.fury.io/js/tcmerge)
# tcmerge
A command line tool making merge to master through [teamcity-merge](https://github.com/e-conomic/teamcity-merge)
script easier for the developer. Before using this you should set up [teamcity-merge](https://github.com/e-conomic/teamcity-merge)

### Installing
```
npm install -g tcmerge
```

### Usage
```
> tcmerge "My awesome feature is done, it solves all kinds of problems"
```

In order for this to work, you have to be in a git repo. The branch you are currently on has to be an open pull request
on github. And you have to have pushed your commits to the pull request branch on github.

`tcmerge`
- Will detect if you do not have a pull request for your branch. And give an error.
- Will detect if the pull request branch on github does not have the same commit as your current branch. And give an error

#### Merging pull request from forked repository
##### 1. Checkout and pull master on local repository
``` bash
$ git checkout master
$ git pull
```

##### 2. Checkout new branch on local repository
``` bash
$ git checkout -b merge-external-pull-request
```

##### 3. Cherry pick commits from pull request
Copy the commit id from the pull request in GitHub.

``` bash
$ git cherry-pick -x {commit id}
```

Repeat as necessary.

##### 4. Push branch
``` bash
$ git push --set-upstream origin merge-external-pull-request
```

##### 5. Create a new pull request
``` bash
$ hub pull-request -m "merge external pull request"
```

##### 6. Merge new pull request
``` bash
$ tcmerge "merge-external-pull-request Fixes #[EXTERNAL_PULL_REQUEST_NUMBER]"
```

That way the external PR will be closed when merge to master happens, and that merge commit will be linked to the external PR.

# `prod
This module also contains the command `prod`

Requires [HUB](https://hub.github.com/)

`brew install hub`

### Usage

You are on master branch with uncommitted changes you want to deploy to production

```
> prod "hotfix that is ready to go straight to production"
```

# `commit`
This module also contains the command `commit`

Requires [HUB](https://hub.github.com/)

`brew install hub`

### Usage

You are on master branch with uncommitted changes you want to turn into a pull request

```
> commit "code changes that are ready to be made into a pull request"
```

