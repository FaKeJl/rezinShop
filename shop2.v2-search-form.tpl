{assign var="hide_in_search" value=$shop2.my.hide_in_search}
{if !$hide_in_search}
	{assign var="hide_in_search" value=","|explode:""}
{/if}

{assign var="show_price" value=0}
{if !(!$user && $shop2.my.hide_prices_non_reg)}
    {assign var="show_price" value=1}
{/if}

<div class="shop2-block site-search--search-form {if $smarty.cookies.search_opened && !$ignore_cookies} opened{/if}">
	<div class="block-body">
		<form action="{get_seo_url uri_prefix=$shop2.uri mode="search"}" enctype="multipart/form-data">
			<input type="hidden" name="sort_by" value="{$sort_by|default:''}"/>
			
			{if !in_array("price", $hide_in_search) && $show_price}
				<div class="row">
					<div class="row-title">{#SHOP2_PRICE#}:</div>
					<div class="range_slider_wrapper">
						
						<label class="left-s"><span>{#SHOP2_FROM#}</span>&nbsp;<input id="low" name="s[price][min]" type="text" size="5" class="small noUi-slider__low" value="{$search_params.price.min|escape|default:''}" /></label>
					&nbsp;
						<label class="right-s"><span>{#SHOP2_TO#}</span>&nbsp;<input id="hight" name="s[price][max]" type="text" size="5" class="small noUi-slider__hight" value="{$search_params.price.max|escape|default:''}" /></label>

						<div class="range_slider"></div>
					</div>
				</div>
			{/if}

			{if !in_array("name", $hide_in_search)}
				<div class="row">
					<label class="row-title" for="shop2-name">{#SHOP2_PRODUCT_NAME#}:</label>
					<input type="text" name="s[name]" size="20" id="shop2-name" value="{$search_params.name|escape}" />
				</div>
			{/if}

			{if !in_array("article", $hide_in_search) && !$shop2.my.hide_article}
				<div class="row">
					<label class="row-title" for="shop2-article">{#SHOP2_ARTICLE#}:</label>
					<input type="text" name="s[article]" id="shop2-article" value="{$search_params.article|escape}" />
				</div>
			{/if}

			{if !in_array("text", $hide_in_search)}
				<div class="row">
					<label class="row-title" for="shop2-text">{#SHOP2_TEXT#}:</label>
					<input type="text" name="search_text" size="20" id="shop2-text"  value="{$search_text|escape}" />
				</div>
			{/if}

			
			{if $folders_shared && !in_array("folders", $hide_in_search)}
				<div class="row">
					<div class="row-title">{#SHOP2_SELECT_FOLDER#}:</div>
					<select class="dropdown" name="s[folder_id]" id="s[folder_id]">
						<option value="">{#SHOP2_ALL#}</option>
						{foreach from=$folders_shared item=e key=k}
							{if $e._left>1}
	                            <option value="{$e.folder_id}" {if $search_params.folder_ids[0] == $e.folder_id || $search_params.folder_id == $e.folder_id}selected="selected"{/if}>
	                                {section name=foo loop=`$e._level-1`}&raquo;{/section} {$e.folder_name}
	                            </option>
	                        {/if}
						{/foreach}
					</select>
				</div>

				<div id="shop2_search_custom_fields"></div>
			{/if}

			{if $shop2.global_params && !in_array("globals", $hide_in_search)}
			<div id="shop2_search_global_fields">
				{include file="global:shop2.v2-search-form-custom-fields.tpl" data=$shop2.global_params}
			</div>
			{/if}
			
			{if $vendors_shared && !in_array("vendors", $hide_in_search)}
				<div class="row">
					<div class="row-title">{#SHOP2_VENDOR#}:</div>
					<select class="dropdown" name="s[vendor_id]">
						<option value="">{#SHOP2_ALL#}</option>          
	                    {foreach from=$vendors_shared item=e}
	                        <option value="{$e.vendor_id}" {if $search_params.vendor_id == $e.vendor_id}selected="selected"{/if}>{$e.name}</option>
	                    {/foreach}
					</select>
				</div>
			{/if}

			{if !in_array("new", $hide_in_search)}
				<div class="row">
					<div class="row-title">{#SHOP2_NEW#}:</div>
					<select class="dropdown" name="s[new]">
						<option value=""{if $search_params.new === ''} selected="selected"{/if}>{#SHOP2_ALL#}</option>
	                    <option value="1"{if $search_params.new === '1'} selected="selected"{/if}>{#SHOP2_YES#}</option>
	                    <option value="0"{if $search_params.new === '0'} selected="selected"{/if}>{#SHOP2_NO#}</option>
					</select>
				</div>
			{/if}

			{if !in_array("special", $hide_in_search)}
				<div class="row">
					<div class="row-title">{#SHOP2_SPECIAL#}:</div>
					<select class="dropdown" name="s[special]">
						<option value=""{if $search_params.special === ''} selected="selected"{/if}>{#SHOP2_ALL#}</option>
	                    <option value="1"{if $search_params.special === '1'} selected="selected"{/if}>{#SHOP2_YES#}</option>
	                    <option value="0"{if $search_params.special === '0'} selected="selected"{/if}>{#SHOP2_NO#}</option>
					</select>
				</div>
			{/if}

			{if !in_array("per_page", $hide_in_search)}
				<div class="row">
					<div class="row-title">{#SHOP2_RESULTS_PER_PAGE#}:</div>
					<select class="dropdown" name="s[products_per_page]">
						{assign var="cur_v" value=$search_params.products_per_page|default:$shop2.products_per_page}
			            {section name=foo start=5 loop=100 step=15}
				            {assign var="v" value=$smarty.section.foo.index}
				            <option value="{$v|escape}"{if $v == $cur_v} selected="selected"{/if}>{$v}</option>
			            {/section}
					</select>
				</div>
			{/if}

			<div class="clear-container"></div>
			<div class="row push_area">
				<button type="submit" class="search-button">{#SEARCH#}</button>
			</div>
		</form>
		<div class="clear-container"></div>
	</div>
</div><!-- Search Form -->