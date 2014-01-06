var scheme = 'ws://';
var uri = scheme + window.document.location.host + "/";
var ws = new WebSocket(uri);

ws.onmessage = function(message) {
	var data = JSON.parse(message.data)
	console.log(data)
	if (data.num_clients < 2){
		$(".status").text("Waiting for Challenger");
	} else if (data.turn_message) {
		$(".turn-message").text(data.turn_message);
	}
}

$(document).click(function(event) {
	ws.send(JSON.stringify({handle: 'ctailor2', text: 'waddup homie?!'}))
});