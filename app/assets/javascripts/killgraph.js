xScaling = (512 / (14870 - 120));
yScaling = (512/ (14980 - 120));

$(document).ready(function() {
	var username = $(".username").data("username");
	console.log("username is" + username);
	$.ajax({
		url: "/killgraph/get_coordinates",
		type: "GET",
		data: {
			username: username
		},
		dataType: "json",
		success: plotKills
	});

});

var plotKills = function(json) {
	var championKills = json["champion_kills"];

	console.log(championKills);

	for (var i = 0; i < championKills.length; i++) {
		var position = championKills[i]["position"];
		plotPoint(position["x"], position["y"]);
	}
};

var plotPoint = function(x, y) {
	console.log("x: " + x + " y: " + y);
	var $newPlotPoint = $("<div />").addClass("kill");
	$newPlotPoint.css("left", x * xScaling);
	$newPlotPoint.css("bottom", y * yScaling);

	$(".map").append($newPlotPoint);
}