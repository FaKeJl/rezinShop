{if $shop2.comment_settings.allow_rating == 1 || $shop2.comment_settings.allow_rating == 3}
	{capture assign="rating"}{strip}
		<div class="tpl-stars">
			<div class="tpl-rating" style="width: {$product.rating.value*20}%;"></div>
		</div>
	{/strip}{/capture}

	{strip}
		{if $mode == 'product'}
			<div class="tpl-rating-block">
				{#SHOP2_RATING#}: 
				{$rating}
				({$product.rating.count|default:0|spellcount:#SHOP2_VOTE1#:#SHOP2_VOTE2#:#SHOP2_VOTE3#})
			</div>
		{else}
			{$rating}
		{/if}
	{/strip}
{/if}