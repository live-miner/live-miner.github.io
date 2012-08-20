$(document).ready (function () {
	$("a.directory").next ("ul").toggle ();
	$("li.latest li.interesting").parentsUntil ("li.latest", "ul").toggle ();

	$("a.directory").click (function (event) {
		$(this).next ("ul").toggle ('fast', 'swing');
	});
});
