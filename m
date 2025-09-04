Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35B442050
	for <patches@lists.linux.dev>; Thu,  4 Sep 2025 19:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757015493; cv=none; b=e6/4bALN2/eeOuIXDp5CLRoCeib0UuzbAdrLxvzjOBTOEGM3ELFljHXm3/NGap2uhLZldE9XENOuMYCUW8cmfCuwz56Z/LoveBYOEyMdN1qc3pu70AAC33B0EInA7VORE9Mfn69pVnmeyLWo76GKExKJoJFw6UYXYTfaryVNjok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757015493; c=relaxed/simple;
	bh=QPZGgKSeK7OkOS6fKJFX6cxsolH+ueRXJKXsFqAwQ14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AwswUfYwA2Ebsc1gpJ33tTCGq7tFamZ0S2zQtRiPvLwOyBE5nmr9ObdgN+7Jbz9ulw/ZUleHlQdAP//zZeFRwxDrKJwkyabbTi93/oYmHU5ESldULvzKmo2P5YpsclDhAhJwLo/MKu3BiaYNmg+IJiso/sfc0ogwMBvyoxxfVgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a86HyaX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a86HyaX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B26DC4CEF4;
	Thu,  4 Sep 2025 19:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757015493;
	bh=QPZGgKSeK7OkOS6fKJFX6cxsolH+ueRXJKXsFqAwQ14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a86HyaX7buRnOcJQbTWphoKusLKadxi5a9jJw7PwpNQ3M9l3vIQHTOF0YgIW5sQiZ
	 akGp/cU1I/v/aqOIOjbUPQ7ETVtcvNJhjdsFZuJeCwO6HAkDwfzf9RVCCDsh8ZnhJv
	 Z8qz+5d1W81zu0ZtHZBoHKDCKL82XnvEPYXV3cUiCcBbCmfV2bjROl4mbId6BJBGIW
	 cJHsBp4dp0JLVtSPud4SqyJkR63SJ3qCuFMF30dhLxBxkJqss0iwzohKBXTaO3qAEm
	 9eiTa25I6ahjey24gEKievkWuymc0pN6VDRy72bvVOJ7XAm+m9K0t5HTTMr1QPzfz7
	 k2rDjhYYI+crA==
Date: Thu, 4 Sep 2025 12:51:27 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Andrzej Hajda <andrzej.hajda@intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Devarsh Thakkar <devarsht@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>
Cc: dri-devel@lists.freedesktop.org, patches@lists.linux.dev
Subject: Re: [PATCH] drm/bridge: cdns-dsi: Select VIDEOMODE_HELPERS
Message-ID: <20250904195127.GA4160085@ax162>
References: <20250821-cdns-videohelpers-v1-1-853e021908cf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821-cdns-videohelpers-v1-1-853e021908cf@kernel.org>

Gentle ping, this seems fairly obvious and it continues to break out
builds in -next.

On Thu, Aug 21, 2025 at 01:52:12PM -0700, Nathan Chancellor wrote:
> When no other driver selects CONFIG_VIDEOMODE_HELPERS but
> CONFIG_DRM_CDNS_DSI is enabled, there is a linker or modpost error:
> 
>   ERROR: modpost: "drm_display_mode_to_videomode" [drivers/gpu/drm/bridge/cadence/cdns-dsi.ko] undefined!
> 
> Select VIDEOMODE_HELPERS to ensure that this helper function is
> available to the driver.
> 
> Fixes: ce4bc5ca7c1d ("drm/bridge: cdns-dsi: Use video mode and clean up cdns_dsi_mode2cfg()")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/bridge/cadence/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/bridge/cadence/Kconfig b/drivers/gpu/drm/bridge/cadence/Kconfig
> index cced81633ddc..f1d8a8a151d8 100644
> --- a/drivers/gpu/drm/bridge/cadence/Kconfig
> +++ b/drivers/gpu/drm/bridge/cadence/Kconfig
> @@ -6,6 +6,7 @@ config DRM_CDNS_DSI
>  	select DRM_PANEL_BRIDGE
>  	select GENERIC_PHY
>  	select GENERIC_PHY_MIPI_DPHY
> +	select VIDEOMODE_HELPERS
>  	depends on OF
>  	help
>  	  Support Cadence DPI to DSI bridge. This is an internal
> 
> ---
> base-commit: 3f13bcc886fc034113cb75cb32b8d9db1216b846
> change-id: 20250821-cdns-videohelpers-71182a6145bc
> 
> Best regards,
> --  
> Nathan Chancellor <nathan@kernel.org>
> 
