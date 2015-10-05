(function($) {

	$(function() {

		// main variable
		var $win = $(window),
			$doc = $(document),
			$html = $(document.documentElement),
			$body = $(document.body),
			$htmlBody = $("html, body"),
			$table = $("table"),
			$nav = $(".navigations--panel"),
			$navTitle = $(".categories--title"),
			$siteWrapper = $(".site-wrapper"),
			siteScrollTop = 0,
			navIsOpened = false;


		// table wrapp
		$table.wrap("<div class=\"table-wrapper\"></div>");

		// menu 
		// $navTitle.on("click", function(event) {
		// 	var scrollTop = $html.scrollTop() || $body.scrollTop();
		// 	event.preventDefault();

		// 	$(this).closest($nav).toggleClass("opened");
		// 	$htmlBody.toggleClass("overflowHidden");

		// 	if ( $nav.hasClass("opened") ) {
		// 		$siteWrapper.css("top", -scrollTop);
		// 		siteScrollTop = scrollTop;
		// 		navIsOpened = true;
		// 	} else {
		// 		$siteWrapper.css("top", 0);
		// 		$htmlBody.scrollTop(siteScrollTop);
		// 		navIsOpened = false;
		// 	}
		// });

		// $doc.on("click touchstart", function(event) {
		// 	if ( $(event.target).closest($nav).length ) return;
		// 	if (navIsOpened) {
		// 		$nav.removeClass("opened");
		// 		$htmlBody.removeClass("overflowHidden");
		// 		$siteWrapper.css("top", 0);
		// 		$htmlBody.scrollTop(siteScrollTop);
		// 	}
		// });

		// var swipeMenu = $nav.swipeMenu({
		// 	button: $navTitle,
		// 	animateTiming: 'ease-in-out',
		// 	overflowHiddenClass: 'overflowHidden',
		// 	siteWrapper: $siteWrapper,
		// 	duration: .27
		// });

		var swipeMenu = $nav.swipeMenu({
			// duration: .27,
			wrapper: $siteWrapper,
			button: ".categories--title"
		});
	});
})(jQuery);