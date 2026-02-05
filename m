Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AA83EFD3F
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 14:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770301705; cv=none; b=Xi90usLAUz3oPWSzkQCy6IUI//paIC02vJYnhDx+sRhV7MQbV4z3HEbiAZ0aYNZIsy3h2opfM7FmUKUOlbB37a7Nsy0urjBoUSJs6iW5m0xoAt3F2bHd17RLeR5dd49liVdA9vlUXhj2Ac83pF/UoQjB2tOTvkkyQJXVWJbtAEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770301705; c=relaxed/simple;
	bh=kXr4DefV73hjVoJ4U2FEAT9qvrXlt/HpysOqsndr9DE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5H/hECPHkRwy6OCmITKAiJ5Ps/S0HCb6rn343KAM03A6a1fJyYrWOFuCS5JfTDZC4rPsuHfZRA4PxOLtGI7+4zDG4kjlOpGIISZ5Isan94eNVcVi+VwbP1rHtub14yJlz7SAgzgNRCGM3dsOurR9cnhE0gYdGdaQfoKId3kiFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hL5JK9sW; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hL5JK9sW"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a9057b2ec3so5388235ad.2
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 06:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770301704; x=1770906504; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jfAPA65QHaIhPMggaE3tVaDFtRc+AOhln1aXEIRSpVo=;
        b=hL5JK9sWUi2vuH5XYBFEcC/2aoXlLtCeVw/fIqcdSEWwIvr25wSMZQo9VvMUJjOW5q
         l2eIT0wO+F/hHgmHoeZYIuEId9tHU3fhgYJu4MubAPKMZ8o4T7TgbpJdUUuqYn5ZrpE5
         alVvkxPl1EBGrKQc3e1CYyDalEIBxaIlrcake/ygmmABXno/oHv1zO8097anTShzKVNV
         Inhqs2wnIFrlK4O2SJOUUT9fCSqBhtSudLFmHbUq3HsPf0TyA+M8UDrtn5Ws51eOOJrM
         xv1fzu9sOFAnRBolGPkeV4w5OFB4WdYaECuKScfNEGWshaRX4lRdsBq1hkpFjcaYICkj
         9BRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770301704; x=1770906504;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jfAPA65QHaIhPMggaE3tVaDFtRc+AOhln1aXEIRSpVo=;
        b=rXXwXhH2dlHoyjoIMZoMObABcGXCoxcmm61pNE+c96LAiBau0TcFj8+Ib/LZB4AQv1
         6K52HQghqNul9BNOq7AAcnhS3HVuwNIf9NpWHlTK3HzoKPgSsCUsYdqfVpPyZSJl6LBJ
         0L9zu9+1LQ8BzZjHlkccGW/sB87tw1vJf7oSSJOuWb0ClzITgMi8E9g4MC8piwM/ui+x
         MZfBYAOZ5ZsR1tZP04toDtP5jAwn4FlZWFjMXf2vR80FEorCJSGM3gQEikwqlI/M65Ud
         QMi4N317Bl3c41i6WcEYzZoqDfpggEEzf7xH+/If/KNdw7oJWHTX3QDyQtb751wuKJ2M
         5nSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVda376SUNZDzuGE/rDTLO/ty2JZXqSGcgSil4jztQL2miOPZGrC1m/GlkN8S9z8iTNGb+SdrZp@lists.linux.dev
X-Gm-Message-State: AOJu0YzepYw5y1lZ1Ov/PkZTvAbeuK7AtpX79hwOR1Mkk7YH77mDKF4G
	D3IGgz6OaN57lTzPDggWKYpBzyORSfKUJaqwI1niPrwyJDUWxwmOfJsVmM+ViMb3
X-Gm-Gg: AZuq6aK82gljLSCtMoIZDO2IE4c11zWEWwvvaGN86Z0lvRxhu/rYup8LxdaoICYqg5Y
	V7HDFd5OHmWSl+YvF3UFuC/x1T7hOAXCJ1/nlpL6bFc8RkE7sKjG7Ps2NRm67F45/ZNGuufLReq
	5uHrKKtKvoMNyDYiWA0q84H0nhU33zURwbVzmGcJ4UGpZleUjTX9DMOjMXv3CjibEV0gldV+WX6
	VI+PygWfarfUMzTPEifTjqul1D2l2USaQNrTK5X4oZbbIVEa5sbFfKFQ1iK5v9sEA1ppRIHRwNJ
	VNeP70oeYyRPMacxgmkPDGZ4HSPrXjp59YQGBjvvwN9a73BPYVLYuZFJZbWNY45fZI2p+LXx0Lj
	Vy/YBEbWp/0bcqdZNe62oEhNB9AJY1sA9il9X3IdzBW6wBq1oBYk9IFkWGUJ0y2iiD0BGQUYJDv
	AgdXZkogn0BOqwfaUBYzgx6Tfc
X-Received: by 2002:a17:903:fa7:b0:2a8:f8bd:bb72 with SMTP id d9443c01a7336-2a933fa77dbmr61907135ad.50.1770301704102;
        Thu, 05 Feb 2026 06:28:24 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a93394e5e0sm56692515ad.64.2026.02.05.06.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 06:28:23 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 5 Feb 2026 06:28:22 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Daniel Palmer <daniel@thingy.jp>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH 6.12 75/87] Revert "drm/nouveau/disp: Set
 drm_mode_config_funcs.atomic_(check|commit)"
Message-ID: <5951f289-a7ef-43b1-badf-f1e7cd04c02d@roeck-us.net>
References: <20260204143846.906385641@linuxfoundation.org>
 <20260204143849.619741696@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204143849.619741696@linuxfoundation.org>

On Wed, Feb 04, 2026 at 03:41:13PM +0100, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: John Ogness <john.ogness@linutronix.de>
> 
> commit 6c65db809796717f0a96cf22f80405dbc1a31a4b upstream.

Not questioning the need for it, but this revert does not exist
in the upstream kernel ???

$ git describe
v6.19-rc8-45-gf14faaf3a1fb
$ git show 6c65db809796717f0a96cf22f80405dbc1a31a4b
fatal: bad object 6c65db809796717f0a96cf22f80405dbc1a31a4b

Guenter

> 
> This reverts commit 604826acb3f53c6648a7ee99a3914ead680ab7fb.
> 
> Apparently there is more to supporting atomic modesetting than
> providing atomic_(check|commit) callbacks. Before this revert:
> 
> WARNING: [] drivers/gpu/drm/drm_plane.c:389 at .__drm_universal_plane_init+0x13c/0x794 [drm], CPU#1: modprobe/1790
> BUG: Kernel NULL pointer dereference on read at 0x00000000
> .drm_atomic_get_plane_state+0xd4/0x210 [drm] (unreliable)
> .drm_client_modeset_commit_atomic+0xf8/0x338 [drm]
> .drm_client_modeset_commit_locked+0x80/0x260 [drm]
> .drm_client_modeset_commit+0x40/0x7c [drm]
> .__drm_fb_helper_restore_fbdev_mode_unlocked.part.0+0xfc/0x108 [drm_kms_helper]
> .drm_fb_helper_set_par+0x8c/0xb8 [drm_kms_helper]
> .fbcon_init+0x31c/0x618
> [...]
> .__drm_fb_helper_initial_config_and_unlock+0x474/0x7f4 [drm_kms_helper]
> .drm_fbdev_client_hotplug+0xb0/0x120 [drm_client_lib]
> .drm_client_register+0x88/0xe4 [drm]
> .drm_fbdev_client_setup+0x12c/0x19b4 [drm_client_lib]
> .drm_client_setup+0x15c/0x18c [drm_client_lib]
> .nouveau_drm_probe+0x19c/0x268 [nouveau]
> 
> Fixes: 604826acb3f5 ("drm/nouveau/disp: Set drm_mode_config_funcs.atomic_(check|commit)")
> Reported-by: John Ogness <john.ogness@linutronix.de>
> Closes: https://lore.kernel.org/lkml/87ldhf1prw.fsf@jogness.linutronix.de
> Signed-off-by: John Ogness <john.ogness@linutronix.de>
> Tested-by: Daniel Palmer <daniel@thingy.jp>
> Link: https://patch.msgid.link/20260130113230.2311221-1-john.ogness@linutronix.de
> Signed-off-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/nouveau/nouveau_display.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> --- a/drivers/gpu/drm/nouveau/nouveau_display.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_display.c
> @@ -391,8 +391,6 @@ nouveau_user_framebuffer_create(struct d
>  
>  static const struct drm_mode_config_funcs nouveau_mode_config_funcs = {
>  	.fb_create = nouveau_user_framebuffer_create,
> -	.atomic_commit = drm_atomic_helper_commit,
> -	.atomic_check = drm_atomic_helper_check,
>  };
>  
>  
> 
> 
