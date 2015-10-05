if(/MSIE 10|rv:11.0/i.test(navigator.userAgent)) {
	document.documentElement.className="ie";
} else if (/AppleWebKit/i.test(navigator.userAgent)) {
	if(Number(navigator.userAgent.match(/AppleWebKit\/([^\s]*)/i)[1]) < 537.1) {
		document.documentElement.className="oldWebKit";
	}
}