// $ phantomjs capture.js {url} {output} {width} {height} {top} {left} {bottom} {right}

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

	page.includeJs('http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js', function() {
		var top  = phantom.args[4] || 0;
		var left = phantom.args[5] || 0;

		var height = phantom.args[6] || 0;
		if( height == '0' ){
			height = page.evaluate(function() {
				return $(document).height();
			});
		}
		height = height - top;

		var width = phantom.args[7] || 0;
		if( width == '0' ){
			width = page.evaluate(function() {
				return $(document).width();
			});
		}
		width = width - left;

		page.clipRect = { top: top, left: left, width: width, height: height };
		page.render(output);
		console.log(output);
		phantom.exit();
	});

});

