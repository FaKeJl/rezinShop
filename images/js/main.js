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
			navIsOpened = false,
			isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);

		// table wrapp
		$table.wrap("<div class=\"table-wrapper\"></div>");

		if (isMobile && $win.width() <= 1024) {
			// var swipeMenu = $nav.swipeMenu({
			// 	// duration: .27,
			// 	wrapper: $siteWrapper,
			// 	button: ".categories--title"
			// });
			// var swipeFilter = $('.shop-filter').swipeMenu({
			// 	// duration: .27,
			// 	wrapper: $siteWrapper,
			// 	button: ".button"
			// });

		} else {
			$navTitle.click(function() {
				$('.categories--dropdown').toggleClass('show');
			});
		}

		$nav.pudgeJS();

		$('.categories--title').on('click', function myFunc() {
			$nav.pudgeJS('toggle');
		});

		// $('.shop-filter').pudgeJS();

		// $('.button').on('click', function() {
		// 	$('.shop-filter').pudgeJS("toggle");
		// })

		// MAIN_SLIDER
		$(".owl-carousel").owlCarousel({
			loop: true,
			autoplay: true,
			nav: true,
			items: 1,
			dots: true
		});

		// SLIDER-RANGE
		
		var noUiSliderAll = document.querySelectorAll('.range_slider');

		[].forEach.call(noUiSliderAll, function(elem) {

			var parent = elem.parentNode,
				lower = parent.querySelector('.noUi-slider__low'),
				upper = parent.querySelector('.noUi-slider__hight');

			noUiSlider.create(elem, {
				start: [ 0, 1000 ],
				connect: true,
				range: {
					'min': 0,
					'max': 1000
				}
			});

			elem.noUiSlider.on('update', function( values, handle ) {
				var value = values[handle];

				if ( handle ) {
					upper.value = Math.round(value);
				} else {
					lower.value = Math.round(value);
				}
			});

			lower.addEventListener('change', function() {
				elem.noUiSlider.set([this.value, null]);
			});

			upper.addEventListener('change', function() {
				elem.noUiSlider.set([null, this.value]);
			});
		});


		// SEARCH_ELEMENTS

		toggleElem('.site-search--wrapper', '.shop-search--button');

			// SORTING_ELEMENTS
		toggleElem('.view_wrapper', '.show_me_view')
		toggleElem('.sorting', '.sort-title')


		// TOGGLE-FUNCTIONS
		
		function toggleElem (elem, pushEl) {
			$(pushEl).click(function(event) {
				event.preventDefault();				
				$(elem).toggleClass('open');
			});
			$doc.on('click touchstart', function(event) {
				if ($(event.target).closest(elem).length) return;
				$(elem).removeClass('open')
			});
		}
		
	});
	
})(jQuery);


