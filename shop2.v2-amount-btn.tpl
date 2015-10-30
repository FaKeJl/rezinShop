{assign var="pr" value=$product}
{if $collection_list_item}
	{assign var="pr" value=$collection_list_item}
{/if}

{if !$shop2.my.mode_catalog}
	<div class="{$class}">
		<div class="amount_wrapper">
		{if !$hideCaption}
			<div class="amount-title">{#SHOP2_AMOUNT#}:</div>
		{/if}
		{if $pr.buy_mode == 1}
			<div class="shop-product-amount disabled">
				<button type="button" disabled="disabled">&#8722;</button><input type="text" maxlength="4" disabled="disabled" value="{$shop2.my.amount_default|default:1}" /><button type="button" disabled="disabled">&#43;</button>
			</div>
		{else}
			<div class="shop-product-amount">
				<button type="button" class="amount-minus">&#8722;</button><input type="text" name="amount" maxlength="4" value="{$shop2.my.amount_default|default:1}" /><button type="button" class="amount-plus">&#43;</button>
			</div>
		{/if}
		</div>
	</div>
{/if}

{if $shop2.my.mode_catalog2}
	<div class="{$class} shop2-mode-catalog2"></div>
{/if}