(function($) {

	var __pluginName = 'swipeMenu';

	var Obj = function($self, opt) {
		this.$self = $self;
		this.$htmlBody = $('html, body');
		this.$doc = $(document);
		this.selfWidth = $self.outerWidth();
		this.translatex = 0;
		this.isOpenedBefore = false;
		this.isOpenedAfter = false;
		this.scrollTop = undefined;
		this.isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);;
		this.opt = $.extend({
			button : opt.button,
			animateTiming: opt.animateTiming,
			overflowHiddenClass: opt.overflowHiddenClass,
			siteWrapper: opt.siteWrapper,
			duration : opt.duration,
			position: opt.position
		}, opt);

		this.init();
	};

	Obj.prototype.init = function() {
		var _this = this,
			moveStart = false;

		_this.tapDetection(this.opt.button, function(event) {
			_this.toggle();
		});

		_this.$doc.on(_this.isMobile ? 'touchstart MSPointerDown' : 'mousedown', function(event) {
			// if ( $(event.target).closest(_this.$self).length ) return;

			var startX = _this.pointer(event).x,
				startY = _this.pointer(event).y,
				startTransformX = _this.generateTransform().x;

			$(this).on(_this.isMobile ? 'touchmove.menuSwipe MSPointerMove.menuSwipe' : 'mousemove.menuSwipe', function(event) {
				var moveX = _this.pointer(event).x - startX,
					moveY = _this.pointer(event).y - startY,
					moveTransformX = startTransformX + moveX;

				// if (Math.abs(moveY) > Math.abs(moveX)) return;
				if (moveTransformX <= -_this.selfWidth || moveTransformX >= 0) return;

				// console.log(moveTransformX, -_this.selfWidth)

				if (!moveStart) {
					moveStart = true;
					_this.scrollTop = $(document.body).scrollTop() || $(document.documentElement).scrollTop();
					_this.isOpenedBefore = true;
					_this.overflowHidden();
				}

				_this.overflowHidden();
				
				animit(_this.$self[0]).queue({
					'transition' : 'none',
					'transform' : 'translateX(' + moveTransformX + 'px)'
				}, {
					duration: 1,
					timing: _this.opt.animateTiming
				}).play();
			});			
		});

		_this.$doc.on(_this.isMobile ? 'touchend touchcancel MSPointerUp' : 'mouseup', function(event) {
			if ( !$(event.target).closest(_this.$self).length ) {
				_this.selfWidth = _this.$self.outerWidth();

				if (Math.abs(_this.generateTransform().x) < _this.selfWidth / 2) {
					_this.open();
				} else {
					moveStart = false;
					_this.close();
				}
			}

			$(this).off('.menuSwipe');

		});

		_this.orientationchange(function(event) {
			if (typeof _this.scrollTop !== 'undefined') {
				var $siteWrapper = typeof _this.opt.siteWrapper === 'string' ? $(_this.opt.siteWrapper) : _this.opt.siteWrapper,
					positionTop = Math.abs(parseFloat($siteWrapper.css('top'))),
					siteheight = $siteWrapper.outerHeight(),
					winHeight = $(window).height(),
					difference = siteheight - positionTop - winHeight;

				if (difference < 0) {
					_this.scrollTop = _this.scrollTop - Math.abs(difference);
					$siteWrapper.css('top', -_this.scrollTop);
				}
			} else {
				var translatex = 'translateX(' + -_this.$self.outerWidth() + 'px)';
				_this.$self.css(_this.getVendorPropertyName('transition'), 'none');
				_this.$self.css(_this.getVendorPropertyName('transform'), translatex);
			}
		});
	};

	Obj.prototype.destroy = function() {
		this.$self.removeData(__pluginName);
	};

	Obj.prototype.update = function(opt) {
		this.opt = $.extend(this.opt, opt);
	};

	Obj.prototype.open = function() {
		var self = this,
			duration = this.duration();

		this.selfWidth = this.$self.outerWidth();
		this.translatex = 0;
		this.isOpenedBefore = true;
		this.scrollTop = $(document.body).scrollTop() || $(document.documentElement).scrollTop();

		this.overflowHidden();

		animit(this.$self[0]).queue({
			transform: 'translateX(' + self.translatex + 'px)'
		}, {
			duration: duration,
			timing: self.opt.animateTiming
		}).play($.proxy(function() {

			this.isOpenedAfter = true;
			this.$self.trigger('isOpenedAfter');

		}, this));

		this.$self.addClass('swipeMenu-opened');
	}

	Obj.prototype.close = function() {
		var self = this,
			duration = this.duration();

		this.selfWidth = this.$self.outerWidth();
		this.translatex = -this.selfWidth;
		this.isOpenedBefore = false;

		this.overflowHidden();

		animit(this.$self[0]).queue({
			transform: 'translateX(' + self.translatex + 'px)'
		}, {
			duration: duration,
			timing: self.opt.animateTiming
		}).play($.proxy(function() {

			this.isOpenedAfter = false;
			this.$self.trigger('isClosedAfter');

		}, this));

		this.$self.removeClass('swipeMenu-opened');
	}

	Obj.prototype.toggle = function() {
		var _this = this,
			duration = (_this.opt.duration * Math.abs(_this.$self.offset().left)) / _this.selfWidth;

		_this.selfWidth = _this.$self.outerWidth();
		_this.translatex = _this.isOpenedBefore ? -_this.selfWidth : 0;
		_this.isOpenedBefore = _this.isOpenedBefore ? false : true;

		if (typeof _this.scrollTop === 'undefined') {
			_this.scrollTop = $(document.body).scrollTop() || $(document.documentElement).scrollTop();
			$.proxy(_this.overflowHidden(), _this);
		}

		duration = this.isOpenedBefore ? duration : _this.opt.duration - duration;

		animit(_this.$self[0]).queue({
			transform: 'translateX(' + _this.translatex + 'px)'
		}, {
			duration: duration,
			timing: _this.opt.animateTiming
		}).play(function() {
			_this.isOpenedAfter = _this.generateTransform().x == 0 ? true : false;
			_this.$self.trigger(_this.isOpenedAfter ? 'isOpenedAfter' : 'isClosedAfter');
			$.proxy(_this.overflowHidden(), _this);
		});

		//this.$self[_this.isOpenedBefore ? 'addClass' : 'removeClass']('swipeMenu-opened');
		this.$self.toggleClass('swipeMenu-opened');
	}

	Obj.prototype.overflowHidden = function() {
		var $siteWrapper = typeof this.opt.siteWrapper === 'string' ? $(this.opt.siteWrapper) : this.opt.siteWrapper,
			$htmlBody = this.$htmlBody;

		if (this.isOpenedBefore) {
			$htmlBody.addClass(this.opt.overflowHiddenClass);
			$siteWrapper.css('top', -this.scrollTop);
		} else {
			setTimeout($.proxy(function() {
				$htmlBody.removeClass(this.opt.overflowHiddenClass);
				$siteWrapper.css('top', 0);
				$htmlBody.scrollTop(this.scrollTop);
				this.scrollTop = undefined;
			}, this), 100);
		}
	}

	Obj.prototype.duration = function() {
		return (this.opt.duration * Math.abs(this.$self.offset().left)) / this.selfWidth;
	}

	Obj.prototype.tapDetection = function(elem, func, type) {
		var $touchArea = typeof elem === 'string' ? $(elem) : elem,
			touchStarted = false,
			evt = window.navigator.msPointerEnabled ? "MSPointerDown MSPointerUp" : "touchstart touchend touchcancel",
			click = this.isMobile ? evt : 'mousedown mouseup',
			_this = this,
			currX, currY, areaWidth, areaHeight, areaOffset;

		$touchArea.on(click, function(event) {
			if (/mousedown|touchstart|MSPointerDown/i.test(event.type)) {
				areaWidth = $touchArea.outerWidth();
				areaHeight = $touchArea.outerHeight();
				areaOffset = $touchArea.offset();
				touchStarted = true;
			}

			if (/mouseup|touchend|MSPointerUp/i.test(event.type) && touchStarted) {
				touchStarted = false;
				currX = _this.pointer(event).x;
				currY = _this.pointer(event).y;
				if ($.isFunction(func)) {
					if (event.type == 'mouseup') {
						setTimeout(function() {
							func(event);
						}, 100)
					} else {
						if ( (currX >= areaOffset.left && currX <= areaOffset.left + areaWidth) && (currY >= areaOffset.top && currY <= areaOffset.top + areaHeight) ) {
							func(event);
						}
					}
				}
			}
		});
	}

	Obj.prototype.pointer = function(event) {
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
		}

		return result;
	};

	Obj.prototype.orientationchange = function(func) {
		if ($.isFunction(func)) {
			$(window).on('resize orientationchange', function(event) {
				func(event);
			});
		}
	}

	Obj.prototype.generateTransform = function() {
		var _this = this;

		function getTransform(el) {
			var transform = window.getComputedStyle(el, null).getPropertyValue(_this.getVendorPropertyName('transform'));
			var results = transform.match(/matrix(?:(3d)\(-{0,1}\d+(?:, -{0,1}\d+)*(?:, (-{0,1}\d+))(?:, (-{0,1}\d+))(?:, (-{0,1}\d+)), -{0,1}\d+\)|\(-{0,1}\d+(?:, -{0,1}\d+)*(?:, (-{0,1}\d+))(?:, (-{0,1}\d+))\))/);

			if(!results) return [0, 0, 0];
			if(results[1] == '3d') return results.slice(2,5);

			results.push(0);
			return results.slice(5, 8);
		}

		return {
			x : Number(getTransform(this.$self[0])[0]),
			y : Number(getTransform(this.$self[0])[1]),
			z : Number(getTransform(this.$self[0])[2])
		}
	}

	Obj.prototype.getVendorPropertyName = function(prop) {
		var div = document.createElement('div');

		if (prop in div.style) return prop;

		var prefixes = ['-moz-', '-webkit-', '-o-', '-ms-'];

		for (var i = 0; i < prefixes.length; ++i) {
			var vendorProp = prefixes[i] + prop;

			if (vendorProp in div.style) {
				return vendorProp;
			}
		}
	}

	$.fn[__pluginName] = function(opt, param) {
		return this.each(function() {
			var $self = $(this);
			var obj;
			if(!!(obj = $self.data(__pluginName))) {
				if(typeof opt === 'string' && !!obj[opt])
					obj[opt](param);
				else
					obj.update(opt);
			} else {
				$self.data(__pluginName, new Obj($self, opt));
			}
		});
	}
})(jQuery);