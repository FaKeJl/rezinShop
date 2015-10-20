{assign var="css" value=$css|default:"default"}
{assign var="js" value=$js|default:"default"}

{if $cookie}
	<script type='text/javascript' src='/shared/s3/js/cookie.js'></script>
{/if}

{if $jquery}
	<script type="text/javascript" src="/g/libs/jquery/1.10.2/jquery.min.js"></script>
{/if}

{if $reset}
	<link rel="stylesheet" type="text/css" href="/g/shop2v2/default/css/reset.less.css">
{/if}

{if $shop2_local_css}
	<link rel="stylesheet" type="text/css" href="images/css/theme.less.css">
{else}
	{if $css!="none"}<link rel="stylesheet" type="text/css" href="/g/shop2v2/{$css}/css/theme.less.css">{/if}
{/if}
<script type="text/javascript" src="/g/printme.js"></script>
<script type="text/javascript" src="/g/shop2v2/default/js/tpl.js"></script>
<script type="text/javascript" src="/g/shop2v2/default/js/baron.min.js"></script>
<script type="text/javascript" src="images/js/shop2_new.js"></script>
{strip}
<script type="text/javascript">
	shop2.init({ldelim}
		"productRefs": {json array=$product_refs},
		"apiHash": {json array=$api|default:$shop2.api},
		"verId": {$site.ver_id},
		"mode": "{$mode}",
		"step": "{$step}",
		"uri": "{$shop2.uri}",
		"IMAGES_DIR": "{$IMAGES_DIR}",
		"my": {$shop2.my|@json_encode}
	{rdelim});
	{if $folder}shop2.filter._pre_params = "&s[folder_id]={$folder.folder_id}";{/if}
	{if $vendor}shop2.filter._pre_params = "&s[vendor_id]={$vendor.vendor_id}";{/if}
</script>

	{if $shop2.thumb_width != 200 || $shop2.thumb_height != 190 || $shop2.card_image_width != 200 || $shop2.card_image_height != 190}
		{"\n"}
		<style type="text/css">
			.product-item-thumb {ldelim}
				width: {$shop2.thumb_width}px;
			{rdelim}

			.product-item-thumb .product-image, .product-item-simple .product-image {ldelim}
				height: {$shop2.thumb_height}px;
				width: {$shop2.thumb_width}px;
			{rdelim}

			.product-item-thumb .product-amount .amount-title {ldelim}
				width: {$shop2.thumb_width-96}px;
			{rdelim}

			.product-item-thumb .product-price {ldelim}
				width: {$shop2.thumb_width-50}px;
			{rdelim}

			.shop2-product .product-side-l {ldelim}
				width: {$shop2.card_image_width}px;
			{rdelim}

			.shop2-product .product-image {ldelim}
				height: {$shop2.card_image_height}px;
				width: {$shop2.card_image_width}px;
			{rdelim}

			{assign var="width" value=$shop2.card_image_width/3|string_format:"%d"}
			{assign var="width" value=$width-10}
			.shop2-product .product-thumbnails li {ldelim}
				width: {$width}px;
				height: {$width}px;
			{rdelim}
		</style>
	{/if}

{/strip}