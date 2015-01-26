#!/usr/bin/env node
var execFile = require('child_process').execFile;
if (process.argv.length !== 3) {
	console.error('USAGE:\ntcmerge "commit message for merge commit"');
	process.exit(1);
}
var commitMessage = process.argv[2];
var timestamp = Math.round(Date.now()/1000) +'s';
var readyBranch = 'ready/' + commitMessage.replace(/\s/g, '_') + '/' + timestamp;

//http://stackoverflow.com/questions/12093748/how-do-i-check-for-valid-git-branch-names
var validBranchNameRegExp = /^(?!build-|\/|.*([\/.]\.|\/\/|@\{|\\))[^\040\177 ~^:?*[]+\/[^\040\177 ~^:?*[]+$/;
if (!validBranchNameRegExp.test(readyBranch)) {
	console.error('Error: There are chars in message that cannot be turned into a git branch');
	process.exit(1);
}

var path = require('path');
execFileWithOutput('sh', [path.join(__dirname, 'lookupPullRequest.sh')], function (err) {
	if (err) {
		process.exit(1);
	}
	return execFile('git', ['rev-parse', '--abbrev-ref', 'HEAD'], function (err, stdout, stderr) {
		if (err) {
			stderr && console.error(stderr);
			process.exit(1);
		}
		var currentBranch = stdout.replace(/\s/g, '');
		if(!currentBranch){
			console.error('Can\'t find current branch');
			process.exit(1);
		}
		var gitArguments = ['push', 'origin', currentBranch + ':' + readyBranch];
		console.log('git ' + gitArguments.join(' '));
		return execFileWithOutput('git', gitArguments, function(err){
			if (err) {
				process.exit(1);
			}
			process.exit(0);
		});
	});
});

function execFileWithOutput() {
	var child = execFile.apply(null, arguments);
	child.stdout.pipe(process.stdout);
	child.stderr.pipe(process.stderr);
}