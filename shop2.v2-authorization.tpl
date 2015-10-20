<form method="post" class="tpl-form tpl-auth" action="{get_seo_url uri_prefix=$user_settings.link mode="login"}" method="post">
	{if !$site.settings.sef_url}<input type="hidden" name="mode" value="login" />{/if}
	
	<div class="tpl-left">
		<div class="tpl-field">
			<div class="tpl-title">{#USER_ENTER_YOUR#} {if $user_settings.login_field == 'login'}{#SHOP2_LOGIN#}{else}e-mail{/if}:</div>
			<div class="tpl-value">
				<input type="text" name="login" value="{$email}" />
			</div>
		</div>

		<div class="tpl-field">
			<div class="tpl-title">{#SHOP2_ENTER_PASSWORD#}:</div>
			<div class="tpl-value clearfix">
			<input class="pull-left" type="password" name="password" />
			<button class="tpl-button pull-right" type="submit">{#SHOP2_LOG_IN#}</button>
			</div>
		</div>

		<div class="tpl-field">
			<label class="tpl-title">
			<input type="checkbox" name="password" onclick="this.value=(this.value=='0'?'1':'0');" value="0" name="remember" />
				{#SHOP2_LOG_IN_REMEMBER#}
			</label>
		</div>
		
		{if $user_settings.registration_opened}
			<div class="tpl-field">
				<a href="{get_seo_url uri_prefix=$user_settings.link mode="register"}">{#SHOP2_REGISTRATION#}</a>
			</div>
		{/if}
	</div>

	<div class="tpl-right">
		<div class="tpl-field">
			{#SHOP2_IF_REGISTER_BUT_FORGOT_PASSWORD_MESSAGE#}
		</div>
		
		<div class="tpl-field">
			<a class="tpl-button" href="{get_seo_url uri_prefix=$user_settings.link mode="forgot_password"}">{#SHOP2_RECOVER_PASSWORD#}</a>
		</div>
	</div>
</form>