xScaling = (512 / (14870 - 120));
yScaling = (512/ (14980 - 120));

$(document).ready(function() {
	var username = $(".username").data("username");
	$tiphover = $(".tiphover");
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

	buildMatchHistory();
};

var buildMatchHistory = function() {
	var username = $(".username").data("username");
	$.ajax({
		url: "/killgraph/get_match_history",
		type: "GET",
		data: {
			username: username
		},
		dataType: "json",
		success: addMatches
	});
};

var addMatches = function(json) {
	console.log("will start adding matches");
	console.log(json);

	var html = json["matches_history"];
	$(".match_history").append(html);

	// 
	$(".tip").mouseover(function(event) {
		console.log("hoverin");
		var $target = $(event.target);
		
		$tiphover.show();
		$tiphover.css("bottom", $target.position().top);
		$tiphover.css("left", $target.position().left);
		$tiphover.text($target.data("tip-text"));
	});

	$(".tip").mouseout(function() {
		$tiphover.hide();
	});
};

var plotPoint = function(x, y) {
	console.log("x: " + x + " y: " + y);
	var $newPlotPoint = $("<div />").addClass("kill");
	$newPlotPoint.css("left", x * xScaling);
	$newPlotPoint.css("bottom", y * yScaling);

	$(".map").append($newPlotPoint);
}