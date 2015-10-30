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

		// sliders
		$(".owl-carousel").each(function(index, el) {
			$(el).owlCarousel({
				loop: true,
				autoplay: true,
				nav: true,
				items: 1,
				dots: true
			});
		});

		// resizeController 768 mv blocks
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
						amountParent = parent.querySelector(".column-amount"),
						buttonAddParent = parent.querySelector(".column-add")
					
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

		// resizeController 1023 - init|destroy plugins
		(function(){
			var $dropWrap = $(".categories--dropdown"),
				$filterInner = $(".shop-filter-inner-wrap");

			resizeController(1023, function(){
				// menu
				$nav.pudgeJS();
				$navTitle.on("click", menuSwiper);
				$navTitle.off("click", menuToggle);
				$dropWrap.removeClass("show");

				// filter
				$filterInner.customScroll();
				$(".shop-filter").pudgeJS({slideToOpen: false});
				$(".push_to_filter").on("click", filterOpen);
				$(".close_filter").on("click", filterClose);

			}, function(){
				$navTitle.on("click", menuToggle);

				// plugins destroy
				$nav.pudgeJS("destroy");
				$filterInner.customScroll("destroy");

				// rm event listener
				$navTitle.off("click", menuSwiper);
				$(".push_to_filter").off("click", filterOpen);
				$(".close_filter").off("click", filterClose);
			});

			function menuSwiper() {
				$nav.pudgeJS("toggle");
			};

			function menuToggle() {
				$(".categories--dropdown").toggleClass("show");
			};

			function filterOpen() {
				$(".shop-filter").pudgeJS("open");
			};

			function filterClose() {
				$(".shop-filter").pudgeJS("close");
			};
		})();

		// slider range
		(function() {
			var noUiSliderAll = document.querySelectorAll(".range_slider");

			[].forEach.call(noUiSliderAll, function(elem) {

				var parent = elem.parentNode,
					lower = parent.querySelector(".noUi-slider__low"),
					upper = parent.querySelector(".noUi-slider__hight");

				noUiSlider.create(elem, {
					start: [ 0, 1000 ],
					connect: true,
					range: {
						"min": 0,
						"max": 1000
					}
				});

				elem.noUiSlider.on("update", function( values, handle ) {
					var value = values[handle];

					if ( handle ) {
						upper.value = Math.round(value);
					} else {
						lower.value = Math.round(value);
					}
				});

				lower.addEventListener("change", function() {
					elem.noUiSlider.set([this.value, null]);
				});

				upper.addEventListener("change", function() {
					elem.noUiSlider.set([null, this.value]);
				});
			});
		})();

		// search toggle
		toggleElem(".site-search--wrapper", ".shop-search--button");

		// sorting toggle
		toggleElem(".view_wrapper", ".show_me_view")
		toggleElem(".sorting", ".sort-title")

		// toggle function
		function toggleElem(elem, pushEl) {
			$(pushEl).click(function(event) {
				event.preventDefault();
				$(elem).toggleClass("open");
			});
			$doc.on("click touchstart", function(event) {
				if ($(event.target).closest(elem).length) return;
				$(elem).removeClass("open")
			});
		};

		// resize controller function
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
					};
				};
			};

			$win.resize(function(event) {
				winWidth = $win.width();
				
				if (range.length > 1) {
					if (winWidth >= range[0] && winWidth <= range[range.length-1] &&
					    typeof toggleState[0] === "undefined") {
						func[0]();
						toggleState[0] = true;
						toggleState[1] = undefined;
					} else if ((winWidth < range[0] || winWidth > range[range.length-1]) &&
					            typeof toggleState[1] === "undefined") {
						toggleState[0] = undefined;
						toggleState[1] = true;

						if ($.isFunction(func[1])) {
							func[1]();
						}
					};
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
						};
					};
				};
			}).trigger("resize");
		};
	});
})(jQuery);