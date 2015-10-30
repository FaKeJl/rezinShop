{if $shop2.my.price_on_request && $obj.buy_mode == 1}
	{if $shop2.view == "list" && $mode != "product"}
		<div class="price-current">по запросу</div>
	{else}
		<div class="price-current">Цена по запросу</div>
	{/if}
{elseif $shop2.view == "list" && $mode != "product"}
	<div class="price-current">
	<strong>{$obj.price|price_convert}</strong>&nbsp;{if $shop2.my.price_fa_rouble}<em class="fa fa-rouble"></em>{else}{$currency.currency_shortname}{/if}

	</div>
{else}
	<div class="price-current">
		<strong>{$obj.price|price_convert}</strong> {if $shop2.my.price_fa_rouble}<em class="fa fa-rouble"></em>{else}{$currency.currency_shortname}{/if}
		{if $shop2.my.show_product_unit && $obj.params.unit}({$obj.params.unit}){/if}
	</div>
{/if}