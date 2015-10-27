{if !$data}
    {assign var="data" value=$shop2.products}    
{/if}

{capture assign="products"}
    {foreach from=$data key=k item=product name=foo}
        {include file="global:shop2.v2-product-list-item.tpl" meta=$custom_fields}
    {/foreach}
{/capture}

{if $data}

    {if $shop2.view=="thumbs"}
        <div class="product-list product-list-thumbs">
            {$products}
        </div>
    {elseif $shop2.view=="simple"}
        <div class="product-list">
            {$products}
        </div>
    {else}

        {capture assign="options_btn"}{strip}
            {if $shop2.my.pricelist_options_toggle_col}
                {"\n"}
                <a class="shop2-options-btn" href="#">
                    <span class="shop2-options-text" data-alt="{$shop2.my.pricelist_options_hide_col_alias|htmlspecialchars|default:#SHOP2_HIDE_PARAMETERS#}">
                        {$shop2.my.pricelist_options_show_col_alias|default:#SHOP2_SHOW_PARAMETERS#}
                    </span>
                    <span class="shop2-options-arrow"></span>
                </a>
            {/if}
        {/strip}{/capture}

        {assign var="show_price" value=0}
        {if !(!$user && $shop2.my.hide_prices_non_reg)}
            {assign var="show_price" value=1}
        {/if}

        <div class="shop2-pricelist">
            <div class="tr">
                <div class="th column-name">{$shop2.my.pricelist_column_first|default:#SHOP2_PRODUCT#}</div>
                {if $shop2.my.pricelist_article_in_column && !$shop2.my.hide_article}
                    <div class="th column-article">{$shop2.my.pricelist_article_alias|default:#SHOP2_ARTICLE#}</div>
                {/if}
                {if $shop2.my.pricelist_vendor_in_column}
                    <div class="th column-vendor">{$shop2.my.pricelist_vendor_alias|default:#SHOP2_VENDOR#}</div>
                {/if}
                {if !$shop2.my.pricelist_hide_options}
                    <div class="th column-options">{#SHOP2_OPTIONS#}{$options_btn}</div>
                {/if}
                {if $show_price}
                    <div class="th column-price">{#SHOP2_PRICE#}, {$currency.currency_shortname}</div>
                    {if !$shop2.my.mode_catalog}
                        <div class="th column-amount">{#SHOP2_QTY#}</div>
                        <div class="th column-add">&nbsp;</div>
                    {/if}
                {/if}
            </div>
            {$products}
        </div>

    {/if}
{/if}