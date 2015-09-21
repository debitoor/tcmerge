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

# Prod
Also this module contais command `prod`

Requires [HUB](https://hub.github.com/)

`brew install hub`

### Usage 

```
> prod "hotfix-that-is-ready-go-prod"
```

notice that prod accepts only valid branch name that will be used as branch name, commit and PR
