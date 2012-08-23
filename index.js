$(document).ready (function () {
	$("a.directory").each (function () {
		$(this).nextAll ("ul.directory").eq (0).toggle ();
	});
	$("li.latest li.interesting").parentsUntil ("li.latest", "ul").toggle ();
	// once the previous animations are complete, fix the indicators
	$("ul.directory").promise ().done (function () {
		$(this).prev (".collapsed-status").each (function () {
			$(this).toggle (!$(this).nextAll ("ul.directory").eq (0).is (":visible"))
		});
	});

	$("a.directory").click (function (event) {
		$(this).nextAll ("ul.directory").eq (0).toggle ('fast', 'swing', function () {
			$(this).prev (".collapsed-status").toggle (!$(this).is (":visible"));
		});
	});
});
