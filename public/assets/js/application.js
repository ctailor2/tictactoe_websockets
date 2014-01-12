var scheme = 'ws://';
var uri = scheme + window.document.location.host + "/";
var ws = new WebSocket(uri);

ws.onmessage = function(message) {
	var data = JSON.parse(message.data)
	console.log(data)
	var data_label = Object.keys(data)[0]
	switch (data_label) {
		case "status":
			$(".status").text(data.status);
			break;
		case "turn_message":
			var message = data.turn_message;
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
			break;
		case "display_message":
			var message = data.display_message;
			if (message === 'show') {
				$(".game-board").show().css('display', 'inline-block');
			}
			break;
		case "marker_message":
			var id = data.marker_message[0];
			var marker = data.marker_message[1];
			$("#" + id).text(marker);
			break;
		case "result_message":
			$(".turn-message").text("");
			var message = data.result_message;
			$(".result-message").text(message);
			break;
		case "game_message":
			$(".turn-message").text("");
			var message = data.game_message;
			$(".game-message").text(message);
			break;
	}
}

