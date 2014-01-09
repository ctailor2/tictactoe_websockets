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
		var message = data.turn_message
		$(".turn-message").text(message);
		var clickHandler = function() {
			var id = parseInt(this.id);
			ws.send(JSON.stringify({ 'marker_message' : id }));
		}
		if (message === "Your Turn") {
			$(".space").bind("click.myEvent", clickHandler);
		}
		else {
			$(".space").unbind("click.myEvent");
		}
	}
	else if (data.hasOwnProperty('display_message')) {
		var message = data.display_message
		if (message === 'show') {
			$(".game-board").show('slow').css('display', 'inline-block');
		}
	}
	else if (data.hasOwnProperty('marker_message')) {
		var id = data.marker_message
		$("#" + id).text("X");
	}
}

