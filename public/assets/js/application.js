var scheme = 'ws://';
var uri = scheme + window.document.location.host + "/";
var ws = new WebSocket(uri);

ws.onmessage = function(message) {
	var data = JSON.parse(message.data)
	console.log(data)
}

$(document).click(function(event) {
	ws.send(JSON.stringify({handle: 'ctailor2', text: 'waddup homie?!'}))
});