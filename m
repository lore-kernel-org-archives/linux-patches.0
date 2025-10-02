Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8CB46B5;
	Thu,  2 Oct 2025 07:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759389347; cv=none; b=g4uWRBVvqX46LL1u8ZLbafBIKKMgIkj2t0GfIMmEg5R3JGEvnojHxcJ0wEmO1EhWzln8DIJARRLckX/Ktlh2h+QxtTyubgxUdYqe4d53/z69vxj+8AZIyjG0Tl7gvtIBuUlSNSIQjbUzJTJx/oOxeTUf9ZtNcnvI1SBvOoXNwuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759389347; c=relaxed/simple;
	bh=yHg9LnQA/vyN93mYt9CFZyRHYlp6lnwRryQNbGhWdLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K4zQKJYNGi8Jef2ucrVk/62FnaXwzkqeeKjS4ie8LhOi9Nh86ohwwx0PlqvOq5UiGBK4kXfzcbOpUrt2a//EuevjE2VIRfIqL0QUNPnFvBMWv7dNMavj3Vxzy4LkLAX+bYZcYa/i2+2hfRrNlNYaXtay4fTmWX573r/U+E6TTkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCTlrWqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCTlrWqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C65C4CEF4;
	Thu,  2 Oct 2025 07:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759389347;
	bh=yHg9LnQA/vyN93mYt9CFZyRHYlp6lnwRryQNbGhWdLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VCTlrWqENwQQcmcyIqotd0Mf2ClAxV05hUsGaTOmFpkoVFoWuV5BRHaJGTjy68hGB
	 sViisERTFATT3dQrDO72zzxjQ8Z6syMpPBhQTj06CQnPyae6dmqOuBU6B9gP5mIvJO
	 mCqUnMkEip+hY5cHEP/xdxtYiROk/HwrJ8XeI/Yg=
Date: Thu, 2 Oct 2025 09:15:43 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.12 00/89] 6.12.50-rc1 review
Message-ID: <2025100225-clumsily-energy-68a9@gregkh>
References: <20250930143821.852512002@linuxfoundation.org>
 <7c481b23-d623-4fc8-9b31-78db6d1f7245@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c481b23-d623-4fc8-9b31-78db6d1f7245@roeck-us.net>

On Tue, Sep 30, 2025 at 12:18:08PM -0700, Guenter Roeck wrote:
> On 9/30/25 07:47, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.50 release.
> > There are 89 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> > Anything received after that time might be too late.
> > 
> 
> s390:allmodconfig:
> parisc:allmodconfig:
> 
> drivers/gpu/drm/i915/display/intel_backlight.c: In function 'scale':
> ././include/linux/compiler_types.h:536:45: error:
> 	call to '__compiletime_assert_666' declared with attribute error: clamp() low limit source_min greater than high limit source_max
> include/linux/compiler_types.h:517:25: note: in definition of macro '__compiletime_assert'
>   517 |                         prefix ## suffix();                             \
>       |                         ^~~~~~
> include/linux/compiler_types.h:536:9: note: in expansion of macro '_compiletime_assert'
>   536 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>       |         ^~~~~~~~~~~~~~~~~~~
> include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>       |                                     ^~~~~~~~~~~~~~~~~~
> include/linux/minmax.h:188:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>   188 |         BUILD_BUG_ON_MSG(statically_true(ulo > uhi),                            \
>       |         ^~~~~~~~~~~~~~~~
> include/linux/minmax.h:195:9: note: in expansion of macro '__clamp_once'
>   195 |         __clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
>       |         ^~~~~~~~~~~~
> include/linux/minmax.h:206:28: note: in expansion of macro '__careful_clamp'
>   206 | #define clamp(val, lo, hi) __careful_clamp(__auto_type, val, lo, hi)
>       |                            ^~~~~~~~~~~~~~~
> drivers/gpu/drm/i915/display/intel_backlight.c:47:22: note: in expansion of macro 'clamp'
>    47 |         source_val = clamp(source_val, source_min, source_max);
> 
> This is exposed by the minmax patch series, as with 6.12.49.
> 
> Fixed upstream with commit 6f7150741584 ("drm/i915/backlight: Return immediately
> when scale() finds invalid parameters"). This patch also includes an explanation
> of what exactly happens (and thanks again to Linus for the analysis).

Sorry about that, I missed this when you previously reported, my fault.
I'll go queue this up everywhere now.

thanks,

greg k-h
