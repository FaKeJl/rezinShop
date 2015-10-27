{if $e.kind_id}
	{assign var="obj" value=$e}
{else}
	{assign var="obj" value=$product}
{/if}

{if $obj.price_old}
	{assign var="discount" value=$discounts[$obj.discounts_applied.0]}
	
	<div class="price-old {if $discount.discount_descr}question{/if}"><span>
		<strong>{$obj.price_old|price_convert}</strong>
		{if $shop2.view != 'list'}
			{if $shop2.my.price_fa_rouble}<em class="fa fa-rouble"></em>{else}{$currency.currency_shortname}{/if}
		{/if}
	</span></div>

	{if $discount.discount_descr}
		<div class="shop2-product-discount-desc">
			{$discount.discount_descr}
		</div>
	{/if}
{/if}