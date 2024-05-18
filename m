Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7E25576D
	for <patches@lists.linux.dev>; Sat, 18 May 2024 20:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716065238; cv=none; b=eKr56loog7/FYhH6zQDVpqWQCJPd7lkOB9dAiEVhcTec1o064mVps1k0t64nTiYgpo15e1by/OGIGscRlKLiWrs9Ow4kFhZoP389aUHEdcn6SVZbOQep0NcB2qom5YXCIIZgugTtQ1WXACrwvtQfWuNYbgUxQG/HmqHJJNOeP+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716065238; c=relaxed/simple;
	bh=rznDBSToB52+bJsEeKmwW3jC08WdGdMMMEqdHJrwhgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jxi5TkKcdwJELJzLqI2GdcyNVHBBmFFb7HKgbwEkuR+XtNgBS42oK9UibUHv1HjIpMtRJhpR+l2hzj2gsneP1CU/xFqRkj72OQC7BV7K9kvP+lm33v1wYKfHTbX3ITDgQJEazW0LBx/y2lGM2WNmZv4Axwtug1ZkUyn/iH4a5Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=KkmKryJw; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KkmKryJw"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f082d92864so42132355ad.1
        for <patches@lists.linux.dev>; Sat, 18 May 2024 13:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1716065237; x=1716670037; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dovlYWU9/q7musU7eTyJn+RHgfUBDCCZTTuGpTV+/mk=;
        b=KkmKryJwNiHRnzhIsbdVOh+jp28h+x1+5rZ87eQQJd1+jM/ufiqbL+J2cgPv20VdYu
         xY5CTTDhWLekicuvNj52CGDXR62gQfK+OB9OJeBlPO8p0Gv18y42KXeJykwCaoImZDRQ
         7yIKDCpHWcQfiuDOed8a47qwzc0WqAOdKbdik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716065237; x=1716670037;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dovlYWU9/q7musU7eTyJn+RHgfUBDCCZTTuGpTV+/mk=;
        b=ss5ErZIMqvir6p6iwIMY/nmzdZHPEFEZec8tyIKxdMNh95Tq3+o6wGOncPnXHabIor
         XWxTfLWaYIXFHcQYC8X4IY1oyIN6yzJn173S0nEl1lh7HgPsJEUPJQ8tYNwP2XJlo//3
         WqJ8H310SnWfFZPdOCalibwZepMvbLIYsQZuXp9sjhtj6yV5IdMaN813HE0Hn5FfWeC4
         Isqr5FddtXFMsr027Ihbjo2bmSKDxkh4mu2EKstP/1UfAy7ULaau7LqwjPwrykSdqfAd
         ZDz77Opu+aMzakZBZyD8yjBunUba69YTvw2rmCvZWG/+qr4Jvi2kOZdVxXKf4EGDrXb6
         cgvg==
X-Forwarded-Encrypted: i=1; AJvYcCVnu7r8PuUdUx5/qq1QpX3tCklJ4zvH8PA1jx+f9UCIxIQ53jnVAOqvu0E7RfnjKJYGlREkRTEETX0UKJ+aUyvX4lPNezqFPw==
X-Gm-Message-State: AOJu0Yx2uDAAH5tUcVazCtvHklBz3oQ7xb8SPymCFXKexQFaJvjrsCKC
	qnz0UxpRhPnkOo3C3oOugjwxVqkonyIV8JzEYe1flERy1L6E6L7r3dP4h7/IiA==
X-Google-Smtp-Source: AGHT+IErrX7eTGQo+WffbLOh7zp6AXgmIidyVMZyBccWvtdbFOD4aNfW4ejCnUVAVRtcGXuXKO/5ng==
X-Received: by 2002:a05:6a00:1a8f:b0:6ed:caf6:6e4b with SMTP id d2e1a72fcca58-6f4e02d3473mr27469433b3a.18.1716065236358;
        Sat, 18 May 2024 13:47:16 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f6704888c1sm7725286b3a.157.2024.05.18.13.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 May 2024 13:47:15 -0700 (PDT)
Date: Sat, 18 May 2024 13:47:14 -0700
From: Kees Cook <keescook@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, linux-security-module@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH] loadpin: Prevent SECURITY_LOADPIN_ENFORCE=y without
 module decompression
Message-ID: <202405181346.901048F98@keescook>
References: <20240514224839.2526112-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240514224839.2526112-1-swboyd@chromium.org>

On Tue, May 14, 2024 at 03:48:38PM -0700, Stephen Boyd wrote:
> If modules are built compressed, and LoadPin is enforcing by default, we
> must have in-kernel module decompression enabled (MODULE_DECOMPRESS).
> Modules will fail to load without decompression built into the kernel
> because they'll be blocked by LoadPin. Add a depends on clause to
> prevent this combination.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  security/loadpin/Kconfig | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/security/loadpin/Kconfig b/security/loadpin/Kconfig
> index 6724eaba3d36..8c22171088a7 100644
> --- a/security/loadpin/Kconfig
> +++ b/security/loadpin/Kconfig
> @@ -14,6 +14,9 @@ config SECURITY_LOADPIN
>  config SECURITY_LOADPIN_ENFORCE
>  	bool "Enforce LoadPin at boot"
>  	depends on SECURITY_LOADPIN
> +	# Module compression breaks LoadPin unless modules are decompressed in
> +	# the kernel.
> +	depends on MODULE_COMPRESS_NONE || MODULE_DECOMPRESS
>  	help
>  	  If selected, LoadPin will enforce pinning at boot. If not
>  	  selected, it can be enabled at boot with the kernel parameter
> 

I've folded this change in, since loadpin also works in non-module
situations:

diff --git a/security/loadpin/Kconfig b/security/loadpin/Kconfig
index 8c22171088a7..848f8b4a6019 100644
--- a/security/loadpin/Kconfig
+++ b/security/loadpin/Kconfig
@@ -16,7 +16,7 @@ config SECURITY_LOADPIN_ENFORCE
 	depends on SECURITY_LOADPIN
 	# Module compression breaks LoadPin unless modules are decompressed in
 	# the kernel.
-	depends on MODULE_COMPRESS_NONE || MODULE_DECOMPRESS
+	depends on !MODULES || (MODULE_COMPRESS_NONE || MODULE_DECOMPRESS)
 	help
 	  If selected, LoadPin will enforce pinning at boot. If not
 	  selected, it can be enabled at boot with the kernel parameter

-- 
Kees Cook
