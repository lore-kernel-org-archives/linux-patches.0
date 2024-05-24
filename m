Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8402E8626E;
	Fri, 24 May 2024 16:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716568822; cv=none; b=GDR/BL7QnccGCKy45osk3uJ5DQOU4ZDVDbDzkCiRlb1EO4adSvbvuOzQFwPAt2WjB0zBqtAMSV2ju3rzcKuo6c8WzYCOCcS4V2Cdmmh8a8hwTLsii69rCpY1PBG1l9jPovI+mQa1FD6oUNtmmrdLwx3qTH7UZ3r1ErYDLGLiFi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716568822; c=relaxed/simple;
	bh=9mvpBAnKzNAyjIz4AaURNG6HUDlSprKVfsup9+Rsh3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WrncZLqQCThTvuQZyxcBVKDTxkQp+l/QVWdHfVtiaBaCRdpX8xtX4Xm+qXc7Gg/GFrCsSDv7IwseALsohXXxFwJdsObo3pLrtbGCW3fyEIZUxDcVbn9jcZtOFuMDg0yhy8yzcuYEFr+UZlhyf3rPtVLiFqZ2z6Lt56N4FC0zXYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=lSjyQV7C; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="lSjyQV7C"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 18F2240E02A8;
	Fri, 24 May 2024 16:40:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id tm43LEE-mE5d; Fri, 24 May 2024 16:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1716568813; bh=jiaxkAzz/Wg3+OBprXDh1+W9WaBImj/HoQGusdn/co4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lSjyQV7CoZXTb+RQFBdfy8SZiBa5FhP58xrEVOvOq5su45eeCbtV8uc8W5t0yGCE0
	 GtcIJtgF3SWdypNdkTxX6o9IqvGoTE6F1eYoOYdiTHSRxBEJlBBWh15Kxzv8wXQPZE
	 rlBOAEJZke50zWDCQEjDmsBwYm66EQBdooJEqoEnHCfJqmrDHgShcXAFIvcPiJ6Ucm
	 ZievW5F/CVIfrDmVsWZyT985vBV8KaP01FZ0FEVCoD9Kq96WVm2Ku8ZublztRRToX+
	 hq2ElrwRehd8uejyTPLYe+LBiW1fiWOcXWEsAbPSbcrCtpYvdjTtmILg+7GyNiA6iZ
	 85Wy1/sSAUmNdfCiz+swD8hC3btor5aPpF5TlVhLMsqtP4htLUAW2fbDxaZ/zYLQIP
	 Nxtzf4EZrCrQyE3JnoxHRMC7klma0PVLb27CIQKjJYBHwm0OxdJPiczv7P3bVdmyCV
	 1NHG8f8h0Vb5T0q/U6irqgQrlQQGMZ6iey9aCIA0Cu4shRWUZPywyiy6jyLuy+g+Qm
	 Wb5wySme+TjQ6VbR6bGpyYIeE4ZSyWv6IXYPlm+nycKRUnsQJxcsJoA/TrRkBME/5z
	 CX71Fv5nuHWqxw/zvo0zZBu8hDRrn/0ZWkVIbAK/OL7CL7pePffHTwD46RO5Y+ZjvG
	 bd0u23XM4fIc5GEqCVXkvcYo=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9C4BD40E016A;
	Fri, 24 May 2024 16:40:01 +0000 (UTC)
Date: Fri, 24 May 2024 18:39:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] x86/boot: Address clang -Wimplicit-fallthrough in
 vsprintf()
Message-ID: <20240524163956.GBZlDC3DH_OqvAjSBC@fat_crate.local>
References: <20240516-x86-boot-fix-clang-implicit-fallthrough-v1-1-04dc320ca07c@kernel.org>
 <20240517095110.GAZkcojmJQoY_zU-OT@fat_crate.local>
 <20240517151833.GB3660288@thelio-3990X>
 <20240523115734.GAZk8vLgzOzD8Tv9pq@fat_crate.local>
 <202405231603.2E810E3FC@keescook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202405231603.2E810E3FC@keescook>

On Thu, May 23, 2024 at 04:12:25PM -0700, Kees Cook wrote:
> There isn't a bug _here_, but this is about making the code unambiguous
> everywhere in the kernel. We've already done the work to get rid of
> all these warnings; this one is newly introduced, so let's get it fixed.

Nah, it has been there since forever (forever == 2007 in this case). It
fires because I enabled the warning in the decompressor.

> We don't want to have the same flow-control statement reachable from two
> different "case"s where the resulting behaviors are different. Otherwise
> we can't determine if a "fallthrough" is missing or intentional.

I'd agree if this warning wasn't enabled by default but were a W=123...
diagnostic thing which does the additional checks. But right now clang
is warning for a perfectly valid, albeit a bit confusing C.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
