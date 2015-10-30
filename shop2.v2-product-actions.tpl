{if $product.discounts_applicable|@count>0}
	<div class="shop2-product-actions">
		<dl>
			{foreach from=$product.discounts_applicable name=foo item=e key=k}
				{assign var="discount" value=$discounts.$e}

				<dt {if $discount.gift_id}class="gift-action"{/if}>
					<span class="icon-action">{if !$discount.gift_id}%{/if}</span>
					<span class="name-action">{$discount.discount_name|htmlspecialchars}</span>
				</dt>
				<dd>
					<div class="name-action">{$discount.discount_name|htmlspecialchars}</div>
					<div class="desc-action">
						{$discount.discount_descr|htmlspecialchars_decode}
					</div>
					<div class="close-desc-action"></div>
				</dd>
			{/foreach}
		</dl>
	</div>
{/if}