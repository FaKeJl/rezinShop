
<div id="shop2-cart-preview">
	<div class="shop-cart">

		<div class="shop-cart--amount">{*$shop2_cart.total_amount|default:0*} 10</div>
		<div class="shop-cart--total">Моя корзина: <strong>{*$shop2_cart.total_sum|default:'0'|price_convert*} 250 000</strong> руб. {$shop2.currency_shortname}</div>

		<a href="{get_seo_url mode='cart' uri_prefix=$shop2.uri}" class="shop-cart--checkout">Оформить заказ</a>
		
	</div>
</div>