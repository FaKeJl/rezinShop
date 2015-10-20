{capture assign="params"}{strip}
	{foreach from=$fields item=param}
		{if $param._sph_filter}
			{assign var="name" value=$param.name|regex_replace:"/\s/":"&nbsp;"}

			{if $param.type == 'int' || $param.type == 'float'}
				<div class="shop2-filter-fields row_wrap">
					<div class="field_title">{$name}:</div>
					<div class="range_slider_wrapper">
						{assign var="class" value='shop2-input-float'}
						{if $param.type == 'int'}
							{assign var="class" value='shop2-input-int'}
						{/if}

						{if $param.range}
							<label class="left-s">
								<span>{#SHOP2_FROM#}</span>&nbsp;<input class="{$class} noUi-slider__low" type="text" value="{$smarty.get.s[$param._sph_name].min|htmlspecialchars}" name="s[{$param._sph_name}][min]" />
							</label>
							<label class="right-s">
								<span>{#SHOP2_TO#}</span>&nbsp;<input class="{$class} noUi-slider__hight" type="text" value="{$smarty.get.s[$param._sph_name].max|htmlspecialchars}" name="s[{$param._sph_name}][max]" />
							</label>
							<div class="clear"></div>
							<div style="margin-bottom: 0;" class="range_slider"></div>

						{else}
							<label class="left-s">
								<input class="{$class}" type="text" value="{$smarty.get.s[$param._sph_name]|htmlspecialchars}" name="s[{$param._sph_name}]" />
							</label>
						{/if}

						{if $param.unit}
							<div style="text-align: center; font-size: 10px;">{$param.unit}</div>
						{/if}
					</div>
				</div>
			
			{elseif $param.type == 'checkbox'}
				<div class="shop2-filter-fields row_wrap">
					<div class="field_title">{$name}:</div>
					<div class="field_body">
						<a href="#" data-name="s[{$param._sph_name}][1]" data-value="1" class="param-val{if $smarty.get.s[$param._sph_name].1==1} active-val{/if}">{#SHOP2_YES#}<span>&nbsp;</span></a>
						<a href="#" data-name="s[{$param._sph_name}][0]" data-value="0" class="param-val{if $smarty.get.s[$param._sph_name].0==0 && isset($smarty.get.s[$param._sph_name].0)} active-val{/if}">{#SHOP2_NO#}<span>&nbsp;</span></a>
					</div>
				</div>
			
			{elseif $param.type == 'multiselect' || $param.type == 'select'}

				{assign var="count" value=$param.options|@count}

				{if $count}
					{if $count > $min_count_in_select}
						<div class="shop2-filter-fields type-select row_wrap">
							<div class="field_title">{$name}:</div>
							<div class="field_body">
								<select name="s[{$param._sph_name}]">
									<option value="">{#SHOP2_ALL#}</option>
									{foreach from=$param.options item=option key=k}
										<option {if $smarty.get.s[$param._sph_name]==$k}selected="selected"{/if} value="{$k}">{$option}</option>
									{/foreach}
								</select>
							</div>
						</div>
					{else}
						<div class="shop2-filter-fields type-select row_wrap">
							<div class="field_title">{$name}:</div>
							<div class="field_body">
								{foreach from=$param.options name=foo item=option key=k}
									{assign var="index" value=$smarty.foreach.foo.index}
									<a href="#" data-name="s[{$param._sph_name}][]" data-value="{$k}" class="param-val{if in_array($k, $smarty.get.s[$param._sph_name])} active-val{/if}">
										{$option}
										<span>&nbsp;</span>
									</a>
								{/foreach}
							</div>
						</div>
					{/if}
				{/if}

			{elseif $param.type == 'color_ref'}

				<div class="shop2-filter-fields row_wrap">
					<div class="field_title">{$name}:</div>
					<div class="field_body">
						{include file="global:shop2.v2-color-ext.tpl" location="filter"}
					</div>
				</div>

			{/if}
		{/if}
	{/foreach}
{/strip}{/capture}

{if $params && !in_array("params", $hide_in_filter)}
	{assign var="has_params" value=true}
	{assign_hash var='page.has_filter_params' value=1}
	{$params}
{/if}