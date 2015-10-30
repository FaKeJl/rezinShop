{capture assign="c_vendor"}{strip}
	{if !$shop2.my.hide_vendor_in_list || $mode == 'product'}

		{if $product.vendor_name}
			<div class="row_options">
				<div class="row_title">{$shop2.my.vendor_alias|default:#SHOP2_VENDOR#}:</div>
				<div class="row_body">
					{if !$shop2.my.hide_vendor_name}
						<a href="{get_seo_url uri_prefix=$shop2.uri mode="vendor" alias=$product.vendor_alias}">{$product.vendor_name}</a>
					{/if}
					
					{if $product.vendor_filename && $shop2.my.show_vendor_image}
						<div class="shop2-vendor">
							<a href="{get_seo_url uri_prefix=$shop2.uri mode="vendor" alias=$product.vendor_alias}">
								{assign var="width" value=$shop2.my.vendor_image_width|default:80}
								{assign var="height" value=$shop2.my.vendor_image_height|default:40}
								<img src="{s3_img src=$product.vendor_filename width=$width height=$height method="r"}" alt="{$product.vendor_name}" />
							</a>
						</div>
					{/if}
				</div>
			</div>
		{/if}

	{/if}
{/strip}{/capture}

{if $shop2.my.hide_options_in_list && $mode != 'product'}
	
	{*не показываем параметры в списке, но мультиселекты с not_mod там должны быть - чтобы параметр добавлялся в корзину*}
	{if $product_refs[$product.product_id] && $meta}
		{foreach from=$product_refs[$product.product_id] item=o_values key=o_name}
			{assign var="option" value=$meta.$o_name}
			{if $option.in_card}
				{if $option.type == 'multiselect'}
					{assign var="values" value=$product.meta[$o_name]}
					{if $values}
						{assign var="all_values" value=$meta.$o_name.options}
						{if $option.not_mod}
							{foreach from=$values item=value key=k name=foo}
								{if $smarty.foreach.foo.first}
									<input type="hidden" name="{$o_name}" class="additional-cart-params" value="{$option.name}: {$all_values.$value}">
								{/if}
							{/foreach}
						{/if}
					{/if}
				{/if}
			{/if}
		{/foreach}
	{/if}

	{if $c_vendor}
		<div class="shop2-product-options">{$c_vendor}</div>
	{/if}

{else} {*-----------------------------------------------------------------------------------------*}

	{capture assign="c_options"}{strip}
		
		{$c_vendor}

		{include file="global:shop2.v2-product-compare-btn.tpl"}

		{if $product_refs[$product.product_id] && $meta}
			{foreach from=$product_refs[$product.product_id] item=o_values key=o_name}
				{assign var="option" value=$meta.$o_name}

				{if $option.type != 'html' && (($mode == 'product' && $option.in_detail) || ($mode != 'product' && $option.in_list))}
				<div class="row_options {cycle values="odd,even"}{if $option.type == 'color'} type-color{elseif $option.type == 'image2'} type-texture{elseif $option.type == 'select'} type-select{/if}">
					{if $option.type == 'color'}
		
						{* цвет ------------------------------- *}
						{if $o_values}
							
								<div class="row_title">{$option.name}</div>
								<div class="row_body">
									<ul class="shop2-color-pick">
										{foreach from=$o_values item=o_kinds key=o_color}
											<li data-kinds="{','|implode:$o_kinds}" data-name="{$o_name}" data-value="{$o_color|escape}" class="{if $o_color==$product.meta[$o_name]}active-color{/if} shop2-cf">
												<span style="background-color: {$o_color};">&nbsp;</span>
											</li>
										{/foreach}
									</ul>
								</div>
							
						{/if}
						{* /----------------------------------- *}
					
					{elseif $option.type=='select'}

						{* список ----------------------------- *}
						{if $o_values}
							{assign var="all_values" value=$meta.$o_name.options}
							{assign var="value" value=$product.meta[$o_name]}
							{if $o_values|@count == 1}
								{* одно значение *}
								{*assign var="kind_id" value=$o_values.$value.0}
								{if $kind_id == $product.kind_id && $value*}
								{if $value}
									
										<div class="row_title">{$option.name}</div>
										<div class="row_body">{$all_values.$value}</div>
									
								{/if}
								{* /------------ *}
							{else}
								{* больше *}
								
									<div class="row_title">{$option.name}</div>
									<div class="row_body">
										<select name="cf_{$o_name}" class="dropdown shop2-cf">
											{foreach from=$o_values item=o_kinds key=o_value}
												<option  value="{$o_value}" data-name="{$o_name}" data-value="{$o_value}" data-kinds="{','|implode:$o_kinds}" {if $value==$o_value}selected="selected"{/if}>{$all_values.$o_value}</option>
											{/foreach}
										</select>
									</div>
								
								{* /------------ *}
							{/if}
						{/if}
						{* /----------------------------------- *}
					

					{elseif $option.type == 'multiselect'}

						{* мультиселект --------------------------- *}
						{assign var="values" value=$product.meta[$o_name]}
						{if $values}
							{assign var="all_values" value=$meta.$o_name.options}
							
								<div class="row_title">{$option.name}</div>
								<div class="row_body">
									{if $option.not_mod}
										{* без модификаций *}
											<select name="{$o_name}" class="dropdown additional-cart-params">
												{foreach from=$values item=value key=k name=foo}
												<option value="{$option.name}: {$all_values.$value}">{$all_values.$value}</option>
												{/foreach}
											</select>										
										{* /-------------- *}
									{else}
										{foreach from=$values item=value key=k name=foo}
											{$all_values.$value}
											{if !$smarty.foreach.foo.last}, {/if}
										{/foreach}
									{/if}
								</div>
							
							{/if}
						{* /----------------------------------- *}
					

					{elseif $option.type == 'file2'}

						{* файл ------------------------------- *}
						{assign var="filename" value=$product.meta[$o_name].filename}
						{if $filename}
					
							<div class="row_title">{$option.name}</div>
							<div class="row_body">
								<a href="{$FILES_DIR}{$filename}" class="file"><span class="icon"></span>{#SHOP2_DOWNLOAD#}</a>
							</div>
					
						{/if}
						{* /----------------------------------- *}

					{elseif $option.type == 'image2'}

						{* картинка --------------------------- *}
						{capture assign="images"}{strip}
							{foreach from=$o_values item=o_kinds key=o_value}
								{if $o_value && $cf_images.$o_value}
									<li data-kinds="{','|implode:$o_kinds}" data-name="{$o_name}" data-value="{$o_value|escape}" class="{if $o_value == $product.meta[$o_name].image_id}active-texture{/if} shop2-cf">
										<img src="{s3_img width=30 height=30 src=$cf_images.$o_value method=$shop2.my.s3_img_method}" alt="{$option.name}" />
									</li>
								{/if}
							{/foreach}
						{/strip}{/capture}
						
						{if $images}
						
							<div class="row_title">{$option.name}</div>
							<div class="row_body">
								<ul class="shop2-texture-pick">
									{$images}
								</ul>
							</div>
						
						{/if}
						{* /----------------------------------- *}

					{elseif $option.type == 'textarea'}

						{* текст --------------------------- *}
						{assign var="text" value=$product.meta[$o_name]}
						{if $text || $text === '0'}
						
							<div class="row_title">{$option.name}</div>
							<div class="row_body">
								{$text}
							</div>
						
						{/if}
						{* /----------------------------------- *}

					{elseif $option.type == 'checkbox'}

						{* галочка --------------------------- *}
						{assign var="checked" value=$product.meta[$o_name]}
						{if $checked}
							<div class="row_title">{$option.name}</div>
							<div class="row_body">
								{if $checked}{#SHOP2_YES#}{else}{#SHOP2_NO#}{/if}
							</div>
						{/if}
						{* /----------------------------------- *}

					{elseif $option.type == 'text' || $option.type=='int' || $option.type=='float'}
						
						{* строка или число ------------------ *}
						{if $product.meta[$o_name] || $product.meta[$o_name] === '0'}
							
								<div class="row_title">{$option.name}</div>
								<div class="row_body">{$product.meta[$o_name]} {$option.unit}</div>
							
						{/if}
						{* /---------------------------------- *}

					{elseif $option.type == 'color_ref' || $option.type == 'color2'}
						
						{assign var="values" value=$product.meta[$o_name]}

						{if $values|@count}
							<div class="row_title">{$option.name}</div>
							<div class="row_body">
								{include file="global:shop2.v2-color-ext.tpl" location="product"}
							</div>
						{/if}

					{/if}
					</div>
				{/if}
			{/foreach}
		{/if}
	{/strip}{/capture}
	
	{if $c_options}
		<div class="shop2-product-options">{$c_options}</div>
	{/if}

{/if}