{if $shop2.view=="thumbs"}
    {include file="global:shop2.v2-product-list-thumbs.tpl" meta=$meta}
{elseif $shop2.view=="simple"}
    {include file="global:shop2.v2-product-list-simple.tpl" meta=$meta}
{else}
    {include file="global:shop2.v2-product-list-price.tpl" meta=$meta}
{/if}