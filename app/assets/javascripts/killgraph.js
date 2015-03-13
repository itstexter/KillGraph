xScaling = (512 / (14870 - 120));
yScaling = (512/ (14980 - 120));

$(document).ready(function() {
	attachMatchHistoryClickHandlers();
	showAllPlotPoints();
});

var plotKillsFromMatchHistory = function(matchId) {
	var $coordinates;
	if (typeof(matchId) === 'undefined') {
		$coordinates = $(".coordinate");
	} else {
		$coordinates = $(".matchCoordinatesContainer" + matchId).find(".coordinate");
	}

	for (var i = 0; i < $coordinates.length; i++) {
		var $coordinate = $($coordinates[i]);
		var x = $coordinate.data("x");
		var y = $coordinate.data("y");
		$coordinate.css("left", x * xScaling);
		$coordinate.css("bottom", y * yScaling);
		$coordinate.show();
	}
};

var attachMatchHistoryClickHandlers = function() {
	$(".matchBox").hover(showMatchPlotPoints, showAllPlotPoints);
};

var showMatchPlotPoints = function(event) {
	// hide all other match points
	$(".coordinate").hide();

	console.log($(event.target));
	var matchId = $(event.target).closest(".matchBox").data("match");
  console.log("moused into " + matchId);
  plotKillsFromMatchHistory(matchId);
};

var showAllPlotPoints = function() {
	console.log("showing all plot points");
	$(".coordinate").hide();
	// plotKillsFromMatchHistory();
};

// var addMatches = function(json) {

// 	// Set up tooltips
// 	$tiphover = $(".tiphoverContainer");
// 	$tiphoverText = $tiphover.find(".tiphover");

// 	var html = json["matches_history"];
// 	$(".match_history").append(html);
// 	$(".match_history").append(html);
// 	$(".match_history").append(html);
// 	$(".match_history").append(html);

// 	$(".tip").mouseover(function(event) {
// 		var $target = $(event.target);
// 		// Todo: fix when .tip div has a child that isn't tip and becomes the target
// 		if (!$target.hasClass("tip")) {
// 			$target = $target.parents(".tip");
// 		}
// 		$tiphoverText.html($target.data("tip-text"));

// 		var yoffset;
// 		if (($target.position().top - $(window).scrollTop()) < ($(window).height() / 2)) {
// 			$(".topCaret").show();
// 			$(".bottomCaret").hide();
// 			yoffset = $target.height() - parseInt($(".bottomCaret").css("border-bottom-width"));
// 		} else {
// 			$(".topCaret").hide();
// 			$(".bottomCaret").show();
// 			yoffset = -$tiphover.height() + parseInt($(".topCaret").css("border-top-width"));
// 		}

// 		$tiphover.show();
// 		$tiphover.css("top", $target.position().top + yoffset);
// 		$tiphover.css("left", $target.position().left - ($tiphover.outerWidth() / 2) + ($target.outerWidth(true) / 2));
// 	});

// 	$(".tip").mouseout(function(event) {
// 		$tiphover.hide();
// 	});
// };
