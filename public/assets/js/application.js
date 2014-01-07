var scheme = 'ws://';
var uri = scheme + window.document.location.host + "/";
var ws = new WebSocket(uri);

ws.onmessage = function(message) {
	var data = JSON.parse(message.data)
	console.log(data)
	if (data.hasOwnProperty('status')){
		$(".status").text(data.status);
	}
	else if (data.hasOwnProperty('turn_message')) {
		$(".turn-message").text(data.turn_message);
	}
}

$(document).click(function(event) {
	ws.send(JSON.stringify({handle: 'ctailor2', text: 'waddup homie?!'}))
});