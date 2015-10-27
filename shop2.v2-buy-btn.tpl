{assign var="pr" value=$product}
{if $collection_list_item}
	{assign var="pr" value=$collection_list_item}
{/if}

{if !$shop2.my.mode_catalog}
	{if $pr.buy_mode == 0}
		<button class="shop2-product-btn type-{$type} buy" type="submit">
			<span>{$shop2.my.buy_alias|default:#SHOP2_BUY#}</span>
		</button>
	{elseif $pr.buy_mode == 1}
		<button class="shop2-product-btn type-{$type} notavailable" disabled="disabled" type="submit">
			<span>{$shop2.my.not_available_alias|default:#SHOP2_NOT_AVAILABLE#}</span>
		</button>
	{else}
		<button class="shop2-product-btn type-{$type} onrequest" type="submit">
			<span>{$shop2.my.preorder_alias|default:#SHOP2_PREORDER2#}</span>
		</button>
	{/if}
{/if}

{if $shop2.my.mode_catalog2}
	<button class="shop2-btn">Заказать</button>
{/if}

<input type="hidden" value="{$pr.name|htmlspecialchars}" name="product_name" />
<input type="hidden" value="http://{$site.domain_mask}{get_seo_url uri_prefix=$shop2.uri mode="product" alias=$pr.alias}" name="product_link" />