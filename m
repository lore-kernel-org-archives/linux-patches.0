Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E441336EC7;
	Mon,  2 Feb 2026 22:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770070464; cv=none; b=B+nf0pRghLqhN6ys0PjHw4BGzazCy9G5H8AECPrjzxDDIuTbYK7ya3hDm48fsMaYIy9WjcKKBzp6NzpOs332PsTTFH+PrAwM1TpdWj0wKJTi0E0tIG7HAqkOpPes8QvLZQeo6ZiWH0ObyDtV2aryR0Ceuzb8Iooo9Yh38QkyPOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770070464; c=relaxed/simple;
	bh=sO5KPNQ8TrkL4sJvZKSQZoiBVi33bIgn3j10AQb7f2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KWiWe3vBnGr8fPW36OOBIwGbX35BlU3DRkJCTLOjT1nd7OT4+81+wsRFiRF+Tqe/QIPFB1rRZE9sup7t1T3X0eY/LSK7n+Mkf8DLMq6OuTg8nmzBuAoJ+EieD/GikxCU/jb3ER8EB/0X0bcLXoBWHPSABPMKpEfpPQuIZmxZGz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VX+E3OSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VX+E3OSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA797C116C6;
	Mon,  2 Feb 2026 22:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770070464;
	bh=sO5KPNQ8TrkL4sJvZKSQZoiBVi33bIgn3j10AQb7f2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VX+E3OShKLDfDhSRpROGEgofypRa6ipIYNLJdS/bzT5kMqki+Sq5mceA5k1fl/VyV
	 yQhBEwL6VBTGZLaauoINn8ZDSGaBZuJdD5SwJcfbgasAYeWb8GLpOMxf1EBORTS0B1
	 IheeKPPBg4W9Nw3sIT8oGKlX3JCMrk4Fo2M5Z+DwQxYxKxnW9XDYgwEwOyeezk4Gxt
	 ENNHPD6PY7odbG+OI/lpKTa/SuowlfdGtkFUWg1h0rfUfcRJIMJqHX7dS09Vx9as6X
	 QqziNEjvLjzp6h/c9sKuQksuU3qNpXX4SXZUfrU7GDvEKIjbKJqgQgioCPM6IjcP0F
	 uRcR63eTdYfFA==
Date: Mon, 2 Feb 2026 15:14:19 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Neil Armstrong <neil.armstrong@linaro.org>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	Langyan Ye <yelangyan@huaqin.corp-partner.google.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	dri-devel@lists.freedesktop.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] drm/panel: ilitek-ili9882t: Remove duplicate
 initializers in tianma_il79900a_dsc
Message-ID: <20260202221419.GA229639@ax162>
References: <20260114-panel-ilitek-ili9882t-fix-override-init-v1-1-1d69a2b096df@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114-panel-ilitek-ili9882t-fix-override-init-v1-1-1d69a2b096df@kernel.org>

Ping? This is still breaking builds and we are about to be in the merge
window...

On Wed, Jan 14, 2026 at 01:43:31PM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y / W=e):
> 
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:95:16: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
>      95 |         .vbr_enable = 0,
>         |                       ^
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:90:16: note: previous initialization is here
>      90 |         .vbr_enable = false,
>         |                       ^~~~~
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:97:19: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
>      97 |         .rc_model_size = DSC_RC_MODEL_SIZE_CONST,
>         |                          ^~~~~~~~~~~~~~~~~~~~~~~
>   include/drm/display/drm_dsc.h:22:38: note: expanded from macro 'DSC_RC_MODEL_SIZE_CONST'
>      22 | #define DSC_RC_MODEL_SIZE_CONST             8192
>         |                                             ^~~~
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:91:19: note: previous initialization is here
>      91 |         .rc_model_size = DSC_RC_MODEL_SIZE_CONST,
>         |                          ^~~~~~~~~~~~~~~~~~~~~~~
>   include/drm/display/drm_dsc.h:22:38: note: expanded from macro 'DSC_RC_MODEL_SIZE_CONST'
>      22 | #define DSC_RC_MODEL_SIZE_CONST             8192
>         |                                             ^~~~
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:132:25: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
>     132 |         .initial_scale_value = 32,
>         |                                ^~
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:126:25: note: previous initialization is here
>     126 |         .initial_scale_value = 32,
>         |                                ^~
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:133:20: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
>     133 |         .nfl_bpg_offset = 3511,
>         |                           ^~~~
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:108:20: note: previous initialization is here
>     108 |         .nfl_bpg_offset = 1402,
>         |                           ^~~~
> 
> GCC would warn about this in the same manner but its version,
> -Woverride-init, is disabled for a normal kernel build in
> scripts/Makefile.warn. For clang, -Wextra in drivers/gpu/drm/Makefile
> turns it back but GCC respects turning it off earlier in the command
> line.
> 
> Of all the duplicate fields in the initializer, only nfl_bpg_offset is a
> different value. Clear up the duplicate initializers, keeping the
> 'false' value for .vbr_enable, as it is bool, and the second value for
> .nfl_bpg_offset, assuming it is the correct one since it was the one
> tested in the original change.
> 
> Fixes: 65ce1f5834e9 ("drm/panel: ilitek-ili9882t: Switch Tianma TL121BVMS07 to DSC 120Hz mode")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/panel/panel-ilitek-ili9882t.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c b/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
> index 370424ddfc80..8b2bfb7d3638 100644
> --- a/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
> +++ b/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
> @@ -88,11 +88,9 @@ static const struct drm_dsc_config tianma_il79900a_dsc = {
>  	.native_422 = false,
>  	.simple_422 = false,
>  	.vbr_enable = false,
> -	.rc_model_size = DSC_RC_MODEL_SIZE_CONST,
>  	.pic_width = 1600,
>  	.pic_height = 2560,
>  	.convert_rgb = 0,
> -	.vbr_enable = 0,
>  	.rc_buf_thresh = {14, 28, 42, 56, 70, 84, 98, 105, 112, 119, 121, 123, 125, 126},
>  	.rc_model_size = DSC_RC_MODEL_SIZE_CONST,
>  	.rc_edge_factor = DSC_RC_EDGE_FACTOR_CONST,
> @@ -105,7 +103,6 @@ static const struct drm_dsc_config tianma_il79900a_dsc = {
>  	.initial_offset = 6144,
>  	.rc_quant_incr_limit0 = 11,
>  	.rc_quant_incr_limit1 = 11,
> -	.nfl_bpg_offset = 1402,
>  	.rc_range_params = {
>  		{ 0,  4, DSC_BPG_OFFSET(2)},
>  		{ 0,  4, DSC_BPG_OFFSET(0)},
> @@ -123,7 +120,6 @@ static const struct drm_dsc_config tianma_il79900a_dsc = {
>  		{ 9, 12, DSC_BPG_OFFSET(-12)},
>  		{12, 13, DSC_BPG_OFFSET(-12)},
>  	},
> -	.initial_scale_value = 32,
>  	.slice_chunk_size = 800,
>  	.initial_dec_delay = 657,
>  	.final_offset = 4320,
> 
> ---
> base-commit: b36178488d479e9a53bbef2b01280378b5586e60
> change-id: 20260114-panel-ilitek-ili9882t-fix-override-init-21e19143f770
> 
> Best regards,
> --  
> Nathan Chancellor <nathan@kernel.org>
> 
