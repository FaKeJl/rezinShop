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

		(function(){
			resizeController(768, pricelistSwapper, function(){
				pricelistSwapper(true);
			});


			function pricelistSwapper(flag){
				var pasteArea = document.querySelectorAll(".shop2-product-item .column-price");
			
				[].forEach.call(pasteArea, function(elem){
					var parent = elem.parentNode,
						amount = parent.querySelector(".amount_wrapper"),
						buttonAdd = parent.querySelector(".shop-product-btn"),
						amountParent = parent.querySelector('.column-amount'),
						buttonAddParent = parent.querySelector('.column-add')
					
					if (flag) {
						amountParent.appendChild(amount);
						buttonAddParent.appendChild(buttonAdd);
					} else {
						elem.appendChild(amount);
						elem.appendChild(buttonAdd);
					}
				});
			}

		})();

		
		// table wrapp
		$table.wrap("<div class=\"table-wrapper\"></div>");

		(function(){
			var $dropWrap = $('.categories--dropdown');

			resizeController(1023, function(){
				$nav.pudgeJS();						
				$navTitle.on('click', menuSwiper);
				$navTitle.off('click', menuToggle);
				$dropWrap.removeClass('show')	
			}, function(){
				$nav.pudgeJS('destroy');
				$navTitle.off('click', menuSwiper);
				$navTitle.on('click', menuToggle);
			})
			function menuSwiper(){
				$nav.pudgeJS('toggle');
			}
			function menuToggle(){
				$('.categories--dropdown').toggleClass('show');
			}
		})();
		


		$('.shop-filter').pudgeJS({
			slideToOpen: false
		});

		$('.push_to_filter').on('click', function() {
			$('.shop-filter').pudgeJS("open");
		})


		$('.close_filter').on('click', function() {
			$('.shop-filter').pudgeJS("close");
		})


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

		// CUSTOM SCROLL
		if ($win.width() < 1024) {
			$('.shop-filter-inner-wrap').customScroll();	
		}
		

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

		// RESIZE_CONTROL

		function resizeController() {
			var $win = $(window),
				winWidth = $win.width(),
				range = [],
				func = [],
				toggleState = [undefined, undefined];

			if (!!arguments.length) {
				for (var i = 0; i <= arguments.length-1; i++) {
					
					if ($.isArray(arguments[i])) {
						range = arguments[i];
					} else if ($.isNumeric(arguments[i])) {
						range.push(arguments[i]);
					} else if ($.isFunction(arguments[i])) {
						func.push(arguments[i]);
					} 
				};
			}

			$win.resize(function(event) {
				winWidth = $win.width();
				
				if (range.length > 1) {
					if (winWidth >= range[0] && winWidth <= range[range.length-1] && typeof toggleState[0] === "undefined") {
						func[0]();
						toggleState[0] = true;
						toggleState[1] = undefined;												
					} else if ((winWidth < range[0] || winWidth > range[range.length-1]) && typeof toggleState[1] === "undefined") {						
						toggleState[0] = undefined;
						toggleState[1] = true;

						if ($.isFunction(func[1])) {
							func[1]();
						}						
					}
				} else if (range.length == 1) {
					if (winWidth <= range[0] && typeof toggleState[0] === "undefined") {
						func[0]();
						toggleState[0] = true;
						toggleState[1] = undefined;
					} else if (winWidth > range[0] && typeof toggleState[1] === "undefined") {
						toggleState[0] = undefined;
						toggleState[1] = true;

						if ($.isFunction(func[1])) {
							func[1]();
						}
					}
				}				
			}).trigger('resize');
		}

		
	});
	
})(jQuery);


