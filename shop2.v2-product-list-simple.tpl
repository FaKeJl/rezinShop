{assign var="show_price" value=0}
{if !(!$user && $shop2.my.hide_prices_non_reg)}
    {assign var="show_price" value=1}
{/if}

<form 
    method="post" 
    action="{$shop2.uri}?mode=cart&amp;action=add" 
    accept-charset="utf-8" 
    class="shop2-product-item product-item-simple">

    <input type="hidden" name="kind_id" value="{$product.kind_id}" />
    <input type="hidden" name="product_id" value="{$product.product_id}" />
    <input type="hidden" name="meta" value='{$product.meta|@json_encode|htmlspecialchars}'/>

    <div class="shop2-clear-container"></div>
    <div class="product-side-l">
        <div class="product-image{if !$product.image_filename} no-image{/if}">
            {if $product.image_filename}
                <a href="{get_seo_url uri_prefix=$shop2.uri mode="product" alias=$product.alias}">
                    <img src="{s3_img width=$shop2.thumb_width height=$shop2.thumb_height src=$product.image_filename method=$shop2.my.s3_img_method}" alt="{$product.name|htmlspecialchars}" title="{$product.name|htmlspecialchars}" />
                </a>
                <div class="verticalMiddle"></div>
            {/if}
        </div>
        {if $product.new || $product.special}
        <div class="product-label">
            {if $product.special}<div class="product-spec">{$shop2.my.special_alias|default:#SHOP2_SPECIAL#}</div>{/if}
            {if $product.new}<div class="product-new">{$shop2.my.new_alias|default:#SHOP2_NEW#}</div>{/if}
        </div>
        {/if}

        {include file="global:shop2.v2-rating.tpl"}
    </div>
    
    {if $show_price}
        <div class="product-side-r">
            {include file="global:shop2.v2-product-actions.tpl"}
            {include file="global:shop2.v2-amount-btn.tpl" class="product-amount"}
            
            <div class="product-price">
                {include file="global:shop2.v2-product-price-old.tpl"}
                {include file="global:shop2.v2-product-price.tpl" obj=$product}
            </div>
            {include file="global:shop2.v2-buy-btn.tpl" type=3}
        </div>
    {/if}

    <div class="product-side-c">
        <div class="product-name"><a href="{get_seo_url uri_prefix=$shop2.uri mode="product" alias=$product.alias}">{$product.name}</a></div>
        
        {include file="global:shop2.v2-product-article.tpl"}

        {if $product.note}
            <div class="product-anonce">
                {$product.note|nl2br}
            </div>
        {/if}
        {include file="global:shop2.v2-product-options.tpl" meta=$meta}
    </div>
    <div class="shop2-clear-container"></div>
</form>