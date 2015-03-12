xScaling = (512 / (14870 - 120));
yScaling = (512/ (14980 - 120));

$(document).ready(function() {
	var username = $(".username").data("username");

	if (typeof(username) === 'undefined') {
		return
	}

	plotKills()

	return

	$tiphover = $(".tiphoverContainer");
	$tiphoverText = $tiphover.find(".tiphover");
	console.log("username is" + username);
	$.ajax({
		url: "/killgraph/get_user",
		type: "GET",
		data: {
			username: username
		},
		dataType: "json",
		success: handleUser
	});

	buildMatchHistory();
});

var handleUser = function(json) {
	// if (summoner_name == null) {
	// 	handleUnregistered
	// } else {
		$.ajax({
			url: "/killgraph/get_match_history",
			type: "GET",
			data: {
				username: username
			},
			dataType: "json",
			success: handleMatches
		});
	// }
}

var handleMatches = function(){
	plotKills()
	buildMatchHistory()
}

var plotKills = function(json) {
	var championKills = json["champion_kills"];

	console.log(championKills);

	// for (var i = 0; i < championKills.length; i++) {
	// 	var position = championKills[i]["position"];
	// 	plotPoint(position["x"], position["y"]);
	// }
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
	$(".match_history").append(html);
	$(".match_history").append(html);
	$(".match_history").append(html);
 
	$(".tip").mouseover(function(event) {
		var $target = $(event.target);
		// Todo: fix when .tip div has a child that isn't tip and becomes the target
		if (!$target.hasClass("tip")) {
			$target = $target.parents(".tip");
		}
		$tiphoverText.html($target.data("tip-text"));

		var yoffset;
		if (($target.position().top - $(window).scrollTop()) < ($(window).height() / 2)) {
			$(".topCaret").show();
			$(".bottomCaret").hide();
			yoffset = $target.height() - parseInt($(".bottomCaret").css("border-bottom-width"));
		} else {
			$(".topCaret").hide();
			$(".bottomCaret").show();
			yoffset = -$tiphover.height() + parseInt($(".topCaret").css("border-top-width"));
		}

		$tiphover.show();
		$tiphover.css("top", $target.position().top + yoffset);
		$tiphover.css("left", $target.position().left - ($tiphover.outerWidth() / 2) + ($target.outerWidth(true) / 2));
	});

	$(".tip").mouseout(function(event) {
		$tiphover.hide();
	});
};

var plotPoint = function(x, y) {
	var $newPlotPoint = $("<div />").addClass("kill");
	$newPlotPoint.css("left", x * xScaling);
	$newPlotPoint.css("bottom", y * yScaling);

	$(".map").append($newPlotPoint);
}