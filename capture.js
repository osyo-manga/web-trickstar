

var url    = phantom.args[0];
// var url    = phantom.args[0].split(/#/)[0];
// var anchor = phantom.args[0].split(/#/)[1];
var output = phantom.args[1];
var width   = phantom.args[2] || 10;
var height  = phantom.args[3] || 10;


var page = require('webpage').create();


page.viewportSize = { width: width, height: height };
page.open(url, function (status) {
	if (status !== 'success') {
		phantom.exit(1);
	}

	page.render(output);
	console.log(output)
	phantom.exit();
});

