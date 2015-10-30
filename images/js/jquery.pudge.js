/**
 * pudgeJs - JQuery plugin for sliding menus and blocks.
 * @version v0.0.1
 * @link https://gitlab.dev.cs.m/pudgeJs
 * @update 29.10.15
 * @license MIT
 */
/*global $, jQuery*/
;(function($) {

	var __pluginName = "pudgeJS";

	var Obj = function($elem, opt) {
		this.opt = $.extend({
			timing     : "ease",
			duration   : .3,
			button     : false,
			overlay    : __pluginName + "-overlay",
			overlayCss : true,
			slideToOpen  : true,
			slideToClose : true
		}, opt);

		this.$elem = $elem;
		this.$win = $(window);
		this.$doc = $(document);
		this.$html = $(document.documentElement);
		this.$body = $(document.body);
		this.$overlay = $(this.opt.overlay);

		this.elemWidth = 0;
		this.scrollTop = 0;

		this.isOpened = false;
		this.isIOS = /iPhone|iPad|iPod/i.test(navigator.userAgent);
		this.isRight = -1;
		this.isTouch = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i
		               .test(navigator.userAgent);

		this.msPointerEnabled = window.navigator.msPointerEnabled;
		this.touchEvents = {
			start: this.isTouch ? this.msPointerEnabled ? "MSPointerDown" :
			       "touchstart" : "mousedown",
			move: this.isTouch ? this.msPointerEnabled ? "MSPointerMove" :
			      "touchmove" : "mousemove",
			end: this.isTouch ? this.msPointerEnabled ? "MSPointerUp" :
			     "touchend touchcancel" : "mouseup",
			all: this.isTouch ? this.msPointerEnabled ?
			     "MSPointerDown MSPointerMove MSPointerUp" :
			     "touchstart touchmove touchend touchcancel" :
			     "mousedown mousemove mouseup"
		};

		this.direction = undefined;

		this.coord = {
			sx: null,
			sy: null,
			mx: null,
			my: null,
			lx: null,
			ly: null,
			bx: null
		};
		this.moveSpeed = [];

		this._init();
	};

	Obj.prototype = {
		_init: function() {
			this._onTouchDocument();
			this._addOverlay();
			this._onSliding();
		},

		open: function() {
			var self = this,
				duration = self.opt.duration,
				timing = self.opt.timing;

			if (!!arguments.length) {
				for (var i = arguments.length - 1; i >= 0; i--) {
					switch (typeof arguments[i]) {
					case "string":
						duration = arguments[i];
						break;
					case "number":
						timing = arguments[i];
						break;
					};
				};
			};

			this.isOpened = true;
			this.elemWidth = getBoundingClientRect(this.$elem[0]).width;
			this.scrollTop = this.$html.scrollTop() || this.$body.scrollTop();
			this.isRight = getBoundingClientRect(this.$elem[0]).left < 0 ? -1 : 1;

			animit(this.$overlay[0]).queue({
				opacity: 2,
				visibility: "visible"
			}, {
				duration: self.opt.duration,
				timing: self.opt.timing
			}).play();

			animit(this.$elem[0]).queue({
				transform: "translate3d(0, 0 ,0)"
			}, {
				duration: self.opt.duration,
				timing: self.opt.timing
			}).play();

			this.$html.addClass("overflowHidden");
			this.$elem.addClass(__pluginName + "-opened");

			// if (this.isIOS && !!this.opt.wrapper) {
			// 	this.$body.addClass("overflowHidden");
			// 	this.opt.wrapper.css("top", -this.scrollTop);
			// }
		},

		close: function() {
			var self = this;

			self.isOpened = false;
			this.elemWidth = getBoundingClientRect(this.$elem[0]).width;

			animit(this.$overlay[0]).queue({
				opacity: 0
			}, {
				duration: self.opt.duration,
				timing: self.opt.timing
			}).play();

			animit(this.$elem[0]).queue({
				transform: "translate3d(" + 100 * self.isRight + "%, 0 ,0)"
			}, {
				duration: self.opt.duration,
				timing: self.opt.timing
			}).play(function() {
				if (!self.isOpened) {
					self.$html.removeClass("overflowHidden");
					self.$overlay.css("visibility", "hidden");
				}

				// if (self.isIOS && !!self.opt.wrapper) {
				// 	setTimeout($.proxy(function() {
				// 		self.$body.removeClass("overflowHidden");
				// 		this.opt.wrapper.css("top", 0);
				// 		$("html, body").scrollTop(this.scrollTop);

				// 		this.scrollTop = 0;

				// 	}, self), 100);
				// }
			});

			self.$elem.removeClass(__pluginName + "-opened");
		},

		toggle: function() {
			return this.isOpened ? this.close() : this.open();
		},

		destroy: function() {
			this.isOpened = false;
			this.$elem.removeAttr("style").removeClass(__pluginName + "-opened");
			this.$overlay.css({
				visibility: "hidden",
				opacity: 0
			});
			this.$elem.removeData(__pluginName);
		},

		update: function(opt) {
			this.opt = $.extend(this.opt, opt);
		},

		_onTouchDocument: function() {
			var self = this;
			var started = false;
			var coord = {
				sx: null,
				lx: null,
				sy: null,
				ly: null
			};

			self.$doc.on(this.touchEvents.all, function(event) {
				if ( $(event.target).closest(self.$elem).length || !self.isOpened ||
					 $(event.target).closest(self.opt.button).length ) {
					return;
				};

				if (/mousedown|touchstart|MSPointerDown/i.test(event.type)) {
					started = true;
					coord.sx = Math.abs(pointer(event).x);
					coord.sy = Math.abs(pointer(event).y);
				};

				if (/mouseup|touchend|MSPointerUp/i.test(event.type) && started) {
					started = false;
					coord.lx = Math.abs(pointer(event).x);
					coord.ly = Math.abs(pointer(event).y);

					if (Math.abs(coord.lx - coord.sx) < 5 && Math.abs(coord.ly - coord.sy) < 5) {
						self.close();
					}
				};
			});
		},

		_addOverlay: function() {
			var $overlay;

			if (!!$("." + this.opt.overlay).length) {
				this.$overlay = $("." + this.opt.overlay);
				return;
			};

			if (this.opt.overlay) {
				$overlay = $("<div class=\"" + this.opt.overlay + "\"/>");
				$overlay.addClass(this.opt.overlay);

				if (this.opt.overlayCss) {
					$overlay.css({
						position: "fixed",
						zIndex: 1,
						left: 0,
						top: 0,
						right: 0,
						bottom: 0,
						opacity: 0,
						visibility: "hidden"

					});
				};

				this.$body.append($overlay);
				this.$overlay = $overlay;
			};
		},

		_onSliding: function() {
			var self = this;

			this.$doc.on(this.touchEvents.start + "." + __pluginName, onStart);
			this.$doc.on(this.touchEvents.end + "." + __pluginName, onEnd);

			function onStart(event) {
				self.coord.sx = Math.abs(pointer(event).x);
				self.coord.sy = Math.abs(pointer(event).y);
				self.coord.bx = getTransform(self.$elem[0]).x;
				self.elemWidth = getBoundingClientRect(self.$elem[0]).width;

				self.moveSpeed.push({
					s: self.coord.mx,
					t: Date.now()
				});

				$(this).on(self.touchEvents.move + "." + __pluginName, onMove);
			}

			function onMove(event) {
				self.coord.mx = Math.abs(pointer(event).x);
				self.coord.my = Math.abs(pointer(event).y);

				if (typeof self.direction === "undefined") {
					self.direction = Math.abs(self.coord.mx - self.coord.sx) >
					                 Math.abs(self.coord.my - self.coord.sy) ?
					                 "horizontal" : "vertical";
				};

				if ( (self.coord.sx < 20 && !(self.isRight + 1) ||
				      self.coord.sx > self.$win.width() - 20 && !!(self.isRight + 1) ) &&
				     !self.isIOS && !self.isOpened && self.direction === "horizontal" &&
				      self.opt.slideToOpen) {
					moving();
				};

				if (self.isOpened && self.direction === "horizontal" && self.opt.slideToClose) {
					moving();
				};

				function moving() {
					var coordMove = self.coord.mx - self.coord.sx;

					event.preventDefault();

					coordMove += self.coord.bx;

					if ( coordMove > 0 && !(self.isRight + 1) ) {
						coordMove = 0;
					} else if ( coordMove < -self.elemWidth && !(self.isRight + 1) ) {
						coordMove = -self.elemWidth;
					} else if ( coordMove < 0 && !!(self.isRight + 1) ) {
						coordMove = 0;
					} else if ( coordMove > self.elemWidth && !!(self.isRight + 1) ) {
						coordMove = self.elemWidth;
					};

					self.moveSpeed.push({
						s: self.coord.mx,
						t: Date.now()
					});

					if (self.moveSpeed.length > 5) {
						self.moveSpeed.shift();
					}

					if (!self.$html.hasClass("overflowHidden")) {
						self.$html.addClass("overflowHidden");
					}

					animit(self.$overlay[0]).queue({
						opacity: (self.elemWidth - Math.abs(coordMove)) / self.elemWidth,
						visibility: "visible",
						transition: "none",
						transform: "translateZ(0)"
					}).play();

					animit(self.$elem[0]).queue({
						transform: "translate3d(" + coordMove + "px, 0 ,0)",
						transition: "none"
					}).play();
				};
			};

			function onEnd(event) {
				var msl, speed, distance, time, direction;

				self.coord.lx = Math.abs(pointer(event).x);
				self.coord.ly = Math.abs(pointer(event).y);

				if (self.moveSpeed.length > 1) {
					msl = self.moveSpeed.length;
					distance = Math.abs(self.moveSpeed[msl-1].s - self.moveSpeed[msl-2].s);
					time = self.moveSpeed[msl-1].t - self.moveSpeed[msl-2].t;
					speed = (distance / time);

					if ( self.moveSpeed[msl-1].s > self.moveSpeed[msl-2].s &&
					   !(self.isRight + 1) )  {
						direction = "right";
					} else if (self.moveSpeed[msl-1].s < self.moveSpeed[msl-2].s &&
					         !(self.isRight + 1)) {
						direction = "left";
					} else if ( self.moveSpeed[msl-1].s < self.moveSpeed[msl-2].s &&
					   !!(self.isRight + 1) ) {
						direction = "left";
					} else if ( self.moveSpeed[msl-1].s > self.moveSpeed[msl-2].s &&
					   !!(self.isRight + 1) ) {
						direction = "right";
					}

					if (speed <= .1 && Math.abs(getTransform(self.$elem[0]).x) < self.elemWidth / 2) {
						self.open("ease-out");
					} else if (speed <= .1 && Math.abs(getTransform(self.$elem[0]).x) > self.elemWidth / 2) {
						self.close("ease-out");
					} else if (speed > .1 && direction === "left" && !(self.isRight + 1)) {
						self.close("ease-out");
					} else if (speed > .1 && direction === "right" && !(self.isRight + 1)) {
						self.open("ease-out");
					} else if (speed > .1 && direction === "right" && !!(self.isRight + 1)) {
						self.close("ease-out");
					} else if (speed > .1 && direction === "left" && !!(self.isRight + 1)) {
						self.open("ease-out");
					}
				}

				$(this).off(self.touchEvents.move + "." + __pluginName, onMove);

				for (var prop in self.coord) {
					self.coord[prop] = null
				};

				self.moveSpeed = [];
				self.direction = undefined;
			}
		},
	}

	function getTransform(el) {
		var transform = window.getComputedStyle(el, null).getPropertyValue(getVendorPropertyName("transform")),
			results = transform.match(/matrix(?:(3d)\(-{0,1}\d+(?:, -{0,1}\d+)*(?:, (-{0,1}\d+))(?:, (-{0,1}\d+))(?:, (-{0,1}\d+)), -{0,1}\d+\)|\(-{0,1}\d+(?:, -{0,1}\d+)*(?:, (-{0,1}\d+))(?:, (-{0,1}\d+))\))/);

		if(!results) return [0, 0, 0];
		if(results[1] == "3d") return results.slice(2,5);

		results.push(0);
		results = results.slice(5, 8);

		return {
			x: +results[0],
			y: +results[1],
			z: +results[2]
		};
	};

	function getVendorPropertyName(prop) {
		var div = document.createElement("div");

		if (prop in div.style) return prop;

		var prefixes = ["-moz-", "-webkit-", "-o-", "-ms-"];

		for (var i = 0; i < prefixes.length; ++i) {
			var vendorProp = prefixes[i] + prop;

			if (vendorProp in div.style) {
				return vendorProp;
			};
		};
	};

	function getBoundingClientRect(elem) {
		return elem.getBoundingClientRect();
	};

	function pointer(event) {
		var result = { x: null, y: null };

		event = event.originalEvent || event || window.event;

		event = event.touches && event.touches.length ?
			event.touches[0] : event.changedTouches && event.changedTouches.length ?
				event.changedTouches[0] : event;

		if (event.pageX) {
			result.x = event.pageX;
			result.y = event.pageY;
		} else {
			result.x = event.clientX;
			result.y = event.clientY;
		};

		return result;
	};

	$.fn[__pluginName] = function(opt, param) {
		return this.each(function() {
			var $elem = $(this), obj;

			if (!!(obj = $elem.data(__pluginName))) {
				if (typeof opt === "string" && !!obj[opt])
					obj[opt](param);
				else
					obj.update(opt);
			} else {
				$elem.data(__pluginName, new Obj($elem, opt));
			};
		});
	};
})(jQuery);