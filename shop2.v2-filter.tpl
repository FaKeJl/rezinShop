{assign var="after" value=0}
{if isset($smarty.get.s) || isset($smarty.get.search_text)}
	{assign var="after" value=1}
{/if}

{if $shop2.products || $after}

	{assign var="hide_in_filter" value=$shop2.my.hide_in_filter}
	{if !$hide_in_filter}
		{assign var="hide_in_filter" value=","|explode:""}
	{/if}

	{assign var="min_count_in_select" value=$shop2.my.min_count_in_select|default:7}
	{if $shop2.my.list_in_select}
		{assign var="min_count_in_select" value=99999}
	{/if}

	{assign var="show_price" value=0}
	{if !(!$user && $shop2.my.hide_prices_non_reg)}
		{assign var="show_price" value=1}
	{/if}

	{assign var="has_params" value=false}
	{if !$shop2.fallback_mode}
		{if $block_filter}
		{capture assign="filter"}			
			<div class="filter-param">
				{if !in_array("price", $hide_in_filter) && $show_price}
				{assign var="has_params" value=true}
				<div class="row_wrap">
					<div class="field_title">{#SHOP2_PRICE#}:</div>
					<div class="range_slider_wrapper">
						<label class="left-s">
							<span>{#SHOP2_FROM#}</span>&nbsp;<input class="shop2-input-float small noUi-slider__low" type="text" value="{$smarty.get.s.price.min|htmlspecialchars}" name="s[price][min]" />
						</label>
						<label class="right-s">
							<span>{#SHOP2_TO#}</span>&nbsp;<input class="shop2-input-float small noUi-slider__hight" type="text" value="{$smarty.get.s.price.max|htmlspecialchars}" name="s[price][max]" />
						</label>
						<div class="clear"></div>
						<div class="range_slider"></div>
					</div>
				</div>
				{/if}

				{if $folder.vendors && !in_array("vendors", $hide_in_filter)}
					{assign var="has_params" value=true}
					<div class="row_wrap">
						<div class="field_title">{$shop2.my.vendor_alias|default:#SHOP2_VENDOR#}:</div>
						<div class="field_body">
							{if $folder.vendors|@count > $min_count_in_select}
								<select name="s[vendor_id]">
									<option value="">{#SHOP2_ALL#}</option>
									{foreach from=$folder.vendors item=e key=k}
										<option {if in_array($e.vendor_id, $smarty.get.s.vendor_id)}selected="selected"{/if} value="{$e.vendor_id}">{$e.name}</option>
									{/foreach}
								</select>
							{else}
								{foreach from=$folder.vendors item=e key=k}
									<a href="#" data-name="s[vendor_id][]" data-value="{$e.vendor_id}" class="param-val{if in_array($e.vendor_id, $smarty.get.s.vendor_id)} active-val{/if}">
										{$e.name}<span>&nbsp;</span>
									</a>
								{/foreach}
							{/if}
						</div>
					</div>
				{/if}

				{if $mode == 'main'}
					{include file="global:shop2.v2-filter-fields.tpl" fields=$shop2.global_params}
				{/if}
				{include file="global:shop2.v2-filter-fields.tpl" fields=$filter_fields}

				{if $shop2.my.show_amount_filter}
					{assign var="has_params" value=true}
					<div>
						<div>В наличии:</div>
						<div>
							{assign var="active" value=0}
							{if $smarty.get.s.amount.min == 1 || ( $smarty.get.s.amount.min == 0 && isset($smarty.get.s.amount.min) )}
								{assign var="active" value=1}
							{/if}
							<a href="#" data-name="s[amount][min]" data-value="1" class="param-val{if $active} active-val{/if}">{#SHOP2_YES#}<span>&nbsp;</span></a>
							
							{assign var="active" value=0}
							{if ( $smarty.get.s.amount.max == 0 && isset($smarty.get.s.amount.max) ) || ( $smarty.get.s.amount.min == 0 && isset($smarty.get.s.amount.min) ) }
								{assign var="active" value=1}
							{/if}
							<a href="#" data-name="s[amount][max]" data-value="0" class="param-val{if $active} active-val{/if}">{#SHOP2_NO#}<span>&nbsp;</span></a>
						</div>
					</div>
				{/if}

				{if $shop2.my.toggle_params}{strip}
					<tr>
						<th colspan="2">
							<a class="shop2-toggle-fields" href="#" data-alt="{$shop2.my.show_filter_fields_alias|htmlspecialchars}">
								{$shop2.my.hide_filter_fields_alias}
							</a>
						</th>
					</tr>
				{/strip}{/if}

			</div>
		{/capture}
		
		{if $has_params || $page.has_filter_params}
			<div class="filter_title">Фильтр товаров</div>
			<form action="#" class="shop-filter">
				<a id="shop2-filter"></a>

				{$filter}

				<div class="result {if $after && !$found}no-result{/if} {if !$after}hide{/if}">
					{#SHOP2_FOUND#}: <span id="filter-result">{if !$after}0{else}{$found|default:0}{/if}</span>
					<span class="result-arrow">&nbsp;</span>
				</div>
				<a href="#" class="shop2-btn shop2-filter-go">{#SHOP2_SHOW#}</a>
				<a href="{$SCRIPT_NAME}" class="shop2-btn">{#SHOP2_RESET_FILTER#}</a>
				<div class="shop2-clear-container"></div>
			

			</form><!-- Filter -->
		{/if}

		{else}

		{if $shop2.products}

			{assign var="sort_by" value=$smarty.get.s.sort_by}

			{if $sort_by != $sort_by|regex_replace:"/name desc/":""}
				{assign var="sort_name_desc" value=1}
			{/if}

			{if $sort_by != $sort_by|regex_replace:"/name asc/":""}
				{assign var="sort_name_asc" value=1}
			{/if}

			{if $sort_by != $sort_by|regex_replace:"/price desc/":""}
				{assign var="sort_price_desc" value=1}
			{/if}

			{if $sort_by != $sort_by|regex_replace:"/price asc/":""}
				{assign var="sort_price_asc" value=1}
			{/if}

			{if $sort_by != $sort_by|regex_replace:"/amount desc/":""}
				{assign var="sort_amount_desc" value=1}
			{/if}

			{if $sort_by != $sort_by|regex_replace:"/amount asc/":""}
				{assign var="sort_amount_asc" value=1}
			{/if}

			{if $sort_by != $sort_by|regex_replace:"/rating desc/":""}
				{assign var="sort_rating_desc" value=1}
			{/if}

			{if $sort_by != $sort_by|regex_replace:"/rating asc/":""}
				{assign var="sort_rating_asc" value=1}
			{/if}


			<div class="shop-sorting-panel">
				<div class="sorting">
					<span class="sort-title">{#SHOP2_SORT_BY#}:</span>
					<div class="sort_params_wrap">
					<a href="#" id="shop2-sorting-name" class="sort-param {if $sort_name_asc}sort-param-asc{elseif $sort_name_desc}sort-param-desc{/if}" data-name="name">{#SHOP2_SORT_BY_NAME#}</a>
					
					{if $show_price}
						<a href="#" id="shop2-sorting-price" class="sort-param {if $sort_price_asc}sort-param-asc{elseif $sort_price_desc}sort-param-desc{/if}" data-name="price">{#SHOP2_SORT_BY_PRICE#}</a>
					{/if}

					{if $shop2.my.show_amount_sort}
						<a href="#" class="sort-param {if $sort_amount_asc}sort-param-asc{elseif $sort_amount_desc}sort-param-desc{/if}" data-name="amount">Наличию</a>
					{/if}

					{if $shop2.my.show_rating_sort}
						<a href="#" class="sort-param {if $sort_rating_asc}sort-param-asc{elseif $sort_rating_desc}sort-param-desc{/if}" data-name="rating">Рейтингу</a>
					{/if}
					</div>

					{*<a href="#" class="sort-reset"><ins>{#SHOP2_RESET#}</ins></a>*}
				</div>
				<div class="view_wrapper">
					<div class="view-shop {if $shop2.view == 'thumbs'}thumbs{elseif $shop2.view == 'simple'}simple{else}list{/if}">
						<a href="#" title="{#SHOP2_LIST#}" data-value="simple" class="shop-btn simple {if $shop2.view=='simple'} active-view{/if}"><span class="one"></span></a>
						<a href="#" title="{#SHOP2_THUMBS#}" data-value="thumbs" class="shop-btn thumbs {if $shop2.view=='thumbs'} active-view{/if}"><span class="one"></span><span class="two"></span></a>
						<a href="#" title="{#SHOP2_PRICE_LIST#}" data-value="list" class="shop-btn pricelist {if $shop2.view=='list'} active-view{/if}"><span class="one"></span></a>

					</div>
					<div class="show_me_view">
						<div class="{if $shop2.view == 'thumbs'}thumbs{elseif $shop2.view == 'simple'}simple{else}list{/if}">
							<span class="one"></span><span class="two"></span>
						</div>
					</div>
				</div>
			</div>
		{elseif $smarty.get.s || $smarty.get.search_text}    
			<div class="shop2-warning">
				<h2>{#SHOP2_NO_MATCHING_REQUEST#}</h2>
			</div>
		{/if}
		{/if}
	{/if}
{/if}