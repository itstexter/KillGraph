xScaling = (512 / (14870 - 120));
yScaling = (512/ (14980 - 120));

$(document).ready(function() {
	attachMatchHistoryClickHandlers();
	hideAllPlotPoints();
	attachTooltipClickHandlers();
});

var plotKillsFromMatchHistory = function(matchId) {
	var $coordinates = $(".matchCoordinatesContainer" + matchId).find(".coordinate");

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
	$(".matchBox").hover(showMatchPlotPoints, hideAllPlotPoints);
};

var showMatchPlotPoints = function(event) {
	hideAllPlotPoints();

	var matchId = $(event.target).closest(".matchBox").data("match");
  plotKillsFromMatchHistory(matchId);
};

var hideAllPlotPoints = function() {
	$(".coordinate").hide();
};

var attachTooltipClickHandlers = function() {
	$tiphover = $(".tiphoverContainer");
	$tiphoverText = $tiphover.find(".tiphover");
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
