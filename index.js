$(document).ready (function () {
	$("a.directory").next ("ul").toggle ();
	$("li.latest li.interesting").parentsUntil ("li.latest", "ul").toggle ();

	$("a.directory").click (function (event) {
		$(this).next ("ul").toggle ('fast', 'swing');
	});

	function cmp (a, b) {
		an = $(a).children ("a")[0].textContent;
		bn = $(b).children ("a")[0].textContent;
		return parseInt (bn) - parseInt (an);
	}
	$("ul#downloads > li").sortElements (cmp);
});