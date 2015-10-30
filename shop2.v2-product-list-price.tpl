{assign var="show_price" value=0}
{if !(!$user && $shop2.my.hide_prices_non_reg)}
    {assign var="show_price" value=1}
{/if}


<form class="shop2-product-item tr" method="post" action="{$shop2.uri}?mode=cart&amp;action=add" accept-charset="utf-8">

    <div class="td column-name">
        <input type="hidden" name="kind_id" value="{$product.kind_id}" />
        <input type="hidden" name="product_id" value="{$product.product_id}" />
        <input type="hidden" name="meta" value="{$product.meta|@json_encode|escape}" />

        {if $product.new || $product.special}
            <div class="product-label">
                {if $product.new}<div class="product-new">NEW</div>{/if}
                {if $product.special}<div class="product-spec">SPECIAL</div>{/if}
            </div>
        {/if}

        <div class="product-wrapping">
            <div class="product-name">
                <a href="{get_seo_url uri_prefix=$shop2.uri mode="product" alias=$product.alias}">{$product.name}</a> 
                {if $shop2.my.show_product_unit && $product.params.unit}({$product.params.unit}){/if}
            </div>
            
            {include file="global:shop2.v2-product-article.tpl"}

            {*include file="global:shop2.v2-rating.tpl"*}
        </div>
        {if $show_price}
            {include file="global:shop2.v2-product-actions.tpl"}
        {/if}
    </div>
    
    {include file="global:shop2.v2-product-article.tpl" is_column=true}

    {if $shop2.my.pricelist_vendor_in_column}
        <div class="td column-vendor">
            {$product.vendor_name|default:#SHOP2_NOT_SPECIFIED#}
        </div>
    {/if}

    {if !$shop2.my.pricelist_hide_options}
        <div class="td column-options">
            {if $shop2.my.pricelist_options_toggle}
               <a class="shop2-options-btn" href="#" data-alt="{$shop2.my.pricelist_options_hide_alias|htmlspecialchars|default:#SHOP2_HIDE_PARAMETERS#}">
                    {$shop2.my.pricelist_options_show_alias|default:#SHOP2_SHOW_PARAMETERS#}
               </a> 
            {/if}
            
            {include file="global:shop2.v2-product-options.tpl" meta=$meta}

        </div>
    {/if}
    
    {if $show_price}
        <div class="td column-price">
            {include file="global:shop2.v2-product-price-old.tpl"}
            {include file="global:shop2.v2-product-price.tpl" obj=$product}
        </div>
        
        {include file="global:shop2.v2-amount-btn.tpl" class="td column-amount" hideCaption=true}

        {if !$shop2.my.mode_catalog}
            <div class="td column-add">
                {include file="global:shop2.v2-buy-btn.tpl" type=2}
            </div>
        {/if}
    {/if}

</form>