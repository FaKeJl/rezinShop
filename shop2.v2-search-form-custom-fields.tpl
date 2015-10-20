	{if !$data}
	{assign var="data" value=$custom_fields}
{/if}

{if $data}
	{foreach from=$data name=foo item=e key=k}
		{if $e.in_search}

			{capture assign="field"}
				{if $e.type == 'textarea' || $e.type == 'text' || $e.type == 'int' || $e.type == 'float'}
					
					<div class="row">
						{assign var="cls" value=""}
						
						{if $e.type == 'int' || $e._sph_type == 'int'}
							{assign var="cls" value="shop2-input-int"}
						{elseif $e.type == 'float' || $e._sph_type == 'float'}
							{assign var="cls" value="shop2-input-float"}
						{/if}

						{if $e.range}
							<div class="row-title">{$e.name}{if $e.unit} ({$e.unit}){/if}:</div>
							<label><span>{#SHOP2_FROM#}</span>&nbsp;<input name="s[{$e._sph_name}][min]" type="text" size="5" class="small {$cls}" value="{$smarty.get.s[$e._sph_name].min|escape|default:''}" /></label>
							&nbsp;
							<label><span>{#SHOP2_TO#}</span>&nbsp;<input name="s[{$e._sph_name}][max]" type="text" size="5" class="small {$cls}" value="{$smarty.get.s[$e._sph_name].max|escape|default:''}" /></label>
						{else}
							<label class="row-title">{$e.name}{if $e.unit} ({$e.unit}){/if}:</label>
							<input type="text" name="s[{$e._sph_name}]" size="20" {if $cls}class="{$cls}"{/if} value="{$smarty.get.s[$e._sph_name]|escape|default:''}" />
						{/if}
					</div>

				{elseif $e.type == 'select' || $e.type == 'multiselect'}
					<div class="row">
						<div class="row-title">{$e.name}:</div>
						<select class="dropdown" name="s[{$e._sph_name}]">
							<option value="">{#SHOP2_ALL#}</option>
							{foreach from=$e.options item=i key=j}
								<option value="{$j|escape}"{if $j == $smarty.get.s[$e._sph_name]} selected="selected"{/if}>{$i}</option>
							{/foreach}
						</select>
					</div>
				{elseif $e.type == 'checkbox'}
					<div class="row">
						<label class="row-title">
							<input type="checkbox" name="s[{$e._sph_name}]" value="1" {if $smarty.get.s[$e._sph_name]}checked="checked"{/if}> {$e.name}
						</label>
					</div>
				{elseif $e.type == 'color_ref'}
					<div class="row">
						<div class="row-title">{$e.name}:</div>
						{include file="global:shop2.v2-color-ext.tpl" location="search"}
					</div>
				{/if}
			{/capture}

			{$field}

		{/if}
	{/foreach}
{/if}